//
//  CrearEventoView.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.

import SwiftUI

struct CrearEventoView: View {
    @StateObject private var vm = CrearEventoViewModel()
    @Binding var concursoActivo: ConcursoModel?
    @Binding var mostrarTabView: Bool

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Fondo
                Image("Diseño7")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // Card glassmorphism centrada
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                    .frame(
                        width: geo.size.width * 0.65,
                        height: geo.size.height * 0.78
                    )

                HStack(spacing: 0) {
                    // Lado izquierdo — ícono evento
                    VStack(spacing: geo.size.height * 0.025) {
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.2))
                                .frame(
                                    width: geo.size.width * 0.14,
                                    height: geo.size.width * 0.14
                                )
                            Image(systemName: "calendar.badge.plus")
                                .font(.system(size: geo.size.width * 0.05, weight: .semibold))
                                .foregroundColor(.orange)
                        }

                        Text("Nuevo evento")
                            .font(.system(size: geo.size.width * 0.014, weight: .semibold, design: .rounded))
                            .foregroundColor(.gray)
                    }
                    .frame(width: geo.size.width * 0.65 * 0.35)

                    // Divider
                    Rectangle()
                        .fill(Color.white.opacity(0.4))
                        .frame(width: 1, height: geo.size.height * 0.55)

                    // Lado derecho — formulario
                    VStack(spacing: geo.size.height * 0.035) {
                        // Nombre del evento
                        CustomTextField(
                            placeholder: "Nombre del evento",
                            text: $vm.nombreEvento,
                            type: .normal,
                            backgroundColor: .white.opacity(0.75),
                            foregroundColor: .black,
                            tittleColor: .black,
                            cornerRadius: 30,
                            height: geo.size.height * 0.09,
                            width: geo.size.width * 0.65 * 0.52
                        )

                        // Fecha inicio
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Fecha de inicio")
                                .font(.system(size: geo.size.width * 0.013, weight: .medium))
                                .foregroundColor(.gray)
                                .padding(.leading, geo.size.width * 0.02)

                            DatePicker(
                                "",
                                selection: $vm.fechaInicio,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .tint(.orange)
                            .padding(.horizontal, geo.size.width * 0.02)
                            .frame(width: geo.size.width * 0.65 * 0.52, height: geo.size.height * 0.09)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white.opacity(0.75))
                            )
                        }

                        // Fecha fin
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Fecha de fin")
                                .font(.system(size: geo.size.width * 0.013, weight: .medium))
                                .foregroundColor(.gray)
                                .padding(.leading, geo.size.width * 0.02)

                            DatePicker(
                                "",
                                selection: $vm.fechaFin,
                                in: vm.fechaInicio...,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .tint(.orange)
                            .padding(.horizontal, geo.size.width * 0.02)
                            .frame(width: geo.size.width * 0.65 * 0.52, height: geo.size.height * 0.09)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white.opacity(0.75))
                            )
                        }

                        if vm.mostrarError {
                            Text(vm.mensajeError)
                                .font(.system(size: geo.size.width * 0.013))
                                .foregroundColor(.red)
                        }

                        // Botón crear
                        CustomButton(
                            action: {
                                if let concurso = vm.crearEvento() {
                                    concursoActivo = concurso
                                    withAnimation(.easeInOut(duration: 0.35)) {
                                        mostrarTabView = true
                                    }
                                }
                            },
                            style: .standard(
                                fontColor: .white,
                                backgroundColor: .orange,
                                buttonName: "Crear evento",
                                fontName: "Helvetica Neue",
                                fontSize: geo.size.width * 0.018,
                                width: geo.size.width * 0.65 * 0.52,
                                height: geo.size.height * 0.09
                            )
                        )
                    }
                    .frame(width: geo.size.width * 0.65 * 0.58)
                    .padding(.vertical, geo.size.height * 0.04)
                }
                .frame(
                    width: geo.size.width * 0.65,
                    height: geo.size.height * 0.78
                )
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CrearEventoView(
        concursoActivo: .constant(nil),
        mostrarTabView: .constant(false)
    )
    .previewInterfaceOrientation(.landscapeLeft)
}
