//
//  SeleccionUsuario.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import SwiftUI

struct SeleccionUsuario: View {
    @StateObject private var vm = SeleccionUsuarioViewModel()

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack(alignment: .bottom) {
                    Image("Diseño7")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()

                    // Navegación invisible
                    NavigationLink(destination:
                        LogInAdministrador()
                            .navigationBarTitleDisplayMode(.inline),
                        isActive: $vm.navegarAdministrador
                    ) { EmptyView() }

                    NavigationLink(destination:
                        LogInJuez()
                            .navigationBarTitleDisplayMode(.inline),
                        isActive: $vm.navegarJuez
                    ) { EmptyView() }

                    // Botón principal
                    VStack {
                        Spacer()
                        CustomButton(action: {
                            vm.togglePanel()
                        }, style: .image(
                            imageName: "Boton",
                            width: geo.size.width * 0.07,
                            height: geo.size.width * 0.07
                        ))
                        .padding(.bottom, geo.size.height * 0.12)
                    }

                    // Overlay oscuro
                    if vm.mostrarPanel {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture { vm.cerrarPanel() }
                    }

                    // Panel inferior
                    if vm.mostrarPanel {
                        VStack(spacing: geo.size.height * 0.025) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.gray.opacity(0.4))
                                .frame(
                                    width: geo.size.width * 0.04,
                                    height: geo.size.height * 0.006
                                )
                                .padding(.top, geo.size.height * 0.02)

                            Text("Selecciona tu rol")
                                .font(.system(size: geo.size.width * 0.025, weight: .semibold))
                                .foregroundColor(.black)

                            HStack(spacing: geo.size.width * 0.04) {
                                // Botón Administrador
                                Button(action: { vm.confirmarRol("administrador") }) {
                                    Text("Administrador")
                                        .font(.system(size: geo.size.width * 0.022, weight: .bold))
                                        .foregroundColor(vm.rolSeleccionado == "administrador" ? .white : .black)
                                        .frame(
                                            width: geo.size.width * 0.35,
                                            height: geo.size.height * 0.12
                                        )
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(vm.rolSeleccionado == "administrador" ? Color.orange : Color.white)
                                                .shadow(
                                                    color: vm.rolSeleccionado == "administrador" ? Color.orange.opacity(0.4) : Color.black.opacity(0.1),
                                                    radius: 8, x: 0, y: 4
                                                )
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    vm.rolSeleccionado == "administrador" ? Color.clear : Color.gray.opacity(0.2),
                                                    lineWidth: 1
                                                )
                                        )
                                }

                                // Botón Juez
                                Button(action: { vm.confirmarRol("juez") }) {
                                    Text("Juez")
                                        .font(.system(size: geo.size.width * 0.022, weight: .bold))
                                        .foregroundColor(vm.rolSeleccionado == "juez" ? .white : .black)
                                        .frame(
                                            width: geo.size.width * 0.35,
                                            height: geo.size.height * 0.12
                                        )
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(vm.rolSeleccionado == "juez" ? Color.orange : Color.white)
                                                .shadow(
                                                    color: vm.rolSeleccionado == "juez" ? Color.orange.opacity(0.4) : Color.black.opacity(0.1),
                                                    radius: 8, x: 0, y: 4
                                                )
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    vm.rolSeleccionado == "juez" ? Color.clear : Color.gray.opacity(0.2),
                                                    lineWidth: 1
                                                )
                                        )
                                }
                            }
                            .padding(.bottom, geo.size.height * 0.09)
                        }
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.14), radius: 20, x: 0, y: -5)
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    SeleccionUsuario()
        .previewInterfaceOrientation(.landscapeLeft)
}
