// EquiposViewModel.swift
import Foundation
import SwiftUI
import Combine

class EquiposViewModel: ObservableObject {
    @Published var equipos: [EquipoModel] = []
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""
    @Published var mostrarCrearEquipo: Bool = false
    @Published var cargando: Bool = true

    private let equipoDAO = EquipoDAO()
    var idConcurso: String = ""

    func cargarEquipos() {
        
        EquipoRubricaService.shared.getEquiposConcursoActivo(){ [weak self] result in
            DispatchQueue.main.async {
                self?.cargando = false
                switch result {
                case .success(let equiposObtenidos):
                    withAnimation {
                        self?.equipos = equiposObtenidos
                    }
                case .failure(let error):
                    print("Error al cargar equipos: \(error.localizedDescription)")
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
