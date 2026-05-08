//
//  LogInAdministrador.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import SwiftUI

struct LogInAdministrador: View {
    @State private var usuario: String = ""
    @State private var contrasena: String = ""

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Fondo
                Image("Diseño7")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // Card glassmorphism centrada
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.clear)
                    .glassEffect()
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                    )
                    .frame(
                        width: geo.size.width * 0.70,
                        height: geo.size.height * 0.6
                    )

                HStack(spacing: -5) {
                    // Lado izquierdo — ícono administrador
                    VStack {
                        Image("administrador")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.15, height: geo.size.width * 0.15)
                    }
                    .frame(width: geo.size.width * 0.65 * 0.3)

                    // Lado derecho — formulario
                    VStack(spacing: geo.size.height * 0.035) {
                        // Campo usuario
                        CustomTextField(
                            placeholder: "Ingresa tu usuario",
                            text: $usuario,
                            type: .normal,
                            backgroundColor: .white.opacity(0.85),
                            foregroundColor: .black,
                            tittleColor: .black,
                            cornerRadius: 30,
                            height: geo.size.height * 0.08,
                            width: geo.size.width * 0.65 * 0.52
                        )

                        // Campo contraseña
                        CustomTextField(
                            placeholder: "Ingresa tu contraseña",
                            text: $contrasena,
                            type: .secure,
                            backgroundColor: .white.opacity(0.85),
                            foregroundColor: .black,
                            tittleColor: .black,
                            cornerRadius: 30,
                            height: geo.size.height * 0.08,
                            width: geo.size.width * 0.65 * 0.52
                        )

                        // Botón Ingresar
                        CustomButton(
                            action: {
                                print("Ingresar tapped")
                            },
                            style: .standard(
                                fontColor: .white,
                                backgroundColor: Color.orange,
                                buttonName: "Ingresar",
                                fontName: "Helvetica Neue",
                                fontSize: geo.size.width * 0.018,
                                width: geo.size.width * 0.65 * 0.52,
                                height: geo.size.height * 0.08
                            )
                        )

                        // Link crear administrador
                        CustomButton(
                            action: {
                                print("Crear administrador tapped")
                            },
                            style: .textOnly(
                                text: "Crear administrador",
                                fontColor: .black,
                                fontName: "Helvetica Neue",
                                fontSize: geo.size.width * 0.016
                            )
                        )
                    }
                    .frame(width: geo.size.width * 0.65 * 0.62)
                    .padding(.vertical, geo.size.height * 0.04)
                }
                .frame(width: geo.size.width * 0.65, height: geo.size.height * 0.65)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

#Preview {
    LogInAdministrador()
        .previewInterfaceOrientation(.landscapeLeft)
}
