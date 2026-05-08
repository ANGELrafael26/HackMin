//
//  LogInJuez.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import SwiftUI

struct LogInJuez: View {
    @StateObject private var vm = LogInJuezViewModel()
    @State private var mostrarEquipos = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Diseño7")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.clear)
                    .glassEffect()
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .frame(width: geo.size.width * 0.60, height: geo.size.height * 0.55)

                HStack(spacing: 0) {
                    VStack {
                        Image("juez1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.13, height: geo.size.width * 0.13)
                    }
                    .frame(width: geo.size.width * 0.50 * 0.38)

                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 1, height: geo.size.height * 0.35)

                    VStack(spacing: geo.size.height * 0.04) {
                        CustomTextField(
                            placeholder: "Código del juez",
                            text: $vm.codigo,
                            type: .normal,
                            backgroundColor: .white.opacity(0.85),
                            foregroundColor: .black,
                            tittleColor: .black,
                            cornerRadius: 30,
                            height: geo.size.height * 0.08,
                            width: geo.size.width * 0.50 * 0.55
                        )

                        if vm.mostrarError {
                            Text(vm.mensajeError)
                                .font(.system(size: geo.size.width * 0.013))
                                .foregroundColor(.red)
                        }

                        CustomButton(
                            action: {
                                vm.ingresar()

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    if !vm.mostrarError {
                                        mostrarEquipos = true
                                    }
                                }
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
        }.fullScreenCover(isPresented: $mostrarEquipos) {
            EquiposJuezView()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        LogInJuez()
    }
    .previewInterfaceOrientation(.landscapeLeft)
}
