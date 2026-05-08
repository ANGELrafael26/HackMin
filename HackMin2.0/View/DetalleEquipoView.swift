//
//  DetalleEquipoView.swift
//  HackMin2.0
//
//  Created by Dan Figueroa on 08/05/26.
//

import SwiftUI

struct DetalleEquipoView: View {
    let equipo: EquipoModel
    @StateObject private var vm: DetalleEquipoViewModel
    @Environment(\.dismiss) private var dismiss

    init(equipo: EquipoModel) {
        self.equipo = equipo
        _vm = StateObject(wrappedValue: DetalleEquipoViewModel(idEquipo: equipo.id_equipo))
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                // Fondo
                Image("Diseño7")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // Contenido principal
                VStack(spacing: 0) {

                    // Header
                    HStack(spacing: geo.size.width * 0.025) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: geo.size.width * 0.022, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(geo.size.width * 0.015)
                                .background(
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                                )
                        }

                        // Foto + nombre del equipo
                        HStack(spacing: geo.size.width * 0.018) {
                            Circle()
                                .fill(Color.orange.opacity(0.3))
                                .frame(width: geo.size.width * 0.065, height: geo.size.width * 0.065)
                                .overlay(
                                    Image(equipo.foto_perfil)
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                )
                                .overlay(Circle().stroke(Color.orange.opacity(0.7), lineWidth: 2))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(equipo.nombre_equipo)
                                    .font(.system(size: geo.size.width * 0.022, weight: .bold, design: .rounded))
                                    .foregroundColor(.black)
                                Text(equipo.nombre_proyecto)
                                    .font(.system(size: geo.size.width * 0.013, design: .rounded))
                                    .foregroundColor(.black.opacity(0.6))
                            }
                        }

                        Spacer()

                        // Promedio general
                        VStack(spacing: 2) {
                            Text("Promedio")
                                .font(.system(size: geo.size.width * 0.011, design: .rounded))
                                .foregroundColor(.black.opacity(0.6))
                            Text(String(format: "%.1f", vm.promedioGeneral))
                                .font(.system(size: geo.size.width * 0.028, weight: .bold, design: .rounded))
                                .foregroundColor(.orange)
                        }
                        .padding(.horizontal, geo.size.width * 0.025)
                        .padding(.vertical, geo.size.height * 0.018)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.orange.opacity(0.4), lineWidth: 1)
                                )
                        )
                    }
                    .padding(.horizontal, geo.size.width * 0.04)
                    .padding(.top, geo.size.height * 0.04)
                    .padding(.bottom, geo.size.height * 0.025)

                    // Scroll de jueces
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: geo.size.height * 0.025) {
                            ForEach(vm.calificaciones) { item in
                                JuezCalificacionCard(item: item, geo: geo)
                            }
                        }
                        .padding(.horizontal, geo.size.width * 0.06)
                        .padding(.bottom, geo.size.height * 0.06)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

// MARK: - Card de juez con sus calificaciones
struct JuezCalificacionCard: View {
    let item: JuezCalificacionItem
    let geo: GeometryProxy

    var body: some View {
        VStack(spacing: 0) {

            // Header del juez
            HStack(spacing: geo.size.width * 0.018) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.orange, Color.orange.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: geo.size.width * 0.055, height: geo.size.width * 0.055)
                    .overlay(
                        Text(String(item.juez.alias.prefix(1)).uppercased())
                            .font(.system(size: geo.size.width * 0.02, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.juez.alias)
                        .font(.system(size: geo.size.width * 0.016, weight: .semibold, design: .rounded))
                        .foregroundColor(.black)
                    Text("Juez evaluador")
                        .font(.system(size: geo.size.width * 0.011, design: .rounded))
                        .foregroundColor(.black.opacity(0.5))
                }

                Spacer()

                // Promedio del juez
                Text(String(format: "%.1f", item.promedio))
                    .font(.system(size: geo.size.width * 0.022, weight: .bold, design: .rounded))
                    .foregroundColor(.orange)
                    .padding(.horizontal, geo.size.width * 0.018)
                    .padding(.vertical, geo.size.height * 0.012)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.orange.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.orange.opacity(0.35), lineWidth: 1)
                            )
                    )
            }
            .padding(.horizontal, geo.size.width * 0.03)
            .padding(.vertical, geo.size.height * 0.025)

            // Divider
            Rectangle()
                .fill(Color.black.opacity(0.15))
                .frame(height: 1)
                .padding(.horizontal, geo.size.width * 0.03)

            // Rubros y puntajes
            VStack(spacing: geo.size.height * 0.016) {
                ForEach(item.puntajes, id: \.criterio) { puntaje in
                    HStack {
                        Text(puntaje.criterio)
                            .font(.system(size: geo.size.width * 0.013, design: .rounded))
                            .foregroundColor(.black.opacity(0.85))

                        Spacer()

                        // Barra de progreso
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.black.opacity(0.1))
                                .frame(width: geo.size.width * 0.18, height: geo.size.height * 0.018)

                            RoundedRectangle(cornerRadius: 6)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.orange, Color.orange.opacity(0.7)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(
                                    width: geo.size.width * 0.18 * (puntaje.valor / 10.0),
                                    height: geo.size.height * 0.018
                                )
                        }

                        Text(String(format: "%.1f", puntaje.valor))
                            .font(.system(size: geo.size.width * 0.014, weight: .bold, design: .rounded))
                            .foregroundColor(.orange)
                            .frame(width: geo.size.width * 0.04, alignment: .trailing)
                    }
                }
            }
            .padding(.horizontal, geo.size.width * 0.03)
            .padding(.vertical, geo.size.height * 0.022)
        }
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(.ultraThinMaterial)
                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.1), Color.white.opacity(0.01)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
    }
}

#Preview {
    DetalleEquipoView(equipo: EquipoModel(
        id_equipo: "1",
        id_concurso: "c1",
        problematica: "Falta de agua",
        nombre_equipo: "AquaTech",
        nombre_proyecto: "HydroSense",
        integrantes: ["Ana", "Luis"]
    ))
    .previewInterfaceOrientation(.landscapeLeft)
}
