//
//  HistorialViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 10/05/26.
//

import Foundation
import SwiftUI
import Combine

class HistorialViewModel: ObservableObject {
    @Published var concursos: [ConcursoModel] = []
    @Published var concursoSeleccionado: ConcursoModel? = nil
    @Published var mostrarDetalle: Bool = false
    @Published var cargando: Bool = true
    
    private let dao = ConcursoDAO()

    func seleccionar(_ concurso: ConcursoModel) {
        concursoSeleccionado = concurso
        mostrarDetalle = true
    }
    
    func obtenerCursos(){
        dao.getAllConcursos(){ [weak self] result in
            DispatchQueue.main.async {
                self?.cargando = false
                switch result {
                case .success(let cursosObtenidos):
                    withAnimation {
                        self?.concursos = cursosObtenidos
                    }
                case .failure(let error):
                    print("Error al cargar equipos: \(error.localizedDescription)")
                }
            }
        }
    }
}
