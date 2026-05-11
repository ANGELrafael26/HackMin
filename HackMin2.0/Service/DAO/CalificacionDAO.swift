//
//  CalificacionDAO.swift
//  HackMin2.0
//
//  Created by Jesus Ortega on 11/05/26.
//

import Foundation
import FirebaseDatabase

class CalificacionDAO {

    private let database = Database.database().reference()
    private let calificacionesPath = "calificaciones"

    func saveCalificacion(_ cal: CalificacionModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let dict = cal.toDictionary() else {
            completion(.failure(CalificacionError.serializationFailed))
            return
        }
        database.child(calificacionesPath).child(cal.id_calificacion).setValue(dict) { error, _ in
            if let error = error { completion(.failure(error)) }
            else { completion(.success(())) }
        }
    }

    func getCalificacion(
        id_juez: String,
        id_equipo: String,
        completion: @escaping (Result<CalificacionModel?, Error>) -> Void
    ) {
        database.child(calificacionesPath)
            .queryOrdered(byChild: "id_juez")
            .queryEqual(toValue: id_juez)
            .observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? [String: [String: Any]] else {
                    completion(.success(nil))
                    return
                }
                let cal = value.values
                    .compactMap { CalificacionModel(from: $0) }
                    .first { $0.id_equipo == id_equipo }
                completion(.success(cal))
            }
    }

    func getCalificaciones(
        porConcurso id_concurso: String,
        completion: @escaping (Result<[CalificacionModel], Error>) -> Void
    ) {
        database.child(calificacionesPath)
            .queryOrdered(byChild: "id_concurso")
            .queryEqual(toValue: id_concurso)
            .observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? [String: [String: Any]] else {
                    completion(.success([]))
                    return
                }
                let cals = value.values.compactMap { CalificacionModel(from: $0) }
                completion(.success(cals))
            }
    }

    func deleteCalificacion(id_calificacion: String, completion: @escaping (Result<Void, Error>) -> Void) {
        database.child(calificacionesPath).child(id_calificacion).removeValue { error, _ in
            if let error = error { completion(.failure(error)) }
            else { completion(.success(())) }
        }
    }
}

enum CalificacionError: LocalizedError {
    case serializationFailed
    case calificacionNotFound

    var errorDescription: String? {
        switch self {
        case .serializationFailed:   return "No se pudo serializar la calificación."
        case .calificacionNotFound:  return "Calificación no encontrada."
        }
    }
}
