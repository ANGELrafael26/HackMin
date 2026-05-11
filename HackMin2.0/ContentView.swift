//
//  ContentView.swift
//  HackMin2.0
//
//  Created by Naolop on 07/05/26.
//

import SwiftUI

struct ContentView: View {
    @State private var mostrarTabView: Bool = false
    @State private var concursoActivo: ConcursoModel? = nil

    var body: some View {
        if mostrarTabView, let concurso = concursoActivo {
            Tabview(concurso: concurso)
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
