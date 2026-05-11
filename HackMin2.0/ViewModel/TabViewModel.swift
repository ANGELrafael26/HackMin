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

    func transicion(para tab: Int) -> AnyTransition {
        let haciaDelante = tab > tabAnterior
        let insercion: Edge = haciaDelante ? .trailing : .leading
        let remocion: Edge = haciaDelante ? .leading : .trailing
        return .asymmetric(
            insertion: .move(edge: insercion).combined(with: .opacity),
            removal: .move(edge: remocion).combined(with: .opacity)
        )
    }
}
