//
//  CriteriosView.swift
//  HackMin2.0
//
//  Created by Dan Figueroa on 08/05/26.


import SwiftUI

struct CriteriosView: View {
    @StateObject private var vm = CriteriosViewModel()
    @State private var mostrarCrearCriterio = false

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topTrailing) {

                ScrollView(.vertical, showsIndicators: false) {
                    if vm.criterios.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "list.bullet.rectangle")
                                .font(.system(size: geo.size.width * 0.04))
                                .foregroundColor(.white.opacity(0.4))
                            Text("Aún no hay criterios registrados")
                                .font(.system(size: geo.size.width * 0.014, design: .rounded))
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, geo.size.height * 0.3)
                    } else {
                        // Indicador de peso total
                        HStack {
                            Spacer()
                            HStack(spacing: 6) {
                                Image(systemName: "percent")
                                    .font(.system(size: geo.size.width * 0.012, weight: .semibold))
                                    .foregroundColor(vm.pesoTotal == 100 ? .green : .orange)
                                Text("Peso total: \(Int(vm.pesoTotal))%")
                                    .font(.system(size: geo.size.width * 0.012, weight: .semibold, design: .rounded))
                                    .foregroundColor(vm.pesoTotal == 100 ? .green : .orange)
                            }
                            .padding(.horizontal, geo.size.width * 0.018)
                            .padding(.vertical, geo.size.height * 0.012)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(vm.pesoTotal == 100 ? Color.green.opacity(0.15) : Color.orange.opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(vm.pesoTotal == 100 ? Color.green.opacity(0.4) : Color.orange.opacity(0.4), lineWidth: 1)
                                    )
                            )
                            .padding(.trailing, geo.size.width * 0.06)
                        }
                        .padding(.top, geo.size.height * 0.18)

                        LazyVStack(spacing: geo.size.height * 0.022) {
                            ForEach(vm.criterios, id: \.id_criterio) { criterio in
                                CriterioCardView(criterio: criterio, geo: geo)
                            }
                        }
                        .padding(.horizontal, geo.size.width * 0.06)
                        .padding(.top, geo.size.height * 0.02)
                        .padding(.bottom, geo.size.height * 0.06)
                    }
                }

                // Botón agregar criterio
                Button {
                    mostrarCrearCriterio = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: geo.size.width * 0.018))
                        Text("Agregar criterio")
                            .font(.system(size: geo.size.width * 0.013, weight: .semibold, design: .rounded))
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
                .padding(.top, geo.size.height * 0.08)
                .padding(.trailing, geo.size.width * 0.03)
            }
        }
        .sheet(isPresented: $mostrarCrearCriterio) {
            CrearCriterioView(
                isPresented: $mostrarCrearCriterio,
                idConcurso: vm.idConcurso
            ) { nuevoCriterio in
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    vm.agregarCriterio(nuevoCriterio)
                }
            }
            .presentationDetents([.fraction(0.92)])
            .presentationCornerRadius(28)
            .presentationBackground(.clear)
        }
    }
}

// MARK: - Card de criterio
struct CriterioCardView: View {
    let criterio: CriterioModel
    let geo: GeometryProxy

    var body: some View {
        HStack(spacing: geo.size.width * 0.025) {

            // Círculo con inicial
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.orange, Color.orange.opacity(0.65)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: geo.size.width * 0.065, height: geo.size.width * 0.065)
                .overlay(
                    Image(systemName: "star.fill")
                        .font(.system(size: geo.size.width * 0.022, weight: .bold))
                        .foregroundColor(.black)
                )
                .overlay(Circle().stroke(Color.black.opacity(0.4), lineWidth: 2))
                .shadow(color: .orange.opacity(0.35), radius: 8, x: 0, y: 4)

            // Info principal
            VStack(alignment: .leading, spacing: geo.size.height * 0.007) {
                Text(criterio.nombre_criterio)
                    .font(.system(size: geo.size.width * 0.015, weight: .bold, design: .rounded))
                    .foregroundColor(.black)

                Text(criterio.descripcion_criterio)
                    .font(.system(size: geo.size.width * 0.011, design: .rounded))
                    .foregroundColor(.black.opacity(0.6))
                    .lineLimit(2)
            }

            Spacer()

            // Badges de peso y puntaje
            VStack(alignment: .trailing, spacing: geo.size.height * 0.010) {
                // Peso porcentual
                HStack(spacing: 4) {
                    Image(systemName: "percent")
                        .font(.system(size: geo.size.width * 0.010))
                        .foregroundColor(.orange)
                    Text("\(Int(criterio.peso_porcentual))%")
                        .font(.system(size: geo.size.width * 0.013, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                }
                .padding(.horizontal, geo.size.width * 0.014)
                .padding(.vertical, geo.size.height * 0.007)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.orange.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.orange.opacity(0.35), lineWidth: 1)
                        )
                )

                // Puntaje máximo
                HStack(spacing: 4) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: geo.size.width * 0.010))
                        .foregroundColor(.black.opacity(0.6))
                    Text("Máx. \(criterio.puntaje_maximo, specifier: "%.0f") pts")
                        .font(.system(size: geo.size.width * 0.011, weight: .medium, design: .rounded))
                        .foregroundColor(.black.opacity(0.6))
                }
            }
        }
        .padding(.horizontal, geo.size.width * 0.03)
        .padding(.vertical, geo.size.height * 0.025)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 22).fill(.ultraThinMaterial)
                RoundedRectangle(cornerRadius: 22)
                    .fill(LinearGradient(
                        colors: [Color.white.opacity(0.10), Color.white.opacity(0.03)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            }
        )
        .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ZStack {
        Image("Diseño7").resizable().scaledToFill().ignoresSafeArea()
        CriteriosView()
    }
    .previewInterfaceOrientation(.landscapeLeft)
}
