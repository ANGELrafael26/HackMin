//
//  JuecesViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

class JuecesViewModel: ObservableObject {
    @Published var jueces: [JuezModel] = []
    @Published var mostrarCrearJuez: Bool = false
    @Published var cargando: Bool = true // Nueva variable para controlar el estado de carga
    
    var idConcurso: String = ""

    // Función para obtener los jueces desde Firebase
    func cargarJueces() {
        // Asegurarnos de que el ID no esté vacío antes de buscar
        guard !idConcurso.isEmpty else {
            print("Error: idConcurso está vacío.")
            self.cargando = false
            return
        }
        
        self.cargando = true
        
        ConcursoJuezService.shared.getJueces(deConcurso: idConcurso) { [weak self] result in
            DispatchQueue.main.async {
                self?.cargando = false
                switch result {
                case .success(let juecesObtenidos):
                    withAnimation {
                        self?.jueces = juecesObtenidos
                    }
                case .failure(let error):
                    print("Error al cargar jueces: \(error.localizedDescription)")
                }
            }
        }
    }

    func agregarJuez(_ juez: JuezModel) {
        jueces.append(juez)
    }

    func eliminarJuez(id: String) {
        jueces.removeAll { $0.id_juez == id }
    }
}
