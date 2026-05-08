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
            set: { self.calificaciones[criterio.id_criterio] = $0 }
        )
    }

    func enviarCalificacion(rubrica: RubricaModel, equipo: EquipoModel) {
        // Validar que todos los criterios tengan calificación
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
        mostrarError = false
        calificacionEnviada = true
        print("Calificación enviada para equipo: \(equipo.nombre_equipo)")
        calificaciones.forEach { print("  \($0.key): \($0.value)") }
    }

    func puntajeTotal(rubrica: RubricaModel) -> Double {
        rubrica.criterios.compactMap { criterio -> Double? in
            guard let val = calificaciones[criterio.id_criterio],
                  let num = Double(val) else { return nil }
            return (num / criterio.puntaje_maximo) * criterio.peso_porcentual
        }.reduce(0, +)
    }
}
