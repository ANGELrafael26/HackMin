//
//  ContentView.swift
//  HackMin2.0
//
//  Created by Naolop on 07/05/26.
//

import SwiftUI

struct ContentView: View {
    @State private var mostrarTabView = false
    @State private var concursoActivo: ConcursoModel? = nil

    var body: some View {
        if mostrarTabView {
            Tabview()
        } else {
            CrearEventoView(
                concursoActivo: $concursoActivo,
                mostrarTabView: $mostrarTabView
            )
        }
    }
}

#Preview {
    ContentView()
}
