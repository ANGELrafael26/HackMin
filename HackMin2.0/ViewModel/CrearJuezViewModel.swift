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
        
        codigoJuez = JuezDAO.generarCodigo()
        
        mostrarError = false
        
        let nuevoJuez = JuezModel(
            id_juez: UUID().uuidString,
            id_concurso: idConcurso,
            alias: alias.trimmingCharacters(in: .whitespaces),
            codigo_juez: codigoJuez.trimmingCharacters(in: .whitespaces)
        )
        
        // Llamada al DAO para guardar
        juezDAO.saveJuez(nuevoJuez) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.mostrarError = false
                case .failure(let error):
                    self?.mensajeError = error.localizedDescription
                    self?.mostrarError = true
                }
            }
        }
    }
}
