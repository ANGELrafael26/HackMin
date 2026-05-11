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
    @Published var concursos: [ConcursoModel] = [
        ConcursoModel(
            id_concurso: "abc-123-xyz",
            nombre_evento: "Hackathon 2026",
            fecha_inicio: "01/06/2026",
            fecha_fin: "03/06/2026"
        )
    ]
    @Published var concursoSeleccionado: ConcursoModel? = nil
    @Published var mostrarDetalle: Bool = false

    func seleccionar(_ concurso: ConcursoModel) {
        concursoSeleccionado = concurso
        mostrarDetalle = true
    }
}
