//
//  JuecesViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

class JuecesViewModel: ObservableObject {
    @Published var jueces: [JuezModel] = [
        JuezModel(id_juez: "j1", id_concurso: "c1", alias: "Dr. Alejandro Méndez",  codigo_juez: "J001"),
        JuezModel(id_juez: "j2", id_concurso: "c1", alias: "Ing. Sofía Ramírez",    codigo_juez: "J002"),
        JuezModel(id_juez: "j3", id_concurso: "c1", alias: "Mtra. Carmen Vidal",    codigo_juez: "J003"),
        JuezModel(id_juez: "j4", id_concurso: "c1", alias: "Dr. Roberto Lara",      codigo_juez: "J004")
    ]

    @Published var mostrarCrearJuez: Bool = false
    var idConcurso: String = ""

    func agregarJuez(_ juez: JuezModel) {
        jueces.append(juez)
    }

    func eliminarJuez(id: String) {
        jueces.removeAll { $0.id_juez == id }
    }
}
