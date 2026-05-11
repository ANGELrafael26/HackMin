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
        
        let dao = AdministradorDAO()
        
        let newAdministrador = AdministradorModel(id: UUID(), nombre: "\(nombres) \(apellidos)", correo: "Place holder", contrasena: contrasena)
        
        dao.saveAdministrador(newAdministrador) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    CurrentUserManager.shared.setCurrentAdmin(newAdministrador)
                    CurrentUserManager.shared.isAdministrator()
                    print("Administrador guardado exitosamente en Firebase.")
                    self?.navegarPrincipal = true
                    
                case .failure(let error):
                    print("Error al guardar en Firebase: \(error.localizedDescription)")
                    self?.mensajeError = "Error al guardar los datos. Intenta de nuevo."
                    self?.mostrarError = true
                }
            }
        }
    }
}
