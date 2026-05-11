//
//  EquipoRubricaService.swift
//  HackMin2.0
//
//  Created by Jesus Ortega on 11/05/26.
//

import Foundation

class EquipoRubricaService {

    static let shared = EquipoRubricaService()
    private init() {}

    private let equipoDAO       = EquipoDAO()
    private let rubricaDAO      = RubricaDAO()
    private let calificacionDAO = CalificacionDAO()

    func crearEquipo(
        nombre:          String,
        nombreProyecto:  String,
        problematica:    String,
        integrantes:     [String],
        fotoPerfil:      String,
        completion: @escaping (Result<EquipoModel, Error>) -> Void
    ) {
        guard CurrentUserManager.shared.currentAdmin != nil else {
            completion(.failure(AdminError.notAuthorized))
            return
        }

        guard let idConcurso = CurrentCourseService.shared.currentConcurso?.id_concurso else {
            completion(.failure(ConectorError.noConcursoActivo))
            return
        }

        let equipo = EquipoModel(
            id_equipo:       IDGenerator.newEquipoID(),
            id_concurso:     idConcurso,
            problematica:    problematica,
            nombre_equipo:   nombre,
            nombre_proyecto: nombreProyecto,
            integrantes:     integrantes,
            foto_perfil:     fotoPerfil
        )

        equipoDAO.saveEquipo(equipo) { result in
            switch result {
            case .failure(let error): completion(.failure(error))
            case .success:            completion(.success(equipo))
            }
        }
    }

    func getEquiposConcursoActivo(completion: @escaping (Result<[EquipoModel], Error>) -> Void) {
        guard let idConcurso = CurrentCourseService.shared.currentConcurso?.id_concurso else {
            completion(.failure(ConectorError.noConcursoActivo))
            return
        }
        equipoDAO.getEquipos(porConcurso: idConcurso, completion: completion)
    }

    // MARK: - Admin: Rúbrica

    func crearRubrica(
        nombre:      String,
        descripcion: String,
        criterios:   [(nombre: String, descripcion: String, peso: Double, puntajeMax: Double)],
        completion: @escaping (Result<RubricaModel, Error>) -> Void
    ) {
        guard CurrentUserManager.shared.currentAdmin != nil else {
            completion(.failure(AdminError.notAuthorized))
            return
        }

        guard let idConcurso = CurrentCourseService.shared.currentConcurso?.id_concurso else {
            completion(.failure(ConectorError.noConcursoActivo))
            return
        }

        // Validar que los pesos sumen 100
        let totalPeso = criterios.reduce(0) { $0 + $1.peso }
        guard abs(totalPeso - 100.0) < 0.01 else {
            completion(.failure(RubricaError.pesosNoSuman100))
            return
        }

        let idRubrica = IDGenerator.newRubricaID()

        let criterioModels = criterios.map { c in
            CriterioModel(
                id_criterio:          IDGenerator.newCriterioID(),
                id_concurso:          idConcurso,
                id_rubrica:           idRubrica,
                nombre_criterio:      c.nombre,
                descripcion_criterio: c.descripcion,
                peso_porcentual:      c.peso,
                puntaje_maximo:       c.puntajeMax
            )
        }

        let rubrica = RubricaModel(
            id_rubrica:        idRubrica,
            id_concurso:       idConcurso,
            nombre_rubrica:    nombre,
            descripcion_rubrica: descripcion,
            criterios:         criterioModels
        )

        rubricaDAO.saveRubrica(rubrica) { result in
            switch result {
            case .failure(let error): completion(.failure(error))
            case .success:            completion(.success(rubrica))
            }
        }
    }

    func getRubricaConcursoActivo(completion: @escaping (Result<RubricaModel, Error>) -> Void) {
        guard let idConcurso = CurrentCourseService.shared.currentConcurso?.id_concurso else {
            completion(.failure(ConectorError.noConcursoActivo))
            return
        }
        rubricaDAO.getRubricas(porConcurso: idConcurso) { result in
            switch result {
            case .failure(let error): completion(.failure(error))
            case .success(let rubricas):
                guard let rubrica = rubricas.first else {
                    completion(.failure(RubricaError.rubricaNotFound))
                    return
                }
                completion(.success(rubrica))
            }
        }
    }


