//
//  DetalleConcursoView.swift
//  HackMin2.0
//
//  Created by Dan Figueroa on 10/05/26.
//

import SwiftUI

struct DetalleConcursoView: View {
    let concurso: ConcursoModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Diseño7")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                    .frame(
                        width: geo.size.width * 0.60,
                        height: geo.size.height * 0.70
                    )

                VStack(spacing: geo.size.height * 0.04) {
                    // Ícono
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.2))
                            .frame(
                                width: geo.size.width * 0.10,
                                height: geo.size.width * 0.10
                            )
                        Image(systemName: "flag.fill")
                            .font(.system(size: geo.size.width * 0.035, weight: .semibold))
                            .foregroundColor(.orange)
                    }

                    // Nombre evento
                    Text(concurso.nombre_evento)
                        .font(.system(size: geo.size.width * 0.026, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, geo.size.width * 0.06)

                    Divider()
                        .padding(.horizontal, geo.size.width * 0.08)

                    // Fechas
                    HStack(spacing: geo.size.width * 0.06) {
                        // Inicio
                        VStack(spacing: 8) {
                            Image(systemName: "calendar.badge.plus")
                                .font(.system(size: geo.size.width * 0.022))
                                .foregroundColor(.orange)
                            Text("Inicio")
                                .font(.system(size: geo.size.width * 0.012, weight: .medium))
                                .foregroundColor(.gray)
                            Text(concurso.fecha_inicio)
                                .font(.system(size: geo.size.width * 0.016, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                        }
                        .padding(.vertical, geo.size.height * 0.025)
                        .padding(.horizontal, geo.size.width * 0.03)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.6))
                        )

                        Image(systemName: "arrow.right")
                            .font(.system(size: geo.size.width * 0.018, weight: .semibold))
                            .foregroundColor(.orange.opacity(0.6))

                        // Fin
                        VStack(spacing: 8) {
                            Image(systemName: "calendar.badge.checkmark")
                                .font(.system(size: geo.size.width * 0.022))
                                .foregroundColor(.orange)
                            Text("Fin")
                                .font(.system(size: geo.size.width * 0.012, weight: .medium))
                                .foregroundColor(.gray)
                            Text(concurso.fecha_fin)
                                .font(.system(size: geo.size.width * 0.016, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                        }
                        .padding(.vertical, geo.size.height * 0.025)
                        .padding(.horizontal, geo.size.width * 0.03)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.6))
                        )
                    }

                    // ID concurso
                    HStack(spacing: 6) {
                        Image(systemName: "number")
                            .font(.system(size: geo.size.width * 0.011))
                            .foregroundColor(.gray)
                        Text(concurso.id_concurso)
                            .font(.system(size: geo.size.width * 0.011, design: .monospaced))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                    .padding(.horizontal, geo.size.width * 0.06)

                    // Botón cerrar
                    CustomButton(
                        action: { dismiss() },
                        style: .standard(
                            fontColor: .white,
                            backgroundColor: .orange,
                            buttonName: "Cerrar",
                            fontName: "Helvetica Neue",
                            fontSize: geo.size.width * 0.016,
                            width: geo.size.width * 0.20,
                            height: geo.size.height * 0.09
                        )
                    )
                }
                .frame(
                    width: geo.size.width * 0.60,
                    height: geo.size.height * 0.70
                )
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    DetalleConcursoView(concurso: ConcursoModel(
        id_concurso: "abc-123-xyz",
        nombre_evento: "Hackathon 2026",
        fecha_inicio: "01/06/2026",
        fecha_fin: "03/06/2026"
    ))
    .previewInterfaceOrientation(.landscapeLeft)
}
