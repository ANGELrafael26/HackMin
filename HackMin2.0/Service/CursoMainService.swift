//
//  CursoMainService.swift
//  HackMin2.0
//
//  Created by Jesus Ortega on 10/05/26.
//

import Foundation

class ConcursoJuezService {
 
    static let shared = ConcursoJuezService()
    private init() {}
 
    private let concursoDAO  = ConcursoDAO()
    private let juezDAO      = JuezDAO()
    private let conectorDAO  = ConectorConcursoDAO()
 
    func crearConcurso(
        nombre:      String,
        fechaInicio: String,
        fechaFin:    String,
        completion: @escaping (Result<ConcursoModel, Error>) -> Void
    ) {
        guard let admin = CurrentUserManager.shared.currentAdmin else {
            completion(.failure(AdminError.notAuthorized))
            return
        }
 
        conectorDAO.getConcursoActivo { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                completion(.failure(error))
 
            case .success(let activo):
                if activo != nil {
                    completion(.failure(ConectorError.concursoYaActivo))
                    return
                }
 
                let nuevoID  = IDGenerator.newConcursoID()
                let concurso = ConcursoModel(
                    id_concurso:   nuevoID,
                    nombre_evento: nombre,
                    fecha_inicio:  fechaInicio,
                    fecha_fin:     fechaFin
                )
 
                self.concursoDAO.saveConcurso(concurso) { saveResult in
                    switch saveResult {
                    case .failure(let error):
                        completion(.failure(error))
 
                    case .success:
                        let conector = ConectorConcursoModel(
                            id_concurso: nuevoID,
                            id_jueces:   [],
                            id_admin:    admin.id.uuidString,
                            activo:      true
                        )
                        self.conectorDAO.saveConector(conector) { conectorResult in
                            switch conectorResult {
                            case .failure(let error):
                                completion(.failure(error))
                            case .success:
                                CurrentCourseService.shared.currentConcurso = concurso
                                completion(.success(concurso))
                            }
                        }
                    }
                }
            }
        }
    }
    
    func finalizarConcursoActivo(completion: @escaping (Result<Void, Error>) -> Void) {
        guard CurrentUserManager.shared.currentAdmin != nil else {
            completion(.failure(AdminError.notAuthorized))
            return
        }
 
        conectorDAO.getConcursoActivo { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                completion(.failure(error))
 
            case .success(let conector):
                guard let conector else {
                    completion(.failure(ConectorError.noConcursoActivo))
                    return
                }
 
                let group = DispatchGroup()
                var firstError: Error?
 
                group.enter()
                self.conectorDAO.finalizarConcurso(id_concurso: conector.id_concurso) { res in
                    if case .failure(let e) = res { firstError = e }
                    group.leave()
                }
 
                for idJuez in conector.id_jueces {
                    group.enter()
                    self.juezDAO.asignarConcurso(id_juez: idJuez, id_concurso: nil) { res in
                        if case .failure(let e) = res { firstError = e }
                        group.leave()
                    }
                }
 
                group.notify(queue: .main) {
                    if let error = firstError {
                        completion(.failure(error))
                    } else {
                        CurrentCourseService.shared.currentConcurso = nil
                        completion(.success(()))
                    }
                }
            }
        }
    }

    func crearJuez(
        nombre:     String,
        correo:     String,
        contrasena: String,
        completion: @escaping (Result<JuezModel, Error>) -> Void
    ) {
        guard CurrentUserManager.shared.currentAdmin != nil else {
            completion(.failure(AdminError.notAuthorized))
            return
        }
 
        let nuevoJuez = JuezModel(
            id_juez:    IDGenerator.newJuezID(),
            nombre:     nombre,
            correo:     correo,
            contrasena: contrasena
        )
 
        juezDAO.saveJuez(nuevoJuez) { result in
            switch result {
            case .failure(let error): completion(.failure(error))
            case .success:            completion(.success(nuevoJuez))
            }
        }
    }

    func asignarJueces(
        ids_jueces:  [String],
        id_concurso: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard CurrentUserManager.shared.currentAdmin != nil else {
            completion(.failure(AdminError.notAuthorized))
            return
        }
 
        let group = DispatchGroup()
        var firstError: Error?
 
        for idJuez in ids_jueces {
            group.enter()
            juezDAO.asignarConcurso(id_juez: idJuez, id_concurso: id_concurso) { res in
                if case .failure(let e) = res { firstError = e }
                group.leave()
            }
            group.enter()
            conectorDAO.agregarJuez(id_concurso: id_concurso, id_juez: idJuez) { res in
                if case .failure(let e) = res { firstError = e }
                group.leave()
            }
        }
 
        group.notify(queue: .main) {
            if let error = firstError { completion(.failure(error)) }
            else { completion(.success(())) }
        }
    }

    func removerJuez(
        id_juez:     String,
        id_concurso: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard CurrentUserManager.shared.currentAdmin != nil else {
            completion(.failure(AdminError.notAuthorized))
            return
        }
 
        let group = DispatchGroup()
        var firstError: Error?
 
        group.enter()
        juezDAO.asignarConcurso(id_juez: id_juez, id_concurso: nil) { res in
            if case .failure(let e) = res { firstError = e }
            group.leave()
        }
 
        group.enter()
        conectorDAO.removerJuez(id_concurso: id_concurso, id_juez: id_juez) { res in
            if case .failure(let e) = res { firstError = e }
            group.leave()
        }
 
        group.notify(queue: .main) {
            if let error = firstError { completion(.failure(error)) }
            else { completion(.success(())) }
        }
    }
 

    func loginJuez(
        user:     String,
        completion: @escaping (Result<(JuezModel, ConcursoModel), Error>) -> Void
    ) {
        juezDAO.getJuezByCorreo(user) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                completion(.failure(error))
 
            case .success(let juez):
                guard let idConcurso = juez.id_concurso_asignado else {
                    completion(.failure(JuezError.notAssignedToConcurso))
                    return
                }
 
                self.concursoDAO.getConcurso(id_concurso: idConcurso) { concursoResult in
                    switch concursoResult {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let concurso):
                        CurrentUserManager.shared.setCurrentJuez(juez: juez)
                        CurrentCourseService.shared.currentConcurso = concurso
                        completion(.success((juez, concurso)))
                    }
                }
            }
        }
    }
 
    func getJueces(
        deConcurso id_concurso: String,
        completion: @escaping (Result<[JuezModel], Error>) -> Void
    ) {
        conectorDAO.getConector(id_concurso: id_concurso) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                completion(.failure(error))
 
            case .success(let conector):
                guard !conector.id_jueces.isEmpty else {
                    completion(.success([]))
                    return
                }
 
                let group = DispatchGroup()
                var jueces: [JuezModel] = []
                var firstError: Error?
 
                for idJuez in conector.id_jueces {
                    group.enter()
                    self.juezDAO.getJuez(id_juez: idJuez) { res in
                        switch res {
                        case .success(let j): jueces.append(j)
                        case .failure(let e): firstError = e
                        }
                        group.leave()
                    }
                }
 
                group.notify(queue: .main) {
                    if let error = firstError { completion(.failure(error)) }
                    else { completion(.success(jueces)) }
                }
            }
        }
    }
}
 
enum AdminError: LocalizedError {
    case notAuthorized
    var errorDescription: String? { "Solo el administrador puede realizar esta acción." }
}
