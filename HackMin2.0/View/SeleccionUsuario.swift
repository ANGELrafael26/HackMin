//
//  SeleccionUsuario.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import SwiftUI

struct SeleccionUsuario: View {
    @State private var mostrarPanel: Bool = false
    @State private var rolSeleccionado: String? = "administrador"

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                Image("Diseño7")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    CustomButton(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                            mostrarPanel.toggle()
                        }
                    }, style: .image(imageName: "Boton", width: geo.size.width * 0.07, height: geo.size.width * 0.07))
                    .padding(.bottom, geo.size.height * 0.12)
                }

                if mostrarPanel {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                mostrarPanel = false
                            }
                        }
                }

                if mostrarPanel {
                    VStack(spacing: geo.size.height * 0.025) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: geo.size.width * 0.04, height: geo.size.height * 0.006)
                            .padding(.top, geo.size.height * 0.02)

                        Text("Selecciona tu rol")
                            .font(.system(size: geo.size.width * 0.025, weight: .semibold))
                            .foregroundColor(.black)

                        HStack(spacing: geo.size.width * 0.04) {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    rolSeleccionado = "administrador"
                                }
                            }) {
                                Text("Administrador")
                                    .font(.system(size: geo.size.width * 0.022, weight: .bold))
                                    .foregroundColor(rolSeleccionado == "administrador" ? .white : .black)
                                    .frame(width: geo.size.width * 0.35, height: geo.size.height * 0.12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(rolSeleccionado == "administrador" ? Color.orange : Color.white)
                                            .shadow(
                                                color: rolSeleccionado == "administrador" ? Color.orange.opacity(0.4) : Color.black.opacity(0.1),
                                                radius: 8, x: 0, y: 4
                                            )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(rolSeleccionado == "administrador" ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    rolSeleccionado = "juez"
                                }
                            }) {
                                Text("Juez")
                                    .font(.system(size: geo.size.width * 0.022, weight: .bold))
                                    .foregroundColor(rolSeleccionado == "juez" ? .white : .black)
                                    .frame(width: geo.size.width * 0.35, height: geo.size.height * 0.12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(rolSeleccionado == "juez" ? Color.orange : Color.white)
                                            .shadow(
                                                color: rolSeleccionado == "juez" ? Color.orange.opacity(0.4) : Color.black.opacity(0.1),
                                                radius: 8, x: 0, y: 4
                                            )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(rolSeleccionado == "juez" ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
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
    }
}

#Preview {
    SeleccionUsuario()
        .previewInterfaceOrientation(.landscapeLeft)
}
