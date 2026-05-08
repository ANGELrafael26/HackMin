//
//  CrearEquipoView.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import SwiftUI

struct CrearEquipoView: View {
    @StateObject private var vm = CrearEquipoViewModel()
    @Binding var isPresented: Bool
    var idConcurso: String = ""
    var onGuardar: (EquipoModel) -> Void

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Diseño7")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // Card glassmorphism
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                    .frame(
                        width: geo.size.width * 0.65,
                        height: geo.size.height * 0.80
                    )

                HStack(spacing: 0) {
                    // Lado izquierdo — foto predeterminada
                    VStack(spacing: geo.size.height * 0.02) {
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.2))
                                .frame(
                                    width: geo.size.width * 0.14,
                                    height: geo.size.width * 0.14
                                )

                            Image(EquipoModel.fotoPredeterminada)
                                .resizable()
                                .scaledToFill()
                                .frame(
                                    width: geo.size.width * 0.14,
                                    height: geo.size.width * 0.14
                                )
                                .clipShape(Circle())
                                // fallback si no existe la imagen
                                .overlay(
                                    Image(systemName: "person.3.fill")
                                        .font(.system(size: geo.size.width * 0.04))
                                        .foregroundColor(.orange)
                                        .opacity(Image(EquipoModel.fotoPredeterminada) == Image("") ? 1 : 0)
                                )
                        }

                        Text("Foto del equipo")
                            .font(.system(size: geo.size.width * 0.012))
                            .foregroundColor(.gray)
                    }
                    .frame(width: geo.size.width * 0.65 * 0.35)

                    // Divider
                    Rectangle()
                        .fill(Color.white.opacity(0.4))
                        .frame(width: 1, height: geo.size.height * 0.55)

                    // Lado derecho — formulario
                    VStack(spacing: geo.size.height * 0.028) {
                        // Nombre equipo
                        CustomTextField(
                            placeholder: "Nombre del equipo",
                            text: $vm.nombreEquipo,
                            type: .normal,
                            backgroundColor: .white.opacity(0.7),
                            foregroundColor: .black,
                            tittleColor: .black,
                            cornerRadius: 30,
                            height: geo.size.height * 0.09,
                            width: geo.size.width * 0.65 * 0.52
                        )

                        // Nombre proyecto
                        CustomTextField(
                            placeholder: "Nombre del proyecto",
                            text: $vm.nombreProyecto,
                            type: .normal,
                            backgroundColor: .white.opacity(0.7),
                            foregroundColor: .black,
                            tittleColor: .black,
                            cornerRadius: 30,
                            height: geo.size.height * 0.09,
                            width: geo.size.width * 0.65 * 0.52
                        )

                        // Integrantes (separados por coma)
                        CustomTextField(
                            placeholder: "Integrantes (separados por coma)",
                            text: $vm.integrantesTexto,
                            type: .normal,
                            backgroundColor: .white.opacity(0.7),
                            foregroundColor: .black,
                            tittleColor: .black,
                            cornerRadius: 30,
                            height: geo.size.height * 0.09,
                            width: geo.size.width * 0.65 * 0.52
                        )

                        // Problemática
                        CustomTextField(
                            placeholder: "Problemática",
                            text: $vm.problematica,
                            type: .normal,
                            backgroundColor: .white.opacity(0.7),
                            foregroundColor: .black,
                            tittleColor: .black,
                            cornerRadius: 30,
                            height: geo.size.height * 0.09,
                            width: geo.size.width * 0.65 * 0.52
                        )

                        if vm.mostrarError {
                            Text(vm.mensajeError)
                                .font(.system(size: geo.size.width * 0.013))
                                .foregroundColor(.red)
                        }

                        // Botón Agregar
                        CustomButton(
                            action: {
                                if let equipo = vm.guardarEquipo(idConcurso: idConcurso) {
                                    onGuardar(equipo)
                                    isPresented = false
                                }
                            },
                            style: .standard(
                                fontColor: .white,
                                backgroundColor: .orange,
                                buttonName: "Agregar equipo",
                                fontName: "Helvetica Neue",
                                fontSize: geo.size.width * 0.016,
                                width: geo.size.width * 0.65 * 0.52,
                                height: geo.size.height * 0.09
                            )
                        )
                    }
                    .frame(width: geo.size.width * 0.65 * 0.60)
                    .padding(.vertical, geo.size.height * 0.04)
                }
                .frame(
                    width: geo.size.width * 0.65,
                    height: geo.size.height * 0.80
                )
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

#Preview {
    CrearEquipoView(isPresented: .constant(true)) { _ in }
        .previewInterfaceOrientation(.landscapeLeft)
}
