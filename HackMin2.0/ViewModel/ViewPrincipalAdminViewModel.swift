//
//  ViewPrincipalAdminViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import SwiftUI
import Combine

class ViewPrincipalAdminViewModel: ObservableObject {
    @Published var navegarCrearEvento: Bool = false
    @Published var navegarHistorial: Bool = false
    @Published var mostrarTabView: Bool = false
    @Published var concursoActivo: ConcursoModel? = nil
}
