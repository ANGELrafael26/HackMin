//
//  CrearRubricaView.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//
import SwiftUI

struct CrearRubricaView: View {
    @StateObject private var vm = CrearRubricaViewModel()
    @Binding var isPresented: Bool
    var idConcurso: String = ""
    var onGuardar: (RubricaModel) -> Void

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Diseño7").resizable().scaledToFill().ignoresSafeArea()

                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color.white.opacity(0.5), lineWidth: 1))
                    .frame(width: geo.size.width * 0.65, height: geo.size.height * 0.68)

                HStack(spacing: 0) {
                    VStack(spacing: geo.size.height * 0.025) {
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.2))
                                .frame(width: geo.size.width * 0.14, height: geo.size.width * 0.14)
                            Image(systemName: "doc.richtext.fill")
                                .font(.system(size: geo.size.width * 0.045, weight: .semibold))
                                .foregroundColor(.orange)
                        }
                        Text("Nueva rúbrica")
                            .font(.system(size: geo.size.width * 0.014, weight: .semibold, design: .rounded))
                            .foregroundColor(.gray)
                        Text("Los criterios se\nagregan después")
                            .font(.system(size: geo.size.width * 0.011, design: .rounded))
                            .foregroundColor(.gray.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: geo.size.width * 0.65 * 0.35)

                    Rectangle()
                        .fill(Color.white.opacity(0.4))
                        .frame(width: 1, height: geo.size.height * 0.40)

                    VStack(spacing: geo.size.height * 0.035) {
                        CustomTextField(
                            placeholder: "Nombre de la rúbrica",
                            text: $vm.nombreRubrica,
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

                        if vm.mostrarError {
                            Text(vm.mensajeError)
                                .font(.system(size: geo.size.width * 0.013))
                                .foregroundColor(.red)
                        }

                        CustomButton(
                            action: {
                                if let rubrica = vm.crearRubrica(idConcurso: idConcurso) {
                                    onGuardar(rubrica)
                                    isPresented = false
                                }
                            },
                            style: .standard(
                                fontColor: .white,
                                backgroundColor: .orange,
                                buttonName: "Crear rúbrica",
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
                .frame(width: geo.size.width * 0.65, height: geo.size.height * 0.68)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}
