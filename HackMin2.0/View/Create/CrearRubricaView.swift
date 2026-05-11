//
//  CrearRubricaView.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//
import SwiftUI

struct CrearRubricaView: View {
    @StateObject private var vm         = CrearRubricaViewModel()
    @StateObject private var criteriosVM = CriteriosViewModel()
    @Binding var isPresented: Bool
    var onGuardar: (RubricaModel) -> Void

    // Controla si ya pasamos al paso de criterios
    @State private var mostrarCriterios: Bool = false
    @State private var mostrarCrearCriterio: Bool = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Diseño7").resizable().scaledToFill().ignoresSafeArea()

                if !mostrarCriterios {
                    // PASO 1: Nombre y descripción
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
                                    if let rubrica = vm.prepararRubrica() {
                                        criteriosVM.idConcurso = rubrica.id_concurso
                                        criteriosVM.idRubrica  = rubrica.id_rubrica
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            mostrarCriterios = true
                                        }
                                    }
                                },
                                style: .standard(
                                    fontColor: .white,
                                    backgroundColor: .orange,
                                    buttonName: "Siguiente →",
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

                } else {
                    // PASO 2: Agregar criterios y guardar
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color.white.opacity(0.5), lineWidth: 1))
                        .frame(width: geo.size.width * 0.75, height: geo.size.height * 0.85)

                    VStack(spacing: 0) {
                        // Header
                        HStack {
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    mostrarCriterios = false
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "chevron.left")
                                    Text("Volver")
                                }
                                .font(.system(size: geo.size.width * 0.013, weight: .semibold, design: .rounded))
                                .foregroundColor(.orange)
                            }

                            Spacer()

                            // Indicador peso total
                            HStack(spacing: 6) {
                                Image(systemName: "percent")
                                    .font(.system(size: geo.size.width * 0.012, weight: .semibold))
                                    .foregroundColor(criteriosVM.pesoCompleto ? .green : .orange)
                                Text("Peso total: \(Int(criteriosVM.pesoTotal))%")
                                    .font(.system(size: geo.size.width * 0.012, weight: .semibold, design: .rounded))
                                    .foregroundColor(criteriosVM.pesoCompleto ? .green : .orange)
                            }
                            .padding(.horizontal, geo.size.width * 0.015)
                            .padding(.vertical, geo.size.height * 0.01)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(criteriosVM.pesoCompleto ? Color.green.opacity(0.15) : Color.orange.opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(criteriosVM.pesoCompleto ? Color.green.opacity(0.4) : Color.orange.opacity(0.4), lineWidth: 1)
                                    )
                            )

                            Spacer()

                            // Botón agregar criterio
                            Button {
                                mostrarCrearCriterio = true
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Agregar criterio")
                                }
                                .font(.system(size: geo.size.width * 0.013, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, geo.size.width * 0.02)
                                .padding(.vertical, geo.size.height * 0.012)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.orange)
                                        .shadow(color: .orange.opacity(0.4), radius: 6, x: 0, y: 3)
                                )
                            }
                        }
                        .padding(.horizontal, geo.size.width * 0.04)
                        .padding(.top, geo.size.height * 0.03)

                        // Lista de criterios
                        ScrollView(.vertical, showsIndicators: false) {
                            if criteriosVM.criterios.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "list.bullet.rectangle")
                                        .font(.system(size: geo.size.width * 0.04))
                                        .foregroundColor(.white.opacity(0.4))
                                    Text("Aún no hay criterios")
                                        .font(.system(size: geo.size.width * 0.014, design: .rounded))
                                        .foregroundColor(.white.opacity(0.4))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, geo.size.height * 0.15)
                            } else {
                                LazyVStack(spacing: geo.size.height * 0.018) {
                                    ForEach(criteriosVM.criterios, id: \.id_criterio) { criterio in
                                        CriterioCardView(criterio: criterio, geo: geo)
                                    }
                                }
                                .padding(.horizontal, geo.size.width * 0.04)
                                .padding(.top, geo.size.height * 0.02)
                            }
                        }
                        .frame(maxHeight: geo.size.height * 0.55)

                        Spacer()

                        // Error y botón guardar
                        VStack(spacing: geo.size.height * 0.015) {
                            if vm.mostrarError {
                                Text(vm.mensajeError)
                                    .font(.system(size: geo.size.width * 0.013))
                                    .foregroundColor(.red)
                            }

                            CustomButton(
                                action: {
                                    vm.guardarRubrica(criterios: criteriosVM.criterios) { result in
                                        if case .success(let rubrica) = result {
                                            onGuardar(rubrica)
                                            isPresented = false
                                        }
                                    }
                                },
                                style: .standard(
                                    fontColor: .white,
                                    backgroundColor: criteriosVM.pesoCompleto ? .orange : .gray,
                                    buttonName: vm.cargando ? "Guardando..." : "Guardar rúbrica",
                                    fontName: "Helvetica Neue",
                                    fontSize: geo.size.width * 0.018,
                                    width: geo.size.width * 0.55,
                                    height: geo.size.height * 0.09
                                )
                            )
                        }
                        .padding(.bottom, geo.size.height * 0.04)
                    }
                    .frame(width: geo.size.width * 0.75, height: geo.size.height * 0.85)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .sheet(isPresented: $mostrarCrearCriterio) {
            CrearCriterioView(
                isPresented: $mostrarCrearCriterio,
                idConcurso:  criteriosVM.idConcurso,
                idRubrica:   criteriosVM.idRubrica,
                pesoUsado:   criteriosVM.pesoTotal
            ) { nuevoCriterio in
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    criteriosVM.agregarCriterio(nuevoCriterio)
                }
            }
            .presentationDetents([.fraction(0.92)])
            .presentationCornerRadius(28)
            .presentationBackground(.clear)
        }
    }
}


