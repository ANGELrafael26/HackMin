//
//  EquiposDAO.swift
//  HackMin2.0
//
//  Created by Naomi López on 08/05/26.
//

import Foundation
import FirebaseDatabase

class EquipoDAO {
    
    private let database = Database.database().reference()
    private let equiposPath = "equipos"
    
    func saveEquipo(_ equipo: EquipoModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let dictionary = equipo.toDictionary() else {
            completion(.failure(EquipoError.serializationFailed))
            return
        }
        
        database.child(equiposPath).child(equipo.id_equipo).setValue(dictionary) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getEquipo(id_equipo: String, completion: @escaping (Result<EquipoModel, Error>) -> Void) {
        database.child(equiposPath).child(id_equipo).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else {
                completion(.failure(EquipoError.equipoNotFound))
                return
            }
            
            guard let equipo = EquipoModel(from: dictionary) else {
                completion(.failure(EquipoError.deserializationFailed))
                return
            }
            
            completion(.success(equipo))
        }
    }
    
    func getEquipos(porConcurso id_concurso: String, completion: @escaping (Result<[EquipoModel], Error>) -> Void) {
        database.child(equiposPath).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else {
                completion(.success([]))
                return
            }
            
            let equipos = value.compactMap { EquipoModel(from: $0.value) }
                               .filter { $0.id_concurso == id_concurso }
            completion(.success(equipos))
        }
    }
    
    func deleteEquipo(id_equipo: String, completion: @escaping (Result<Void, Error>) -> Void) {
        database.child(equiposPath).child(id_equipo).removeValue { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

// MARK: - Errors

enum EquipoError: LocalizedError {
    case serializationFailed
    case deserializationFailed
    case equipoNotFound
    
    var errorDescription: String? {
        switch self {
        case .serializationFailed:   return "No se pudo serializar el equipo."
        case .deserializationFailed: return "No se pudo deserializar el equipo."
        case .equipoNotFound:        return "Equipo no encontrado."
        }
    }
}
