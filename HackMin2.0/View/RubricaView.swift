//
//  RubricaView.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.

import SwiftUI

struct RubricaView: View {

    @StateObject private var vm = RubricaViewModel()
    @State private var mostrarCrearRubrica = false

    @Binding var mostrarHeader: Bool

    var body: some View {

        NavigationStack {

            GeometryReader { geo in

                ZStack(alignment: .topTrailing) {

                    Image("Diseño7")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()

                    ScrollView(.vertical, showsIndicators: false) {

                        if vm.rubricas.isEmpty {

                            VStack(spacing: 12) {

                                Image(systemName: "doc.richtext")
                                    .font(.system(size: geo.size.width * 0.04))
                                    .foregroundColor(.black.opacity(0.4))

                                Text("Aún no hay rúbricas registradas")
                                    .font(
                                        .system(
                                            size: geo.size.width * 0.014,
                                            design: .rounded
                                        )
                                    )
                                    .foregroundColor(.black.opacity(0.4))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, geo.size.height * 0.3)

                        } else {

                            LazyVStack(spacing: geo.size.height * 0.022) {

                                ForEach(vm.rubricas, id: \.id_rubrica) { rubrica in

                                    NavigationLink {

                                        DetallRubricaView(
                                            rubrica: rubrica,
                                            onUpdate: { rubricaActualizada in
                                                vm.actualizarRubrica(rubricaActualizada)
                                            }
                                        )
                                        .onAppear {
                                            mostrarHeader = false
                                        }
                                        .onDisappear {
                                            mostrarHeader = true
                                        }

                                    } label: {

                                        RubricaCardView(
                                            rubrica: rubrica,
                                            geo: geo
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, geo.size.width * 0.06)
                            .padding(.top, geo.size.height * 0.16)
                            .padding(.bottom, geo.size.height * 0.06)
                        }
                    }

                    // Botón crear rúbrica
                    Button {

                        mostrarCrearRubrica = true

                    } label: {

                        HStack(spacing: 8) {

                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: geo.size.width * 0.018))

                            Text("Crear rúbrica")
                                .font(
                                    .system(
                                        size: geo.size.width * 0.013,
                                        weight: .semibold,
                                        design: .rounded
                                    )
                                )
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, geo.size.width * 0.025)
                        .padding(.vertical, geo.size.height * 0.018)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.orange)
                                .shadow(
                                    color: .orange.opacity(0.4),
                                    radius: 8,
                                    x: 0,
                                    y: 4
                                )
                        )
                    }
                    .padding(.top, geo.size.height * 0.04)
                    .padding(.trailing, geo.size.width * 0.03)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $mostrarCrearRubrica) {

                CrearRubricaView(
                    isPresented: $mostrarCrearRubrica
                ) { nuevaRubrica in

                    withAnimation(
                        .spring(
                            response: 0.4,
                            dampingFraction: 0.75
                        )
                    ) {
                        vm.agregarRubrica(nuevaRubrica)
                    }
                }
                .presentationDetents([.fraction(0.92)])
                .presentationCornerRadius(28)
                .presentationBackground(.clear)
            }
        }
    }
}

// MARK: - Card de rúbrica
struct RubricaCardView: View {

    let rubrica: RubricaModel
    let geo: GeometryProxy

    var body: some View {

        HStack(spacing: geo.size.width * 0.025) {

            // Ícono
            ZStack {

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.orange,
                                Color.orange.opacity(0.65)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(
                        width: geo.size.width * 0.07,
                        height: geo.size.width * 0.07
                    )

                Image(systemName: "doc.richtext.fill")
                    .font(
                        .system(
                            size: geo.size.width * 0.025,
                            weight: .bold
                        )
                    )
                    .foregroundColor(.black)
            }
            .overlay(
                Circle()
                    .stroke(Color.black.opacity(0.4), lineWidth: 2)
            )
            .shadow(
                color: .orange.opacity(0.35),
                radius: 8,
                x: 0,
                y: 4
            )

            // Información
            VStack(
                alignment: .leading,
                spacing: geo.size.height * 0.007
            ) {

                Text(rubrica.nombre_rubrica)
                    .font(
                        .system(
                            size: geo.size.width * 0.015,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundColor(.black)

                Text(rubrica.descripcion_rubrica)
                    .font(
                        .system(
                            size: geo.size.width * 0.011,
                            design: .rounded
                        )
                    )
                    .foregroundColor(.black.opacity(0.6))
                    .lineLimit(2)
            }

            Spacer()

            // Datos derecha
            VStack(
                alignment: .trailing,
                spacing: geo.size.height * 0.008
            ) {

                HStack(spacing: 4) {

                    Image(systemName: "list.bullet")
                        .font(.system(size: geo.size.width * 0.010))
                        .foregroundColor(.black.opacity(0.5))

                    Text("\(rubrica.criterios.count) criterios")
                        .font(
                            .system(
                                size: geo.size.width * 0.011,
                                design: .rounded
                            )
                        )
                        .foregroundColor(.black.opacity(0.6))
                }

                HStack(spacing: 4) {

                    Image(systemName: "percent")
                        .font(.system(size: geo.size.width * 0.010))
                        .foregroundColor(
                            rubrica.pesoTotal == 100
                            ? .green
                            : .orange
                        )

                    Text("\(Int(rubrica.pesoTotal))%")
                        .font(
                            .system(
                                size: geo.size.width * 0.013,
                                weight: .bold,
                                design: .rounded
                            )
                        )
                        .foregroundColor(
                            rubrica.pesoTotal == 100
                            ? .green
                            : .orange
                        )
                }
                .padding(.horizontal, geo.size.width * 0.012)
                .padding(.vertical, geo.size.height * 0.006)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            rubrica.pesoTotal == 100
                            ? Color.green.opacity(0.15)
                            : Color.orange.opacity(0.15)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    rubrica.pesoTotal == 100
                                    ? Color.green.opacity(0.4)
                                    : Color.orange.opacity(0.4),
                                    lineWidth: 1
                                )
                        )
                )
            }

            // Línea
            Rectangle()
                .fill(Color.black.opacity(0.12))
                .frame(
                    width: 1.5,
                    height: geo.size.height * 0.07
                )
                .padding(.horizontal, geo.size.width * 0.01)

            // Botón eliminar
            Button {

            } label: {

                Image(systemName: "trash.fill")
                    .font(
                        .system(
                            size: geo.size.width * 0.018,
                            weight: .bold
                        )
                    )
                    .foregroundColor(.red)
                    .frame(
                        width: geo.size.width * 0.05,
                        height: geo.size.width * 0.05
                    )
                    .background(
                        Circle()
                            .fill(Color.red.opacity(0.12))
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                Color.red.opacity(0.25),
                                lineWidth: 1
                            )
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, geo.size.width * 0.03)
        .padding(.vertical, geo.size.height * 0.025)
        .background(
            ZStack {

                RoundedRectangle(cornerRadius: 22)
                    .fill(.ultraThinMaterial)

                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.10),
                                Color.white.opacity(0.03)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                RoundedRectangle(cornerRadius: 22)
                    .stroke(
                        Color.white.opacity(0.2),
                        lineWidth: 1
                    )
            }
        )
        .shadow(
            color: .black.opacity(0.12),
            radius: 10,
            x: 0,
            y: 5
        )
    }
}

#Preview {
    RubricaView(
        mostrarHeader: .constant(true)
    )
}
