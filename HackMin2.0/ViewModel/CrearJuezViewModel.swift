//
//  CrearJuezViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class CrearJuezViewModel: ObservableObject {
    @Published var alias: String = ""
    @Published var codigoJuez: String = ""
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""
    
    // Instancia del DAO
    private let juezDAO = JuezDAO()

    // Actualizamos la función para que guarde directamente y notifique si fue exitoso
    func guardarJuez(idConcurso: String) {
        guard !alias.trimmingCharacters(in: .whitespaces).isEmpty else {
            mensajeError = "El alias es obligatorio."
            mostrarError = true
            return
        }
        
        
        mostrarError = false
        
        
        ConcursoJuezService.shared.crearJuez(
            nombre:     alias,
            correo:     "placeholder@gmail.com",
            contrasena: "1234"
        ) { result in
            if case .success(let juez) = result {
                ConcursoJuezService.shared.asignarJueces(
                    ids_jueces:  [juez.id_juez],
                    id_concurso: CurrentCourseService.shared.currentCursoID
                )
                { _ in }
                self.codigoJuez = juez.id_juez
            }
        }
    }
}
