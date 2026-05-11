//
//  ConectorConcursoDAO.swift
//  HackMin2.0
//
//  Created by Jesus Ortega on 10/05/26.
//

import Foundation
import FirebaseDatabase

class ConectorConcursoDAO {
 
    private let database = Database.database().reference()
    private let conectoresPath = "conectores_concurso"
 
    func saveConector(_ conector: ConectorConcursoModel, completion: @escaping (Result<Void, Error>) -> Void) {
        database.child(conectoresPath).child(conector.id_concurso).setValue(conector.toDictionary()) { error, _ in
            if let error = error { completion(.failure(error)) }
            else { completion(.success(())) }
        }
    }
 
    func getConector(id_concurso: String, completion: @escaping (Result<ConectorConcursoModel, Error>) -> Void) {
        database.child(conectoresPath).child(id_concurso).observeSingleEvent(of: .value) { snapshot in
            guard let dict = snapshot.value as? [String: Any],
                  let conector = ConectorConcursoModel(from: dict) else {
                completion(.failure(ConectorError.conectorNotFound))
                return
            }
            completion(.success(conector))
        }
    }
 
    func getConcursoActivo(completion: @escaping (Result<ConectorConcursoModel?, Error>) -> Void) {
        database.child(conectoresPath)
            .queryOrdered(byChild: "activo")
            .queryEqual(toValue: true)
            .observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? [String: [String: Any]] else {
                    completion(.success(nil)) // No hay concurso activo
                    return
                }
                // Tomamos el primero (regla: solo puede haber uno activo)
                let conector = value.values.compactMap { ConectorConcursoModel(from: $0) }.first
                completion(.success(conector))
            }
    }
 
    func agregarJuez(id_concurso: String, id_juez: String, completion: @escaping (Result<Void, Error>) -> Void) {
        database.child(conectoresPath).child(id_concurso).child("id_jueces").child(id_juez).setValue(true) { error, _ in
            if let error = error { completion(.failure(error)) }
            else { completion(.success(())) }
        }
    }
 
    func removerJuez(id_concurso: String, id_juez: String, completion: @escaping (Result<Void, Error>) -> Void) {
        database.child(conectoresPath).child(id_concurso).child("id_jueces").child(id_juez).removeValue { error, _ in
            if let error = error { completion(.failure(error)) }
            else { completion(.success(())) }
        }
    }
 
    func finalizarConcurso(id_concurso: String, completion: @escaping (Result<Void, Error>) -> Void) {
        database.child(conectoresPath).child(id_concurso).child("activo").setValue(false) { error, _ in
            if let error = error { completion(.failure(error)) }
            else { completion(.success(())) }
        }
    }
 
    func deleteConector(id_concurso: String, completion: @escaping (Result<Void, Error>) -> Void) {
        database.child(conectoresPath).child(id_concurso).removeValue { error, _ in
            if let error = error { completion(.failure(error)) }
            else { completion(.success(())) }
        }
    }
}
 
enum ConectorError: LocalizedError {
    case conectorNotFound
    case concursoYaActivo
    case noConcursoActivo
 
    var errorDescription: String? {
        switch self {
        case .conectorNotFound:   return "No se encontró el conector para ese concurso."
        case .concursoYaActivo:   return "Ya existe un concurso activo. Finalízalo antes de crear uno nuevo."
        case .noConcursoActivo: return "No curso activo"
        }
    }
}
