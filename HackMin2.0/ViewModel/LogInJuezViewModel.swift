//
//  LogInJuezViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import SwiftUI
import Combine

class LogInJuezViewModel: ObservableObject {
    @Published var codigo: String = ""
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""

    func ingresar() {
        guard !codigo.isEmpty else {
            mensajeError = "Por favor ingresa tu código."
            mostrarError = true
            return
        }
        print("Juez ingresando con código: \(codigo)")
        // Aquí va tu lógica de autenticación
    }
}
