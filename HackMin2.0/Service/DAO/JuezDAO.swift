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
 
    // Guarda o actualiza un juez
    func saveJuez(_ juez: JuezModel, completion: @escaping (Result<Void, Error>) -> Void) {
        database.child(juecesPath).child(juez.id_juez).setValue(juez.toDictionary()) { error, _ in
            if let error = error { completion(.failure(error)) }
            else { completion(.success(())) }
        }
    }
 
    // Obtiene un juez por ID
    func getJuez(id_juez: String, completion: @escaping (Result<JuezModel, Error>) -> Void) {
        database.child(juecesPath).child(id_juez).observeSingleEvent(of: .value) { snapshot in
            guard let dict = snapshot.value as? [String: Any],
                  let juez = JuezModel(from: dict) else {
                completion(.failure(JuezError.juezNotFound))
                return
            }
            completion(.success(juez))
        }
    }
 
    // Login de juez por correo
    func getJuezByCorreo(_ correo: String, completion: @escaping (Result<JuezModel, Error>) -> Void) {
        database.child(juecesPath)
            .queryOrdered(byChild: "correo")
            .queryEqual(toValue: correo)
            .observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? [String: [String: Any]],
                      let firstEntry = value.values.first,
                      let juez = JuezModel(from: firstEntry) else {
                    completion(.failure(JuezError.juezNotFound))
                    return
                }
                completion(.success(juez))
            }
    }
 
    func getAllJueces(completion: @escaping (Result<[JuezModel], Error>) -> Void) {
        database.child(juecesPath).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else {
                completion(.success([]))
                return
            }
            let jueces = value.compactMap { JuezModel(from: $0.value) }
            completion(.success(jueces))
        }
    }
 
    func deleteJuez(id_juez: String, completion: @escaping (Result<Void, Error>) -> Void) {
        database.child(juecesPath).child(id_juez).removeValue { error, _ in
            if let error = error { completion(.failure(error)) }
            else { completion(.success(())) }
        }
    }
 
    func asignarConcurso(id_juez: String, id_concurso: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        let value: Any = id_concurso ?? NSNull()
        database.child(juecesPath).child(id_juez).child("id_concurso_asignado").setValue(value) { error, _ in
            if let error = error { completion(.failure(error)) }
            else { completion(.success(())) }
        }
    }
}
 
enum JuezError: LocalizedError {
    case juezNotFound
    case wrongPassword
    case notAssignedToConcurso
 
    var errorDescription: String? {
        switch self {
        case .juezNotFound:           return "Juez no encontrado."
        case .wrongPassword:          return "Contraseña incorrecta."
        case .notAssignedToConcurso:  return "El juez no está asignado a ningún concurso."
        }
    }
}
