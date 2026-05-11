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
    let valor:    Double
    let peso:     Double
    let maximo:   Double
}

struct JuezCalificacionItem: Identifiable {
    let id = UUID()
    let juez: JuezModel
    let calificacion: CalificacionModel
    let puntajes: [PuntajeCriterio]

    var promedio: Double {
        puntajes.reduce(0.0) { total, p in
            guard p.maximo > 0 else { return total }
            return total + (p.valor / p.maximo) * p.peso
        }
    }
}

@MainActor
class DetalleEquipoViewModel: ObservableObject {
    @Published var calificaciones: [JuezCalificacionItem] = []
    @Published var cargando: Bool = true
    let idEquipo: String

    var promedioGeneral: Double {
        guard !calificaciones.isEmpty else { return 0 }
        return calificaciones.map(\.promedio).reduce(0, +) / Double(calificaciones.count)
    }

    init(idEquipo: String) {
        self.idEquipo = idEquipo
        cargarCalificaciones()
    }

    func cargarCalificaciones() {
        EquipoRubricaService.shared.getCalificacionesDeEquipo(id_equipo: idEquipo) { [weak self] result in
            guard let self else { return }
            self.cargando = false
            switch result {
            case .success(let items):
                self.calificaciones = items
            case .failure(let error):
                print("Error al cargar calificaciones: \(error.localizedDescription)")
            }
        }
    }
}
