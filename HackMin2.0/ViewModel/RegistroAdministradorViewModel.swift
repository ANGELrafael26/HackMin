//
//  RegistroAdministradorViewModel.swift
//  HackMin2.0
//

import SwiftUI
import Combine

class RegistroAdministradorViewModel: ObservableObject {
    @Published var nombres: String = ""
    @Published var apellidos: String = ""
    @Published var usuario: String = ""
    @Published var contrasena: String = ""
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""
    @Published var navegarPrincipal: Bool = false

    func registrar() {
        guard !nombres.isEmpty, !apellidos.isEmpty,
              !usuario.isEmpty, !contrasena.isEmpty else {
            mensajeError = "Por favor completa todos los campos."
            mostrarError = true
            return
        }
        mostrarError = false
        print("Registrando administrador: \(nombres) \(apellidos) — usuario: \(usuario)")
        navegarPrincipal = true
    }
}
