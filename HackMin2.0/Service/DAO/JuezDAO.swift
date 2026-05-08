//
//  JuezDAO.swift
//  HackMin2.0
//
//  Created by Naomi López on 08/05/26.
//

import Foundation
import FirebaseDatabase

class JuezDAO {
    
    private let database = Database.database().reference()
    private let juecesPath = "jueces"
    
    // MARK: - Generar código
    
    static func generarCodigo() -> String {
        let codigo = Int.random(in: 10000...99999)
        return String(codigo)
    }
    
    // MARK: - Save
    
    func saveJuez(_ juez: JuezModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let dictionary = juez.toDictionary() else {
            completion(.failure(JuezError.serializationFailed))
            return
        }
        
        database.child(juecesPath).child(juez.id_juez).setValue(dictionary) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getJuez(id_juez: String, completion: @escaping (Result<JuezModel, Error>) -> Void) {
        database.child(juecesPath).child(id_juez).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else {
                completion(.failure(JuezError.juezNotFound))
                return
            }
            
            guard let juez = JuezModel(from: dictionary) else {
                completion(.failure(JuezError.deserializationFailed))
                return
            }
            
            completion(.success(juez))
        }
    }
    
    func getJueces(porConcurso id_concurso: String, completion: @escaping (Result<[JuezModel], Error>) -> Void) {
        database.child(juecesPath).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else {
                completion(.success([]))
                return
            }
            
            let jueces = value.compactMap { JuezModel(from: $0.value) }
                              .filter { $0.id_concurso == id_concurso }
            completion(.success(jueces))
        }
    }
    
    // MARK: - Login Juez
    
    func loginJuez(codigo: String, completion: @escaping (Result<JuezModel, Error>) -> Void) {
        database.child(juecesPath).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else {
                completion(.failure(JuezError.juezNotFound))
                return
            }
            
            let jueces = value.compactMap { JuezModel(from: $0.value) }
            
            guard let juez = jueces.first(where: { $0.codigo_juez == codigo }) else {
                completion(.failure(JuezError.codigoInvalido))
                return
            }
            
            completion(.success(juez))
        }
    }
    
    func deleteJuez(id_juez: String, completion: @escaping (Result<Void, Error>) -> Void) {
        database.child(juecesPath).child(id_juez).removeValue { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

// MARK: - Errors

enum JuezError: LocalizedError {
    case serializationFailed
    case deserializationFailed
    case juezNotFound
    case codigoInvalido
    
    var errorDescription: String? {
        switch self {
        case .serializationFailed:   return "No se pudo serializar el juez."
        case .deserializationFailed: return "No se pudo deserializar el juez."
        case .juezNotFound:          return "Juez no encontrado."
        case .codigoInvalido:        return "Código inválido."
        }
    }
}
