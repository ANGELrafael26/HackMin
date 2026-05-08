//
//  ViewPrincipalAdmin.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import SwiftUI

struct ViewPrincipalAdmin: View {
    @StateObject private var vm = ViewPrincipalAdminViewModel()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Diseño7")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: geo.size.height * 0.03) {
                    MenuBotonAdmin(
                        titulo: "Crear evento",
                        icono: "plus.circle.fill",
                        geo: geo,
                        action: { vm.navegarCrearEvento = true }
                    )
                    MenuBotonAdmin(
                        titulo: "Ver historial",
                        icono: "clock.fill",
                        geo: geo,
                        action: { vm.navegarHistorial = true }
                    )
                }
                .padding(.top, 300)
                .frame(maxWidth: .infinity)

                NavigationLink(
                    destination: CrearEventoView(
                        concursoActivo: $vm.concursoActivo,
                        mostrarTabView: $vm.mostrarTabView
                    ),
                    isActive: $vm.navegarCrearEvento
                ) { EmptyView() }

                NavigationLink(
                    destination: Text("Ver Historial"),
                    isActive: $vm.navegarHistorial
                ) { EmptyView() }
            }
        }
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

// MARK: - Componente botón de menú
struct MenuBotonAdmin: View {
    let titulo: String
    let icono: String
    let geo: GeometryProxy
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(titulo)
                    .font(.system(size: geo.size.width * 0.028, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.leading, geo.size.width * 0.04)

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .frame(
                            width: geo.size.width * 0.08,
                            height: geo.size.width * 0.08
                        )
                        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)

                    Image(systemName: icono)
                        .font(.system(size: geo.size.width * 0.03, weight: .semibold))
                        .foregroundColor(.orange)
                }
                .padding(.trailing, geo.size.width * 0.01)
            }
            .padding(.vertical, geo.size.height * 0.012)
            .frame(width: geo.size.width * 0.75)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    NavigationStack {
        ViewPrincipalAdmin()
    }
    .previewInterfaceOrientation(.landscapeLeft)
}
