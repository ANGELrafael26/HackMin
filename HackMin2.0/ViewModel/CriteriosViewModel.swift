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
    @Published var criterios: [CriterioModel] = []
    @Published var mostrarCrearCriterio: Bool = false
    @Published var cargando: Bool = false
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""

    var idConcurso: String = ""
    var idRubrica: String = "" 

    func agregarCriterio(_ criterio: CriterioModel) {
        criterios.append(criterio)
    }

    func eliminarCriterio(id: String) {
        criterios.removeAll { $0.id_criterio == id }
    }

    var pesoTotal: Double {
        criterios.map(\.peso_porcentual).reduce(0, +)
    }

    var pesoCompleto: Bool {
        abs(pesoTotal - 100.0) < 0.01
    }
}
