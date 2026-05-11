//
//  JuecesView.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import SwiftUI

struct JuecesView: View {
    @StateObject private var vm = JuecesViewModel()
    @State private var mostrarCrearJuez = false

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topTrailing) {

                // Grid scroll de jueces
                ScrollView(.vertical, showsIndicators: false) {
                    if vm.jueces.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "person.badge.shield.checkmark")
                                .font(.system(size: geo.size.width * 0.04))
                                .foregroundColor(.white.opacity(0.4))
                            Text("Aún no hay jueces registrados")
                                .font(.system(size: geo.size.width * 0.014, design: .rounded))
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, geo.size.height * 0.3)
                    } else {
                        LazyVStack(spacing: geo.size.height * 0.022) {
                            ForEach(vm.jueces, id: \.id_juez) { juez in
                                JuezCardView(juez: juez, geo: geo)
                            }
                        }
                        .padding(.horizontal, geo.size.width * 0.06)
                        .padding(.top, geo.size.height * 0.16)
                        .padding(.bottom, geo.size.height * 0.06)
                    }
                }

                // Botón agregar juez — esquina superior derecha
                Button {
                    mostrarCrearJuez = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: geo.size.width * 0.018))
                        Text("Agregar juez")
                            .font(.system(
                                size: geo.size.width * 0.013,
                                weight: .semibold,
                                design: .rounded
                            ))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, geo.size.width * 0.025)
                    .padding(.vertical, geo.size.height * 0.018)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.orange)
                            .shadow(color: .orange.opacity(0.4), radius: 8, x: 0, y: 4)
                    )
                }
                .padding(.top, geo.size.height * 0.05)
                .padding(.trailing, geo.size.width * 0.03)
            }
        }
        .onAppear {
                    vm.cargarJueces()
                }
        .sheet(isPresented: $mostrarCrearJuez) {
            CrearJuezView(
                isPresented: $mostrarCrearJuez,
                idConcurso: vm.idConcurso
            ) { nuevoJuez in
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    vm.agregarJuez(nuevoJuez)
                }
            }
            .presentationDetents([.fraction(0.92)])
            .presentationCornerRadius(28)
            .presentationBackground(.clear)
        }
    }
}

// MARK: - Card de juez
struct JuezCardView: View {

    let juez: JuezModel
    let geo: GeometryProxy

    var body: some View {

        HStack(spacing: geo.size.width * 0.025) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.orange, Color.orange.opacity(0.65)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(
                    width: geo.size.width * 0.07,
                    height: geo.size.width * 0.07
                )
                .overlay(
                    Text(String(juez.alias.prefix(1)).uppercased())
                        .font(.system(
                            size: geo.size.width * 0.028,
                            weight: .bold,
                            design: .rounded
                        ))
                        .foregroundColor(.white)
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.4), lineWidth: 2)
                )
                .shadow(color: .orange.opacity(0.35), radius: 8, x: 0, y: 4)


            VStack(alignment: .leading, spacing: geo.size.height * 0.008) {

                Text(juez.alias)
                    .font(.system(
                        size: geo.size.width * 0.016,
                        weight: .bold,
                        design: .rounded
                    ))
                    .foregroundColor(.black)

                Text("Juez evaluador")
                    .font(.system(
                        size: geo.size.width * 0.011,
                        design: .rounded
                    ))
                    .foregroundColor(.black.opacity(0.55))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: geo.size.height * 0.006) {

                Text("Código")
                    .font(.system(size: geo.size.width * 0.010, design: .rounded))
                    .foregroundColor(.black.opacity(0.5))

                Text(juez.id_juez)
                    .font(.system(
                        size: geo.size.width * 0.015,
                        weight: .semibold,
                        design: .monospaced
                    ))
                    .foregroundColor(.orange)
                    .padding(.horizontal, geo.size.width * 0.014)
                    .padding(.vertical, geo.size.height * 0.008)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.orange.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.orange.opacity(0.35), lineWidth: 1)
                            )
                    )
            }
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
                    .font(.system(
                        size: geo.size.width * 0.018,
                        weight: .bold
                    ))
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
                            .stroke(Color.red.opacity(0.25), lineWidth: 1)
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
                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
            }
        )
        .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ZStack {
        Image("Diseño7").resizable().scaledToFill().ignoresSafeArea()
        JuecesView()
    }
    .previewInterfaceOrientation(.landscapeLeft)
}
