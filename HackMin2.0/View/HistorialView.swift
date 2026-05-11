//
//  HistorialView.swift
//  HackMin2.0
//
//  Created by Naolop on 10/05/26.
//

import SwiftUI

struct HistorialView: View {
    @StateObject private var vm = HistorialViewModel()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Diseño7")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                if vm.concursos.isEmpty {
                    // Estado vacío
                    VStack(spacing: geo.size.height * 0.025) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.15))
                                .frame(
                                    width: geo.size.width * 0.12,
                                    height: geo.size.width * 0.12
                                )
                            Image(systemName: "clock.badge.xmark")
                                .font(.system(size: geo.size.width * 0.045))
                                .foregroundColor(.white.opacity(0.5))
                        }

                        Text("Sin eventos registrados")
                            .font(.system(size: geo.size.width * 0.022, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))

                        Text("Los eventos que crees aparecerán aquí")
                            .font(.system(size: geo.size.width * 0.014, design: .rounded))
                            .foregroundColor(.white.opacity(0.35))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else {
                    ScrollView {
                        VStack(spacing: geo.size.height * 0.025) {
                            ForEach(vm.concursos, id: \.id_concurso) { concurso in
                                Button {
                                    vm.seleccionar(concurso)
                                } label: {
                                    ConcursoRow(concurso: concurso, geo: geo)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, geo.size.width * 0.08)
                        .padding(.top, geo.size.height * 0.10)
                        .padding(.bottom, geo.size.height * 0.05)
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .onAppear{
            vm.obtenerCursos()
        }
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .sheet(isPresented: $vm.mostrarDetalle) {
            if let concurso = vm.concursoSeleccionado {
                DetalleConcursoView(concurso: concurso)
                    .presentationDetents([.fraction(0.85)])
                    .presentationCornerRadius(28)
                    .presentationBackground(.clear)
            }
        }
    }
}

// MARK: - Fila de concurso
struct ConcursoRow: View {
    let concurso: ConcursoModel
    let geo: GeometryProxy

    var body: some View {
        HStack(spacing: geo.size.width * 0.025) {
            // Ícono izquierdo
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.orange.opacity(0.85))
                    .frame(
                        width: geo.size.width * 0.07,
                        height: geo.size.width * 0.07
                    )
                    .shadow(color: .orange.opacity(0.4), radius: 6, x: 0, y: 3)

                Image(systemName: "flag.fill")
                    .font(.system(size: geo.size.width * 0.025, weight: .semibold))
                    .foregroundColor(.white)
            }

            // Info central
            VStack(alignment: .leading, spacing: 5) {
                Text(concurso.nombre_evento)
                    .font(.system(size: geo.size.width * 0.018, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: geo.size.width * 0.011))
                        .foregroundColor(.orange)

                    Text("\(concurso.fecha_inicio)  →  \(concurso.fecha_fin)")
                        .font(.system(size: geo.size.width * 0.012, design: .rounded))
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            // Chevron derecho
            Image(systemName: "chevron.right")
                .font(.system(size: geo.size.width * 0.014, weight: .semibold))
                .foregroundColor(.orange)
                .padding(.trailing, geo.size.width * 0.01)
        }
        .padding(.horizontal, geo.size.width * 0.025)
        .padding(.vertical, geo.size.height * 0.025)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    NavigationStack {
        HistorialView()
    }
    .previewInterfaceOrientation(.landscapeLeft)
}
