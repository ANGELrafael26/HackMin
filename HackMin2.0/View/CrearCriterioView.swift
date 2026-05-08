//
//  CrearCriterioView.swift
//  HackMin2.0
//
//  Created by Dan Figueroa on 08/05/26.
//

import SwiftUI

struct CrearCriterioView: View {
    @StateObject private var vm = CrearCriterioViewModel()
    @Binding var isPresented: Bool
    var idConcurso: String = ""
    var idRubrica: String = ""
    var onGuardar: (CriterioModel) -> Void

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Diseño7").resizable().scaledToFill().ignoresSafeArea()

                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color.white.opacity(0.5), lineWidth: 1))
                    .frame(width: geo.size.width * 0.65, height: geo.size.height * 0.85)

                HStack(spacing: 0) {
                    VStack(spacing: geo.size.height * 0.025) {
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.2))
                                .frame(width: geo.size.width * 0.14, height: geo.size.width * 0.14)
                            Image(systemName: "list.bullet.rectangle.fill")
                                .font(.system(size: geo.size.width * 0.045, weight: .semibold))
                                .foregroundColor(.orange)
                        }
                        Text("Nuevo criterio")
                            .font(.system(size: geo.size.width * 0.014, weight: .semibold, design: .rounded))
                            .foregroundColor(.gray)
                    }
                    .frame(width: geo.size.width * 0.65 * 0.35)

                    Rectangle()
                        .fill(Color.white.opacity(0.4))
                        .frame(width: 1, height: geo.size.height * 0.60)

                    VStack(spacing: geo.size.height * 0.028) {
                        CustomTextField(
                            placeholder: "Nombre del criterio",
                            text: $vm.nombreCriterio,
                            type: .normal,
                            backgroundColor: .white.opacity(0.75),
                            foregroundColor: .black,
                            tittleColor: .black,
                            cornerRadius: 30,
                            height: geo.size.height * 0.09,
                            width: geo.size.width * 0.65 * 0.52
                        )
                        CustomTextField(
                            placeholder: "Descripción",
                            text: $vm.descripcion,
                            type: .normal,
                            backgroundColor: .white.opacity(0.75),
                            foregroundColor: .black,
                            tittleColor: .black,
                            cornerRadius: 30,
                            height: geo.size.height * 0.09,
                            width: geo.size.width * 0.65 * 0.52
                        )
                        CustomTextField(
                            placeholder: "Peso porcentual (ej: 25)",
                            text: $vm.pesoPorcentual,
                            type: .normal,
                            backgroundColor: .white.opacity(0.75),
                            foregroundColor: .black,
                            tittleColor: .black,
                            cornerRadius: 30,
                            height: geo.size.height * 0.09,
                            width: geo.size.width * 0.65 * 0.52
                        )
                        CustomTextField(
                            placeholder: "Puntaje máximo (ej: 10)",
                            text: $vm.puntajeMaximo,
                            type: .normal,
                            backgroundColor: .white.opacity(0.75),
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

                        CustomButton(
                            action: {
                                if let criterio = vm.crearCriterio(idConcurso: idConcurso, idRubrica: idRubrica) {
                                    onGuardar(criterio)
                                    isPresented = false
                                }
                            },
                            style: .standard(
                                fontColor: .white,
                                backgroundColor: .orange,
                                buttonName: "Agregar criterio",
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
                .frame(width: geo.size.width * 0.65, height: geo.size.height * 0.85)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

#Preview {
    CrearCriterioView(isPresented: .constant(true)) { _ in }
        .previewInterfaceOrientation(.landscapeLeft)
}
