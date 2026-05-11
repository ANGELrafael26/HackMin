//
//  CrearRubricaViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.


import Foundation
import SwiftUI
import Combine

@MainActor
class CrearRubricaViewModel: ObservableObject {
    @Published var nombreRubrica: String = ""
    @Published var descripcion: String = ""
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""
    @Published var cargando: Bool = false

    private(set) var rubricaTemporal: RubricaModel? = nil

    func prepararRubrica() -> RubricaModel? {
        guard !nombreRubrica.trimmingCharacters(in: .whitespaces).isEmpty else {
            mensajeError = "El nombre de la rúbrica es obligatorio."
            mostrarError = true
            return nil
        }
        guard !descripcion.trimmingCharacters(in: .whitespaces).isEmpty else {
            mensajeError = "La descripción es obligatoria."
            mostrarError = true
            return nil
        }
        mostrarError = false

        let rubrica = RubricaModel(
            id_rubrica:          IDGenerator.newRubricaID(),
            id_concurso:         CurrentCourseService.shared.currentCursoID,
            nombre_rubrica:      nombreRubrica.trimmingCharacters(in: .whitespaces),
            descripcion_rubrica: descripcion.trimmingCharacters(in: .whitespaces),
            criterios:           []
        )
        rubricaTemporal = rubrica
        return rubrica
    }

    func guardarRubrica(
        criterios: [CriterioModel],
        completion: @escaping (Result<RubricaModel, Error>) -> Void
    ) {
        guard var rubrica = rubricaTemporal else {
            mensajeError = "No hay rúbrica preparada."
            mostrarError = true
            return
        }

        guard !criterios.isEmpty else {
            mensajeError = "Agrega al menos un criterio antes de guardar."
            mostrarError = true
            return
        }

        let pesoTotal = criterios.map(\.peso_porcentual).reduce(0, +)
        guard abs(pesoTotal - 100.0) < 0.01 else {
            mensajeError = "Los pesos deben sumar exactamente 100%. Actualmente suman \(Int(pesoTotal))%."
            mostrarError = true
            return
        }

        mostrarError = false
        cargando = true
        rubrica.criterios = criterios

        EquipoRubricaService.shared.crearRubrica(
            nombre:      rubrica.nombre_rubrica,
            descripcion: rubrica.descripcion_rubrica,
            criterios:   criterios.map { (
                nombre:      $0.nombre_criterio,
                descripcion: $0.descripcion_criterio,
                peso:        $0.peso_porcentual,
                puntajeMax:  $0.puntaje_maximo
            )}
        ) { [weak self] result in
            guard let self else { return }
            self.cargando = false
            switch result {
            case .success(let rubricaGuardada):
                completion(.success(rubricaGuardada))
            case .failure(let error):
                self.mensajeError = error.localizedDescription
                self.mostrarError = true
                completion(.failure(error))
            }
        }
    }
}