    func calificarEquipo(
        id_equipo:          String,
        puntajes_asignados: [String: Double], // ["id_criterio": puntaje]
        completion: @escaping (Result<CalificacionModel, Error>) -> Void
    ) {
        guard let juez = CurrentUserManager.shared.currentJuez else {
            completion(.failure(JuezError.juezNotFound))
            return
        }

        guard let idConcurso = CurrentCourseService.shared.currentConcurso?.id_concurso else {
            completion(.failure(ConectorError.noConcursoActivo))
            return
        }
        calificacionDAO.getCalificacion(id_juez: juez.id_juez, id_equipo: id_equipo) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                completion(.failure(error))

            case .success(let existente):
                let calificacion = CalificacionModel(
                    id_calificacion:    existente?.id_calificacion ?? IDGenerator.newCalificacionID(),
                    id_concurso:        idConcurso,
                    id_equipo:          id_equipo,
                    id_juez:            juez.id_juez,
                    puntajes_asignados: puntajes_asignados
                )

                self.calificacionDAO.saveCalificacion(calificacion) { saveResult in
                    switch saveResult {
                    case .failure(let error): completion(.failure(error))
                    case .success:            completion(.success(calificacion))
                    }
                }
            }
        }
    }

    func getResultados(
        completion: @escaping (Result<[(equipo: EquipoModel, puntaje: Double)], Error>) -> Void
    ) {
        guard let idConcurso = CurrentCourseService.shared.currentConcurso?.id_concurso else {
            completion(.failure(ConectorError.noConcursoActivo))
            return
        }

        let group = DispatchGroup()
        var equipos:        [EquipoModel]        = []
        var calificaciones: [CalificacionModel]  = []
        var rubrica:        RubricaModel?        = nil
        var firstError:     Error?               = nil

        group.enter()
        equipoDAO.getEquipos(porConcurso: idConcurso) { res in
            switch res {
            case .success(let e): equipos = e
            case .failure(let e): firstError = e
            }
            group.leave()
        }

        group.enter()
        calificacionDAO.getCalificaciones(porConcurso: idConcurso) { res in
            switch res {
            case .success(let c): calificaciones = c
            case .failure(let e): firstError = e
            }
            group.leave()
        }

        group.enter()
        rubricaDAO.getRubricas(porConcurso: idConcurso) { res in
            switch res {
            case .success(let r): rubrica = r.first
            case .failure(let e): firstError = e
            }
            group.leave()
        }

        group.notify(queue: .main) {
            if let error = firstError {
                completion(.failure(error))
                return
            }

            guard let rubrica else {
                completion(.failure(RubricaError.rubricaNotFound))
                return
            }

            let criterioMap = Dictionary(
                uniqueKeysWithValues: rubrica.criterios.map {
                    ($0.id_criterio, (max: $0.puntaje_maximo, peso: $0.peso_porcentual))
                }
            )

            func calcularPuntaje(_ cal: CalificacionModel) -> Double {
                cal.puntajes_asignados.reduce(0.0) { total, entry in
                    guard let info = criterioMap[entry.key] else { return total }
                    return total + (entry.value / info.max) * info.peso
                }
            }

            let resultado: [(equipo: EquipoModel, puntaje: Double)] = equipos.map { equipo in
                let calsDelEquipo = calificaciones.filter { $0.id_equipo == equipo.id_equipo }
                let promedio: Double
                if calsDelEquipo.isEmpty {
                    promedio = 0.0
                } else {
                    promedio = calsDelEquipo.map { calcularPuntaje($0) }.reduce(0, +) / Double(calsDelEquipo.count)
                }
                return (equipo: equipo, puntaje: promedio)
            }
            .sorted { $0.puntaje > $1.puntaje }

            completion(.success(resultado))
        }
    }
}




