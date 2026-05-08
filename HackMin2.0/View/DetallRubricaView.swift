//
//  DetallRubricaView.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//
import SwiftUI

struct DetallRubricaView: View {
    @State var rubrica: RubricaModel
    @State private var mostrarCrearCriterio = false
    @Environment(\.dismiss) private var dismiss
    var onUpdate: (RubricaModel) -> Void

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Image("Diseño7")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    // Header
                    HStack(spacing: geo.size.width * 0.02) {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: geo.size.width * 0.022, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(geo.size.width * 0.015)
                                .background(
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                                )
                        }

                        HStack(spacing: geo.size.width * 0.015) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(
                                        colors: [Color.orange, Color.orange.opacity(0.65)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing
                                    ))
                                    .frame(width: geo.size.width * 0.06, height: geo.size.width * 0.06)
                                Image(systemName: "doc.richtext.fill")
                                    .font(.system(size: geo.size.width * 0.022, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(rubrica.nombre_rubrica)
                                    .font(.system(size: geo.size.width * 0.018, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                Text(rubrica.descripcion_rubrica)
                                    .font(.system(size: geo.size.width * 0.011, design: .rounded))
                                    .foregroundColor(.white.opacity(0.55))
                                    .lineLimit(1)
                            }
                        }

                        Spacer()

                        // Badge peso total
                        VStack(spacing: 2) {
                            Text("Peso total")
                                .font(.system(size: geo.size.width * 0.010, design: .rounded))
                                .foregroundColor(.white.opacity(0.5))
                            Text("\(Int(rubrica.pesoTotal))%")
                                .font(.system(size: geo.size.width * 0.022, weight: .bold, design: .rounded))
                                .foregroundColor(rubrica.pesoTotal == 100 ? .green : .orange)
                        }
                        .padding(.horizontal, geo.size.width * 0.02)
                        .padding(.vertical, geo.size.height * 0.015)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(rubrica.pesoTotal == 100 ? Color.green.opacity(0.15) : Color.orange.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(rubrica.pesoTotal == 100 ? Color.green.opacity(0.4) : Color.orange.opacity(0.4), lineWidth: 1)
                                )
                        )

                        // Botón añadir criterio
                        Button {
                            mostrarCrearCriterio = true
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: geo.size.width * 0.016))
                                Text("Añadir criterio")
                                    .font(.system(size: geo.size.width * 0.012, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, geo.size.width * 0.02)
                            .padding(.vertical, geo.size.height * 0.018)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.orange)
                                    .shadow(color: .orange.opacity(0.4), radius: 6, x: 0, y: 3)
                            )
                        }
                    }
                    .padding(.horizontal, geo.size.width * 0.04)
                    .padding(.top, geo.size.height * 0.085)
                    .padding(.bottom, geo.size.height * 0.025)

                    // Lista criterios
                    ScrollView(.vertical, showsIndicators: false) {
                        if rubrica.criterios.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "list.bullet.rectangle")
                                    .font(.system(size: geo.size.width * 0.04))
                                    .foregroundColor(.white.opacity(0.3))
                                Text("Aún no hay criterios en esta rúbrica")
                                    .font(.system(size: geo.size.width * 0.013, design: .rounded))
                                    .foregroundColor(.white.opacity(0.3))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, geo.size.height * 0.2)
                        } else {
                            LazyVStack(spacing: geo.size.height * 0.022) {
                                ForEach(rubrica.criterios, id: \.id_criterio) { criterio in
                                    CriterioCardView(criterio: criterio, geo: geo)
                                }
                            }
                            .padding(.horizontal, geo.size.width * 0.06)
                            .padding(.bottom, geo.size.height * 0.06)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .sheet(isPresented: $mostrarCrearCriterio) {
            CrearCriterioView(
                isPresented: $mostrarCrearCriterio,
                idConcurso: rubrica.id_concurso,
                idRubrica: rubrica.id_rubrica
            ) { nuevoCriterio in
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    rubrica.criterios.append(nuevoCriterio)
                    onUpdate(rubrica)
                }
            }
            .presentationDetents([.fraction(0.92)])
            .presentationCornerRadius(28)
            .presentationBackground(.clear)
        }
    }
}
