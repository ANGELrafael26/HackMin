//
//  RubricaJuezViewModel.swift
//  HackMin2.0
//
//  Created by Naomi López on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

class RubricaJuezViewModel: ObservableObject {
    @Published var calificaciones: [String: String] = [:]
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""
    @Published var calificacionEnviada: Bool = false

    func calificacion(para criterio: CriterioModel) -> Binding<String> {
        Binding(
            get: { self.calificaciones[criterio.id_criterio] ?? "" },
            set: { nuevoValor in
                if nuevoValor.isEmpty {
                    self.calificaciones[criterio.id_criterio] = nuevoValor
                    return
                }
                if let num = Double(nuevoValor) {
                    if num <= criterio.puntaje_maximo {
                        self.calificaciones[criterio.id_criterio] = nuevoValor
                    } else {
                        self.calificaciones[criterio.id_criterio] = String(Int(criterio.puntaje_maximo))
                    }
                }
               
            }
        )
    }

    func puntajeTotal(rubrica: RubricaModel) -> Double {
        rubrica.criterios.compactMap { criterio -> Double? in
            guard let val = calificaciones[criterio.id_criterio],
                  let num = Double(val),
                  criterio.puntaje_maximo > 0 else { return nil }
            return (num / criterio.puntaje_maximo) * criterio.peso_porcentual
        }.reduce(0, +)
    }

    // Indica si el criterio tiene un valor válido ingresado
    func calificacionValida(para criterio: CriterioModel) -> Bool {
        guard let val = calificaciones[criterio.id_criterio],
              let num = Double(val) else { return false }
        return num >= 0 && num <= criterio.puntaje_maximo
    }

    func enviarCalificacion(rubrica: RubricaModel, equipo: EquipoModel) {
        // Validar que todos los criterios tienen valor
        for criterio in rubrica.criterios {
            let val = calificaciones[criterio.id_criterio] ?? ""
            guard let num = Double(val) else {
                mensajeError = "Ingresa un valor numérico en '\(criterio.nombre_criterio)'."
                mostrarError = true
                return
            }
            guard num >= 0, num <= criterio.puntaje_maximo else {
                mensajeError = "'\(criterio.nombre_criterio)' debe estar entre 0 y \(Int(criterio.puntaje_maximo))."
                mostrarError = true
                return
            }
        }

        let total = puntajeTotal(rubrica: rubrica)
        guard total <= 100 else {
            mensajeError = "El puntaje total no puede superar 100% (actual: \(String(format: "%.1f", total))%)."
            mostrarError = true
            return
        }

        mostrarError = false

        // Construir el diccionario de puntajes
        let puntajes: [String: Double] = calificaciones.compactMapValues { Double($0) }

        EquipoRubricaService.shared.calificarEquipo(
            id_equipo:          equipo.id_equipo,
            puntajes_asignados: puntajes
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success:
                    self.calificacionEnviada = true
                case .failure(let error):
                    self.mensajeError = error.localizedDescription
                    self.mostrarError = true
                }
            }
        }
    }
}
