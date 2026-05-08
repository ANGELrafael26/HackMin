//
//  EquiposView.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import SwiftUI

struct EquiposView: View {
    @StateObject private var vm = EquiposViewModel()

    let columnas = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topTrailing) {
                Color.clear

                // Grid con scroll
                ScrollView {
                    LazyVGrid(columns: columnas, spacing: geo.size.height * 0.04) {
                        ForEach(vm.equipos, id: \.id_equipo) { equipo in
                            EquipoCard(equipo: equipo, geo: geo)
                        }
                    }
                    .padding(.top, geo.size.height * 0.12)
                    .padding(.horizontal, geo.size.width * 0.04)
                    .padding(.bottom, geo.size.height * 0.04)
                }

                // Botón agregar equipo
                Button(action: { vm.mostrarCrearEquipo = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: geo.size.width * 0.022))
                        Text("Agregar equipo")
                            .font(.system(size: geo.size.width * 0.016, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, geo.size.width * 0.025)
                    .padding(.vertical, geo.size.height * 0.018)
                    .background(
                        Capsule()
                            .fill(Color.orange)
                            .shadow(color: .orange.opacity(0.4), radius: 8, x: 0, y: 4)
                    )
                }
                .padding(.top, geo.size.height * 0.03)
                .padding(.trailing, geo.size.width * 0.03)
            }
        }
        .sheet(isPresented: $vm.mostrarCrearEquipo) {
            CrearEquipoView(isPresented: $vm.mostrarCrearEquipo) { nuevoEquipo in
                vm.agregarEquipo(nuevoEquipo)
            }
        }
    }
}

// MARK: - Card de equipo
struct EquipoCard: View {
    let equipo: EquipoModel
    let geo: GeometryProxy

    var body: some View {
        VStack(spacing: geo.size.height * 0.02) {
            // Foto del equipo
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.25))
                    .frame(
                        width: geo.size.width * 0.12,
                        height: geo.size.width * 0.12
                    )

                Image(equipo.foto_perfil)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geo.size.width * 0.12,
                        height: geo.size.width * 0.12
                    )
                    .clipShape(Circle())
            }

            // Nombre del equipo
            Text(equipo.nombre_equipo)
                .font(.system(size: geo.size.width * 0.018, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)

            // Nombre del proyecto
            Text(equipo.nombre_proyecto)
                .font(.system(size: geo.size.width * 0.014, weight: .regular, design: .rounded))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(
            width: geo.size.width * 0.35,
            height: geo.size.height * 0.38
        )
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    EquiposView()
        .previewInterfaceOrientation(.landscapeLeft)
}
