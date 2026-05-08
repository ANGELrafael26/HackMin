//
//  LogInAdministrador.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import SwiftUI

struct LogInAdministrador: View {
    @StateObject private var vm = LogInAdministradorViewModel()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Diseño7")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                NavigationLink(
                    destination: ViewPrincipalAdmin(),
                    isActive: $vm.navegarPrincipal
                ) { EmptyView() }

                NavigationLink(
                    destination: RegistroAdministrador(),
                    isActive: $vm.navegarRegistro
                ) { EmptyView() }

                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.clear)
                    .glassEffect()
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .frame(width: geo.size.width * 0.70, height: geo.size.height * 0.6)

                HStack(spacing: -5) {
                    VStack {
                        Image("administrador")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.15, height: geo.size.width * 0.15)
                    }
                    .frame(width: geo.size.width * 0.65 * 0.3)

                    VStack(spacing: geo.size.height * 0.035) {
                        CustomTextField(
                            placeholder: "Ingresa tu usuario",
                            text: $vm.usuario,
                            type: .normal,
                            backgroundColor: .white.opacity(0.85),
                            foregroundColor: .black,
                            tittleColor: .black,
                            cornerRadius: 30,
                            height: geo.size.height * 0.08,
                            width: geo.size.width * 0.65 * 0.52
                        )
                        CustomTextField(
                            placeholder: "Ingresa tu contraseña",
                            text: $vm.contrasena,
                            type: .secure,
                            backgroundColor: .white.opacity(0.85),
                            foregroundColor: .black,
                            tittleColor: .black,
                            cornerRadius: 30,
                            height: geo.size.height * 0.08,
                            width: geo.size.width * 0.65 * 0.52
                        )

                        if vm.mostrarError {
                            Text(vm.mensajeError)
                                .font(.system(size: geo.size.width * 0.013))
                                .foregroundColor(.red)
                        }

                        CustomButton(
                            action: { vm.ingresar() },
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
                        CustomButton(
                            action: { vm.crearAdministrador() },
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
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack { LogInAdministrador() }
        .previewInterfaceOrientation(.landscapeLeft)
}
