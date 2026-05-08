//
//  ConcursoDAO.swift
//  HackMin2.0
//
//  Created by Naomi López on 08/05/26.
//

import Foundation
import FirebaseDatabase

class ConcursoDAO {
    
    private let database = Database.database().reference()
    private let concursosPath = "concursos"
    
    func saveConcurso(_ concurso: ConcursoModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let dictionary = concurso.toDictionary() else {
            completion(.failure(ConcursoError.serializationFailed))
            return
        }
        
        database.child(concursosPath).child(concurso.id_concurso).setValue(dictionary) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getConcurso(id_concurso: String, completion: @escaping (Result<ConcursoModel, Error>) -> Void) {
        database.child(concursosPath).child(id_concurso).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else {
                completion(.failure(ConcursoError.concursoNotFound))
                return
            }
            
            guard let concurso = ConcursoModel(from: dictionary) else {
                completion(.failure(ConcursoError.deserializationFailed))
                return
            }
            
            completion(.success(concurso))
        }
    }
    
    func getAllConcursos(completion: @escaping (Result<[ConcursoModel], Error>) -> Void) {
        database.child(concursosPath).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else {
                completion(.success([]))
                return
            }
            
            let concursos = value.compactMap { ConcursoModel(from: $0.value) }
            completion(.success(concursos))
        }
    }
    
    func deleteConcurso(id_concurso: String, completion: @escaping (Result<Void, Error>) -> Void) {
        database.child(concursosPath).child(id_concurso).removeValue { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

// MARK: - Errors

enum ConcursoError: LocalizedError {
    case serializationFailed
    case deserializationFailed
    case concursoNotFound
    
    var errorDescription: String? {
        switch self {
        case .serializationFailed:   return "No se pudo serializar el concurso."
        case .deserializationFailed: return "No se pudo deserializar el concurso."
        case .concursoNotFound:      return "Concurso no encontrado."
        }
    }
}
