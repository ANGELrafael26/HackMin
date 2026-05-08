//
//  DetalleEquipoViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

struct PuntajeCriterio {
    let criterio: String
    let valor: Double
}

struct JuezCalificacionItem: Identifiable {
    let id = UUID()
    let juez: JuezModel
    let calificacion: CalificacionModel
    let puntajes: [PuntajeCriterio]

    var promedio: Double {
        guard !puntajes.isEmpty else { return 0 }
        return puntajes.map(\.valor).reduce(0, +) / Double(puntajes.count)
    }
}

class DetalleEquipoViewModel: ObservableObject {
    @Published var calificaciones: [JuezCalificacionItem] = []
    let idEquipo: String

    var promedioGeneral: Double {
        guard !calificaciones.isEmpty else { return 0 }
        return calificaciones.map(\.promedio).reduce(0, +) / Double(calificaciones.count)
    }

    init(idEquipo: String) {
        self.idEquipo = idEquipo
        cargarDatosPrueba()
    }

    private func cargarDatosPrueba() {
        let jueces = [
            JuezModel(id_juez: "j1", id_concurso: "c1", alias: "Dr. Alejandro Méndez", codigo_juez: "J001"),
            JuezModel(id_juez: "j2", id_concurso: "c1", alias: "Ing. Sofía Ramírez",   codigo_juez: "J002"),
            JuezModel(id_juez: "j3", id_concurso: "c1", alias: "Mtra. Carmen Vidal",   codigo_juez: "J003"),
            JuezModel(id_juez: "j4", id_concurso: "c1", alias: "Dr. Roberto Lara",     codigo_juez: "J004")
        ]

        let califs = [
            CalificacionModel(
                id_calificacion: "cal1", id_concurso: "c1", id_equipo: idEquipo, id_juez: "j1",
                puntajes_asignados: ["Innovación": 9.5, "Impacto social": 8.0, "Factibilidad": 7.5, "Presentación": 9.0]
            ),
            CalificacionModel(
                id_calificacion: "cal2", id_concurso: "c1", id_equipo: idEquipo, id_juez: "j2",
                puntajes_asignados: ["Innovación": 8.5, "Impacto social": 9.0, "Factibilidad": 8.0, "Presentación": 7.5]
            ),
            CalificacionModel(
                id_calificacion: "cal3", id_concurso: "c1", id_equipo: idEquipo, id_juez: "j3",
                puntajes_asignados: ["Innovación": 7.0, "Impacto social": 8.5, "Factibilidad": 9.5, "Presentación": 8.0]
            ),
            CalificacionModel(
                id_calificacion: "cal4", id_concurso: "c1", id_equipo: idEquipo, id_juez: "j4",
                puntajes_asignados: ["Innovación": 10.0, "Impacto social": 9.5, "Factibilidad": 8.5, "Presentación": 9.0]
            )
        ]

        // Une cada juez con su calificación
        calificaciones = jueces.compactMap { juez in
            guard let calif = califs.first(where: { $0.id_juez == juez.id_juez }) else { return nil }
            let puntajes = calif.puntajes_asignados.map { PuntajeCriterio(criterio: $0.key, valor: $0.value) }
                .sorted { $0.criterio < $1.criterio }
            return JuezCalificacionItem(juez: juez, calificacion: calif, puntajes: puntajes)
        }
    }
}
