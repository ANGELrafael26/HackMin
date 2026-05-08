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

    func ingresar() {
        guard !usuario.isEmpty, !contrasena.isEmpty else {
            mensajeError = "Por favor completa todos los campos."
            mostrarError = true
            return
        }
        print("Administrador ingresando — usuario: \(usuario)")
        // Aquí va tu lógica de autenticación
    }

    func crearAdministrador() {
        print("Navegar a crear administrador")
        // Aquí va tu lógica de navegación a creación
    }
}
