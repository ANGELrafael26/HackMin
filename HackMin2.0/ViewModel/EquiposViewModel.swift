//
//  EquiposViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

class EquiposViewModel: ObservableObject {
    @Published var equipos: [EquipoModel] = []
    @Published var mostrarCrearEquipo: Bool = false

    func agregarEquipo(_ equipo: EquipoModel) {
        equipos.append(equipo)
    }

    func eliminarEquipo(id: String) {
        equipos.removeAll { $0.id_equipo == id }
    }
}
