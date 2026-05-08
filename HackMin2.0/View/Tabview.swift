//
//  Tabview.swift
//  HackMin2.0
//
//  Created by Dan Figueroa on 08/05/26.
//

import SwiftUI

struct Tabview: View {
    @StateObject private var vm = TabViewModel()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Diseño7")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                TabView(selection: $vm.tabSeleccionado) {
                    EquiposView()
                        .tabItem {
                            Label("Equipos", systemImage: "person.3.fill")
                        }
                        .tag(0)

                    Text("Jueces")
                        .tabItem {
                            Label("Jueces", systemImage: "person.badge.shield.checkmark.fill")
                        }
                        .tag(1)

                    Text("Criterios")
                        .tabItem {
                            Label("Criterios", systemImage: "list.bullet.rectangle.fill")
                        }
                        .tag(2)
                }
                .tint(.orange)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        Tabview()
    }
    .previewInterfaceOrientation(.landscapeLeft)
}
