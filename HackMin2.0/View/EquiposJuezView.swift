//
//  EquiposJuezView.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import SwiftUI

struct EquiposJuezView: View {

    @StateObject private var vm = EquiposJuezViewModel()

    // IDs de equipos ya calificados
    @State private var equiposCalificados: Set<String> = []

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {

        NavigationStack {

            GeometryReader { geo in

                ZStack(alignment: .top) {

                    Image("Diseño7")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()

                    ScrollView {

                        if vm.equipos.isEmpty {

                            VStack(spacing: 12) {

                                Image(systemName: "person.3")
                                    .font(.system(size: geo.size.width * 0.04))
                                    .foregroundColor(.white.opacity(0.4))

                                Text("No hay equipos registrados")
                                    .font(.system(size: geo.size.width * 0.014, design: .rounded))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, geo.size.height * 0.3)

                        } else {

                            LazyVGrid(columns: columns, spacing: geo.size.height * 0.03) {

                                ForEach(vm.equipos, id: \.id_equipo) { equipo in

                                    NavigationLink {

                                        if let rubrica = vm.rubrica {

                                            RubricaJuezView(
                                                equipo: equipo,
                                                rubrica: rubrica
                                            ) {
                                                equiposCalificados.insert(equipo.id_equipo)
                                            }
                                        }

                                    } label: {

                                        ZStack {

                                            // Fondo verde si ya fue calificado
                                            RoundedRectangle(cornerRadius: 24)
                                                .fill(
                                                    equiposCalificados.contains(equipo.id_equipo)
                                                    ? Color.green.opacity(0.28)
                                                    : Color.clear
                                                )
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 24)
                                                        .stroke(
                                                            equiposCalificados.contains(equipo.id_equipo)
                                                            ? Color.green.opacity(0.9)
                                                            : Color.clear,
                                                            lineWidth: 2
                                                        )
                                                )

                                            EquipoCardView(
                                                equipo: equipo,
                                                geo: geo
                                            )
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, geo.size.width * 0.05)
                            .padding(.top, geo.size.height * 0.08)
                            .padding(.bottom, geo.size.height * 0.05)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    EquiposJuezView()
        .previewInterfaceOrientation(.landscapeLeft)
}
