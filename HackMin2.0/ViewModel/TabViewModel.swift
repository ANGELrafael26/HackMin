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
    @Published var mostrarAlertaCerrar: Bool = false
}
