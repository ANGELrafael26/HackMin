//
//  TabViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//


import SwiftUI
import Combine

class TabViewModel: ObservableObject {
    @Published var tabSeleccionado: Int = 0
    @Published var tabAnterior: Int = 0
    @Published var mostrarAlertaCerrar: Bool = false
    @Published var mostrarHeader: Bool = true
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""
    @Published var mostrarCrearEquipo: Bool = false
    @Published var cargando: Bool = true
    
    func transicion(para tab: Int) -> AnyTransition {
        let haciaDelante = tab > tabAnterior
        let insercion: Edge = haciaDelante ? .trailing : .leading
        let remocion: Edge = haciaDelante ? .leading : .trailing
        return .asymmetric(
            insertion: .move(edge: insercion).combined(with: .opacity),
            removal: .move(edge: remocion).combined(with: .opacity)
        )
    }
    
    func terminarEvento(completion: @escaping () -> Void) {
        ConcursoJuezService.shared.finalizarConcursoActivo { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion()
                case .failure(let error):
                    print("Error al finalizar concurso: \(error.localizedDescription)")
                    completion()
                }
            }
        }
    }
    
    
}
