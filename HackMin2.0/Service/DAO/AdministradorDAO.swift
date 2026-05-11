//
//  AdministradorDAO.swift
//  HackMin2.0
//
//  Created by Naomi López on 08/05/26.
//

import Foundation
import FirebaseDatabase

class AdministradorDAO {
    
    private let database = Database.database().reference()
    private let administradoresPath = "administradores"
    
    func saveAdministrador(_ admin: AdministradorModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let dictionary = admin.toDictionary() else {
            completion(.failure(AdministradorError.serializationFailed))
            return
        }
        
        database.child(administradoresPath).child(admin.user).setValue(dictionary) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getAdministrador(user: String, completion: @escaping (Result<AdministradorModel, Error>) -> Void) {
        database.child(administradoresPath).child(user).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else {
                completion(.failure(AdministradorError.adminNotFound))
                return
            }
            
            guard let admin = AdministradorModel(from: dictionary) else {
                completion(.failure(AdministradorError.deserializationFailed))
                return
            }
            
            completion(.success(admin))
        }
    }
}

// MARK: - Errors

enum AdministradorError: LocalizedError {
    case serializationFailed
    case deserializationFailed
    case adminNotFound
    case wrongPassword
    
    var errorDescription: String? {
        switch self {
        case .serializationFailed:   return "No se pudo serializar el administrador."
        case .deserializationFailed: return "No se pudo deserializar el administrador."
        case .adminNotFound:         return "Administrador no encontrado."
        case .wrongPassword:         return "Contraseña incorrecta."
        }
    }
}
