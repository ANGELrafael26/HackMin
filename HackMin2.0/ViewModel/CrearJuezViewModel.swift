//
//  CrearJuezViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

class CrearJuezViewModel: ObservableObject {
    @Published var alias: String = ""
    @Published var codigoJuez: String = ""
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""

    func crearJuez(idConcurso: String) -> JuezModel? {
        guard !alias.trimmingCharacters(in: .whitespaces).isEmpty else {
            mensajeError = "El alias es obligatorio."
            mostrarError = true
            return nil
        }
        guard !codigoJuez.trimmingCharacters(in: .whitespaces).isEmpty else {
            mensajeError = "El código del juez es obligatorio."
            mostrarError = true
            return nil
        }
        mostrarError = false
        return JuezModel(
            id_juez: UUID().uuidString,
            id_concurso: idConcurso,
            alias: alias.trimmingCharacters(in: .whitespaces),
            codigo_juez: codigoJuez.trimmingCharacters(in: .whitespaces)
        )
    }
}
