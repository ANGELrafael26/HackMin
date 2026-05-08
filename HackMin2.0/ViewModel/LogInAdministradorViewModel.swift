//
//  LogInAdministradorViewModel.swift
//  HackMin2.0
//

import SwiftUI
import Combine

class LogInAdministradorViewModel: ObservableObject {
    @Published var usuario: String = ""
    @Published var contrasena: String = ""
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""
    @Published var navegarPrincipal: Bool = false
    @Published var navegarRegistro: Bool = false

    func ingresar() {
        guard !usuario.isEmpty, !contrasena.isEmpty else {
            mensajeError = "Por favor completa todos los campos."
            mostrarError = true
            return
        }
        mostrarError = false
        navegarPrincipal = true
    }

    func crearAdministrador() {
        navegarRegistro = true
    }
}
