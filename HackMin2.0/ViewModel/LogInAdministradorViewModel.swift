//
//  LogInAdministradorViewModel.swift
//  HackMin2.0
//

import Foundation
import Combine

class LogInAdministradorViewModel: ObservableObject {
    @Published var usuario: String = ""
    @Published var contrasena: String = ""
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""
    @Published var navegarPrincipal: Bool = false
    @Published var navegarRegistro: Bool = false
    @Published var cargando: Bool = false
    
    func ingresar() {
        guard !usuario.isEmpty, !contrasena.isEmpty else {
            mensajeError = "Por favor completa todos los campos."
            mostrarError = true
            return
        }
        
        mostrarError = false
        cargando = true
        
        let dao = AdministradorDAO()
        
        dao.getAdministrador(user: usuario) { [weak self] result in
            DispatchQueue.main.async {
                self?.cargando = false
                
                switch result {
                case .success(let adminObtenido):
                    if adminObtenido.contrasena == self?.contrasena {
                        print("Inicio de sesión exitoso.")
                        CurrentUserManager.shared.setCurrentAdmin(adminObtenido)
                        self?.navegarPrincipal = true
                    } else {
                        self?.mensajeError = "Contraseña incorrecta."
                        self?.mostrarError = true
                    }
                    
                case .failure(let error):
                    print("Error al iniciar sesión: \(error.localizedDescription)")
                    self?.mensajeError = "Usuario no encontrado o error de conexión."
                    self?.mostrarError = true
                }
            }
        }
    }
    
    func crearAdministrador() {
        navegarRegistro = true
    }
}
