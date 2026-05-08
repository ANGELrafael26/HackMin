//
//  RubricaDAO.swift
//  HackMin2.0
//
//  Created by Naomi López on 08/05/26.
//

import Foundation
import FirebaseDatabase

class RubricaDAO {
    
    private let database = Database.database().reference()
    private let rubricasPath = "rubricas"
    
    func saveRubrica(_ rubrica: RubricaModel, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let dictionary = rubrica.toDictionary() else {
            completion(.failure(RubricaError.serializationFailed))
            return
        }
        
        database.child(rubricasPath).child(rubrica.id_rubrica).setValue(dictionary) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getRubrica(id_rubrica: String, completion: @escaping (Result<RubricaModel, Error>) -> Void) {
        database.child(rubricasPath).child(id_rubrica).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else {
                completion(.failure(RubricaError.rubricaNotFound))
                return
            }
            
            guard let rubrica = RubricaModel(from: dictionary) else {
                completion(.failure(RubricaError.deserializationFailed))
                return
            }
            
            completion(.success(rubrica))
        }
    }
    
    func getRubricas(porConcurso id_concurso: String, completion: @escaping (Result<[RubricaModel], Error>) -> Void) {
        database.child(rubricasPath).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else {
                completion(.success([]))
                return
            }
            
            let rubricas = value.compactMap { RubricaModel(from: $0.value) }
                               .filter { $0.id_concurso == id_concurso }
            completion(.success(rubricas))
        }
    }
    
    func deleteRubrica(id_rubrica: String, completion: @escaping (Result<Void, Error>) -> Void) {
        database.child(rubricasPath).child(id_rubrica).removeValue { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

// MARK: - Errors

enum RubricaError: LocalizedError {
    case serializationFailed
    case deserializationFailed
    case rubricaNotFound
    
    var errorDescription: String? {
        switch self {
        case .serializationFailed:   return "No se pudo serializar la rúbrica."
        case .deserializationFailed: return "No se pudo deserializar la rúbrica."
        case .rubricaNotFound:       return "Rúbrica no encontrada."
        }
    }
}
