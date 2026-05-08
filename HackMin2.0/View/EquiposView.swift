//
//  EquiposView.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import SwiftUI

struct EquiposView: View {
    @StateObject private var vm = EquiposViewModel()
    @State private var mostrarCrearEquipo = false
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack(alignment: .topTrailing) {
                    Image("Diseño7").resizable().scaledToFill().ignoresSafeArea()
                    // Grid de equipos
                    ScrollView {
                        if vm.equipos.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "person.3")
                                    .font(.system(size: geo.size.width * 0.04))
                                    .foregroundColor(.white.opacity(0.4))
                                Text("Aún no hay equipos registrados")
                                    .font(.system(size: geo.size.width * 0.014, design: .rounded))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, geo.size.height * 0.3)
                        } else {
                            LazyVGrid(columns: columns, spacing: geo.size.height * 0.03) {
                                ForEach(vm.equipos, id: \.id_equipo) { equipo in
                                    NavigationLink(destination: DetalleEquipoView(equipo: equipo)) {
                                        EquipoCardView(equipo: equipo, geo: geo)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, geo.size.width * 0.05)
                            .padding(.top, geo.size.height * 0.12)
                            .padding(.bottom, geo.size.height * 0.05)
                        }
                    }
                    
                    // Botón agregar equipo
                    Button {
                        mostrarCrearEquipo = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: geo.size.width * 0.018))
                            Text("Agregar equipo")
                                .font(.system(size: geo.size.width * 0.013, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, geo.size.width * 0.025)
                        .padding(.vertical, geo.size.height * 0.018)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.orange)
                                .shadow(color: .orange.opacity(0.4), radius: 8, x: 0, y: 4)
                        )
                    }
                    .padding(.top, geo.size.height * 0.02)
                    .padding(.trailing, geo.size.width * 0.03)
                    
                }
            }
            .onAppear {
                vm.cargarEquipos()
            }
            .sheet(isPresented: $mostrarCrearEquipo) {
                CrearEquipoView(
                    isPresented: $mostrarCrearEquipo,
                    idConcurso: vm.idConcurso
                ) { nuevoEquipo in
                    withAnimation(.spring(response: 0.7, dampingFraction: 0.90)) {
                        vm.agregarEquipo(nuevoEquipo)
                    }
                }
                .presentationDetents([.fraction(0.92)])
                .presentationCornerRadius(28)
                .presentationBackground(.clear)
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Tarjeta de equipo
struct EquipoCardView: View {
    let equipo: EquipoModel
    let geo: GeometryProxy
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [Color.orange, Color.orange.opacity(0.75)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: .orange.opacity(0.35), radius: 10, x: 0, y: 6)
            .frame(height: geo.size.height * 0.22)
            .overlay(
                VStack(spacing: geo.size.height * 0.018) {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: geo.size.width * 0.07, height: geo.size.width * 0.07)
                        .overlay(
                            Image(equipo.foto_perfil)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        )
                        .overlay(Circle().stroke(Color.white.opacity(0.6), lineWidth: 2))
                    
                    Text(equipo.nombre_equipo)
                        .font(.system(size: geo.size.width * 0.014, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                    .padding(.horizontal, 12)
            )
    }
}

#Preview {
    ZStack {
        Image("Diseño7").resizable().scaledToFill().ignoresSafeArea()
        EquiposView()
    }
    .previewInterfaceOrientation(.landscapeLeft)
}
