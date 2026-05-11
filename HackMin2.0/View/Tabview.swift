//
//  Tabview.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import SwiftUI

struct Tabview: View {
    let concurso: ConcursoModel
    @StateObject private var vm = TabViewModel()
    @Namespace private var tabAnimation
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                Image("Diseño7")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // Contenido pestañas
                ZStack {
                    switch vm.tabSeleccionado {
                    case 0:
                        EquiposView()
                            .transition(.asymmetric(
                                insertion: .move(edge: .leading).combined(with: .opacity),
                                removal: .move(edge: .trailing).combined(with: .opacity)
                            ))
                    case 1:
                        JuecesView()
                            .transition(.asymmetric(
                                insertion: .move(edge: .leading).combined(with: .opacity),
                                removal: .move(edge: .trailing).combined(with: .opacity)
                            ))
                    case 2:
                        RubricaView()
                            .transition(.asymmetric(
                                insertion: .move(edge: .leading).combined(with: .opacity),
                                removal: .move(edge: .trailing).combined(with: .opacity)
                            ))
                    default:
                        EmptyView()
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: vm.tabSeleccionado)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, geo.size.height * 0.13)

                // Header superior
                VStack {
                    ZStack {
                        // Nombre del evento centrado
                        Text(concurso.nombre_evento)
                            .font(.system(
                                size: geo.size.width * 0.030,
                                weight: .bold,
                                design: .rounded
                            ))
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: geo.size.width * 0.55)

                        HStack {
                            Button {
                                vm.mostrarAlertaCerrar = true
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: geo.size.width * 0.018, weight: .semibold))
                                    Text("Cerrar evento")
                                        .font(.system(
                                            size: geo.size.width * 0.014,
                                            weight: .semibold,
                                            design: .rounded
                                        ))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, geo.size.width * 0.02)
                                .padding(.vertical, geo.size.height * 0.015)
                                .background(
                                    Capsule()
                                        .fill(Color.red.opacity(0.85))
                                        .shadow(color: .red.opacity(0.4), radius: 6, x: 0, y: 3)
                                )
                            }
                            Spacer()
                        }
                        .padding(.leading, geo.size.width * 0.03)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, geo.size.height * 0.055)

                    Spacer()
                }

                CustomTabBar(
                    tabSeleccionado: $vm.tabSeleccionado,
                    geo: geo,
                    namespace: tabAnimation
                )
            }
        }
        .ignoresSafeArea()
        .alert("¿Cerrar evento?", isPresented: $vm.mostrarAlertaCerrar) {
            Button("Cancelar", role: .cancel) {}
            Button("Cerrar", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Se cerrará el evento \"\(concurso.nombre_evento)\". ¿Deseas continuar?")
        }
    }
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var tabSeleccionado: Int
    let geo: GeometryProxy
    var namespace: Namespace.ID

    let tabs: [(String, String)] = [
        ("Equipos",   "person.3.fill"),
        ("Jueces",    "person.badge.shield.checkmark.fill"),
        ("Criterios", "list.bullet.rectangle.fill")
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                let isSelected = tabSeleccionado == index

                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        tabSeleccionado = index
                    }
                } label: {
                    VStack(spacing: geo.size.height * 0.008) {
                        ZStack {
                            // Píldora de selección
                            if isSelected {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.orange.opacity(0.45),
                                                Color.orange.opacity(0.2)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.orange.opacity(0.6), lineWidth: 1)
                                    )
                                    .frame(
                                        width: geo.size.width * 0.13,
                                        height: geo.size.height * 0.065
                                    )
                                    .matchedGeometryEffect(id: "tabBackground", in: namespace)
                                    .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
                            }

                            Image(systemName: tabs[index].1)
                                .font(.system(
                                    size: geo.size.width * 0.028,
                                    weight: isSelected ? .semibold : .regular
                                ))
                                .foregroundColor(
                                    isSelected ? .orange : .black
                                )
                                .scaleEffect(isSelected ? 1.2 : 1.0)
                                .animation(
                                    .spring(response: 0.3, dampingFraction: 0.6),
                                    value: isSelected
                                )
                        }
                        .frame(
                            width: geo.size.width * 0.13,
                            height: geo.size.height * 0.065
                        )

                        Text(tabs[index].0)
                            .font(.system(
                                size: geo.size.width * 0.013,
                                weight: isSelected ? .bold : .regular,
                                design: .rounded
                            ))
                            .foregroundColor(
                                isSelected ? .orange : .black
                            )
                            .tracking(0.3)
                    }
                    .padding(.vertical, geo.size.height * 0.012)
                    .padding(.horizontal, geo.size.width * 0.015)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, geo.size.width * 0.03)
        .padding(.vertical, geo.size.height * 0.012)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(.clear)
                    .glassEffect()


                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.12),
                                Color.white.opacity(0.04)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                
            }
        )
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 8)
        // Más ancho que antes
        .padding(.horizontal, geo.size.width * 0.18)
        .padding(.bottom, geo.size.height * 0.028)
    }
}

#Preview {
    Tabview(concurso: ConcursoModel(
        id_concurso: "abc-123",
        nombre_evento: "Hackathon 2026",
        fecha_inicio: "01/06/2026",
        fecha_fin: "03/06/2026"
    ))
    .previewInterfaceOrientation(.landscapeLeft)
}
