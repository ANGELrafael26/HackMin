//
//  LogInJuez.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import SwiftUI

struct LogInJuez: View {
    @State private var codigo: String = ""

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Fondo
                Image("Diseño7")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // Card glassmorphism
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.clear)
                    .glassEffect()
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                    )
                    .frame(
                        width: geo.size.width * 0.60,
                        height: geo.size.height * 0.55
                    )

                HStack(spacing: 0) {
                    // Lado izquierdo — ícono juez
                    VStack {
                        Image("juez1")
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: geo.size.width * 0.13,
                                height: geo.size.width * 0.13
                            )
                    }
                    .frame(width: geo.size.width * 0.50 * 0.38)

                    // Divider vertical
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 1, height: geo.size.height * 0.35)

                    // Lado derecho — formulario
                    VStack(spacing: geo.size.height * 0.04) {
                        // Campo código
                        CustomTextField(
                            placeholder: "Código del juez",
                            text: $codigo,
                            type: .normal,
                            backgroundColor: .white.opacity(0.85),
                            foregroundColor: .black,
                            tittleColor: .black,
                            cornerRadius: 30,
                            height: geo.size.height * 0.08,
                            width: geo.size.width * 0.50 * 0.55
                        )

                        // Botón Ingresar
                        CustomButton(
                            action: {
                                print("Juez ingresando con código: \(codigo)")
                            },
                            style: .standard(
                                fontColor: .white,
                                backgroundColor: Color.orange,
                                buttonName: "Ingresar",
                                fontName: "Helvetica Neue",
                                fontSize: geo.size.width * 0.018,
                                width: geo.size.width * 0.50 * 0.55,
                                height: geo.size.height * 0.08
                            )
                        )
                    }
                    .frame(width: geo.size.width * 0.50 * 0.62)
                    .padding(.vertical, geo.size.height * 0.04)
                }
                .frame(width: geo.size.width * 0.50, height: geo.size.height * 0.55)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

#Preview {
    LogInJuez()
        .previewInterfaceOrientation(.landscapeLeft)
}
