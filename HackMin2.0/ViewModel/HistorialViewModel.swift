//
//  HistorialViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 10/05/26.
//

import Foundation
import SwiftUI
import Combine

class HistorialViewModel: ObservableObject {
    @Published var concursos: [ConcursoModel] = []
    @Published var concursoSeleccionado: ConcursoModel? = nil
    @Published var mostrarDetalle: Bool = false

    func seleccionar(_ concurso: ConcursoModel) {
        concursoSeleccionado = concurso
        mostrarDetalle = true
    }
}
