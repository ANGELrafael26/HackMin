//
//  CriteriosViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

class CriteriosViewModel: ObservableObject {
    @Published var criterios: [CriterioModel] = [
        CriterioModel(
            id_criterio: "cr1", id_concurso: "c1", id_rubrica: "r1",
            nombre_criterio: "Innovación",
            descripcion_criterio: "Qué tan original y creativa es la solución propuesta.",
            peso_porcentual: 30.0,
            puntaje_maximo: 10.0
        ),
        CriterioModel(
            id_criterio: "cr2", id_concurso: "c1", id_rubrica: "r1",
            nombre_criterio: "Impacto social",
            descripcion_criterio: "Beneficio real que la solución genera en la comunidad.",
            peso_porcentual: 25.0,
            puntaje_maximo: 10.0
        ),
        CriterioModel(
            id_criterio: "cr3", id_concurso: "c1", id_rubrica: "r1",
            nombre_criterio: "Factibilidad",
            descripcion_criterio: "Viabilidad técnica y económica de implementar el proyecto.",
            peso_porcentual: 25.0,
            puntaje_maximo: 10.0
        ),
        CriterioModel(
            id_criterio: "cr4", id_concurso: "c1", id_rubrica: "r1",
            nombre_criterio: "Presentación",
            descripcion_criterio: "Claridad, orden y calidad de la exposición del equipo.",
            peso_porcentual: 20.0,
            puntaje_maximo: 10.0
        )
    ]

    @Published var mostrarCrearCriterio: Bool = false
    var idConcurso: String = ""

    func agregarCriterio(_ criterio: CriterioModel) {
        criterios.append(criterio)
    }

    func eliminarCriterio(id: String) {
        criterios.removeAll { $0.id_criterio == id }
    }

    var pesoTotal: Double {
        criterios.map(\.peso_porcentual).reduce(0, +)
    }
}
