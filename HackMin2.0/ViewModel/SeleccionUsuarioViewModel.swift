//
//  SeleccionUsuarioViewModel.swift
//  HackMin2.0
//

import SwiftUI
import Combine

class SeleccionUsuarioViewModel: ObservableObject {
    @Published var mostrarPanel: Bool = false
    @Published var rolSeleccionado: String? = "administrador"
    @Published var navegarAdministrador: Bool = false
    @Published var navegarJuez: Bool = false

    func togglePanel() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            mostrarPanel.toggle()
        }
    }

    func cerrarPanel() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            mostrarPanel = false
        }
    }

    func confirmarRol(_ rol: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            rolSeleccionado = rol
        }
        if rol == "administrador" {
            navegarAdministrador = true
        } else {
            navegarJuez = true
        }
    }
}
