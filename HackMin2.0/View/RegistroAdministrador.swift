//
//  RegistroAdministrador.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import SwiftUI

struct RegistroAdministrador: View {
    @StateObject private var vm = RegistroAdministradorViewModel()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Registro")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                NavigationLink(
                    destination: ViewPrincipalAdmin(),
                    isActive: $vm.navegarPrincipal
                ) { EmptyView() }

                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: geo.size.width * 0.53)

                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .ignoresSafeArea(edges: .trailing)

                        VStack(spacing: geo.size.height * 0.04) {
                            Image("administrador")
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: geo.size.width * 0.08,
                                    height: geo.size.width * 0.08
                                )

                            CustomTextField(
                                placeholder: "Nombre(s)",
                                text: $vm.nombres,
                                type: .normal,
                                backgroundColor: .clear,
                                foregroundColor: .black,
                                tittleColor: .black,
                                cornerRadius: 12,
                                height: geo.size.height * 0.08,
                                width: geo.size.width * 0.38
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.orange.opacity(0.6), lineWidth: 1.5)
                                    .frame(width: geo.size.width * 0.38, height: geo.size.height * 0.08)
                            )

                            CustomTextField(
                                placeholder: "Apellidos",
                                text: $vm.apellidos,
                                type: .normal,
                                backgroundColor: .clear,
                                foregroundColor: .black,
                                tittleColor: .black,
                                cornerRadius: 12,
                                height: geo.size.height * 0.08,
                                width: geo.size.width * 0.38
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.orange.opacity(0.6), lineWidth: 1.5)
                                    .frame(width: geo.size.width * 0.38, height: geo.size.height * 0.08)
                            )

                            CustomTextField(
                                placeholder: "Usuario",
                                text: $vm.usuario,
                                type: .normal,
                                backgroundColor: .clear,
                                foregroundColor: .black,
                                tittleColor: .black,
                                cornerRadius: 12,
                                height: geo.size.height * 0.08,
                                width: geo.size.width * 0.38
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.orange.opacity(0.6), lineWidth: 1.5)
                                    .frame(width: geo.size.width * 0.38, height: geo.size.height * 0.08)
                            )

                            CustomTextField(
                                placeholder: "Contraseña",
                                text: $vm.contrasena,
                                type: .secure,
                                backgroundColor: .clear,
                                foregroundColor: .black,
                                tittleColor: .black,
                                cornerRadius: 12,
                                height: geo.size.height * 0.08,
                                width: geo.size.width * 0.38
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.orange.opacity(0.6), lineWidth: 1.5)
                                    .frame(width: geo.size.width * 0.38, height: geo.size.height * 0.08)
                            )

                            if vm.mostrarError {
                                Text(vm.mensajeError)
                                    .font(.system(size: geo.size.width * 0.013))
                                    .foregroundColor(.red)
                            }

                            CustomButton(
                                action: { vm.registrar() },
                                style: .standard(
                                    fontColor: .white,
                                    backgroundColor: Color.orange,
                                    buttonName: "Registrar",
                                    fontName: "Helvetica Neue",
                                    fontSize: geo.size.width * 0.018,
                                    width: geo.size.width * 0.25,
                                    height: geo.size.height * 0.08
                                )
                            )
                        }
                        .padding(.vertical, geo.size.height * 0.04)
                        .frame(width: geo.size.width * 0.50)
                    }
                    .frame(width: geo.size.width * 0.50, height: geo.size.height)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack { RegistroAdministrador() }
        .previewInterfaceOrientation(.landscapeLeft)
}
