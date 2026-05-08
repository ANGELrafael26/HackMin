//
//  EquiposViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

class EquiposViewModel: ObservableObject {
    @Published var equipos: [EquipoModel] = []
    
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""
    
    @Published var mostrarCrearEquipo: Bool = false
    
    private let equipoDAO = EquipoDAO()
    
    
    var idConcurso: String = ""
    
    func cargarEquipos() {
            guard !idConcurso.isEmpty else {
                mensajeError = "No se ha especificado un concurso."
                mostrarError = true
                return
            }
            
            equipoDAO.getEquipos(porConcurso: idConcurso) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let equiposObtenidos):
                        self?.equipos = equiposObtenidos
                    case .failure(let error):
                        self?.mensajeError = error.localizedDescription
                        self?.mostrarError = true
                    }
                }
            }
        }
    
    
    
    func agregarEquipo(_ equipo: EquipoModel) {
        equipos.append(equipo)
    }
    
    func eliminarEquipo(id: String) {
        equipos.removeAll { $0.id_equipo == id }
    }
}
