//
//  RubricaJuezView.swift
//  HackMin2.0
//
//  Created by Dan Figueroa on 08/05/26.
//

import SwiftUI

struct RubricaJuezView: View {
    
    let equipo: EquipoModel
    let rubrica: RubricaModel
    
    // NUEVO
    var onCalificado: () -> Void
    
    @StateObject private var vm = RubricaJuezViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Diseño7")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // Card glassmorphism
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                    .frame(
                        width: geo.size.width * 0.80,
                        height: geo.size.height * 0.82
                    )
                
                HStack(spacing: 0) {
                    
                    // Lado izquierdo — info equipo
                    VStack(spacing: geo.size.height * 0.025) {
                        
                        // Foto equipo
                        Circle()
                            .fill(Color.white.opacity(0.25))
                            .frame(
                                width: geo.size.width * 0.10,
                                height: geo.size.width * 0.10
                            )
                            .overlay(
                                Image(equipo.foto_perfil)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                            )
                            .overlay(Circle().stroke(Color.white.opacity(0.6), lineWidth: 2))
                        
                        Text(equipo.nombre_equipo)
                            .font(.system(size: geo.size.width * 0.018, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        
                        Text(equipo.nombre_proyecto)
                            .font(.system(size: geo.size.width * 0.013, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Divider()
                            .padding(.horizontal, 16)
                        
                        Text(rubrica.nombre_rubrica)
                            .font(.system(size: geo.size.width * 0.013, weight: .semibold))
                            .foregroundColor(.orange)
                            .multilineTextAlignment(.center)
                        
                        Text(rubrica.descripcion_rubrica)
                            .font(.system(size: geo.size.width * 0.011))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 12)
                        
                        Spacer()
                        
                        // Puntaje total en tiempo real
                        VStack(spacing: 4) {
                            Text("Puntaje total")
                                .font(.system(size: geo.size.width * 0.011, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Text(String(format: "%.1f%%", vm.puntajeTotal(rubrica: rubrica)))
                                .font(.system(size: geo.size.width * 0.028, weight: .bold, design: .rounded))
                                .foregroundColor(.orange)
                        }
                        .padding(.bottom, geo.size.height * 0.03)
                    }
                    .frame(width: geo.size.width * 0.80 * 0.32)
                    .padding(.vertical, geo.size.height * 0.04)
                    
                    // Divider
                    Rectangle()
                        .fill(Color.white.opacity(0.4))
                        .frame(width: 1, height: geo.size.height * 0.65)
                    
                    // Lado derecho — criterios
                    ScrollView {
                        VStack(spacing: geo.size.height * 0.03) {
                            
                            ForEach(rubrica.criterios, id: \.id_criterio) { criterio in
                                
                                CriterioRow(
                                    criterio: criterio,
                                    calificacion: vm.calificacion(para: criterio),
                                    geo: geo
                                )
                            }
                            
                            if vm.mostrarError {
                                Text(vm.mensajeError)
                                    .font(.system(size: geo.size.width * 0.013))
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                            }
                            
                            if vm.calificacionEnviada {
                                Text("¡Calificación enviada correctamente!")
                                    .font(.system(size: geo.size.width * 0.013, weight: .semibold))
                                    .foregroundColor(.green)
                            }
                            
                            CustomButton(
                                action: {
                                    
                                    vm.enviarCalificacion(
                                        rubrica: rubrica,
                                        equipo: equipo
                                    )
                                    
                                    if vm.calificacionEnviada {
                                        
                                        // NUEVO
                                        onCalificado()
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                            dismiss()
                                        }
                                    }
                                },
                                style: .standard(
                                    fontColor: .white,
                                    backgroundColor: .orange,
                                    buttonName: "Enviar calificación",
                                    fontName: "Helvetica Neue",
                                    fontSize: geo.size.width * 0.016,
                                    width: geo.size.width * 0.80 * 0.55,
                                    height: geo.size.height * 0.09
                                )
                            )
                            .padding(.bottom, geo.size.height * 0.04)
                        }
                        .padding(.top, geo.size.height * 0.04)
                        .padding(.horizontal, geo.size.width * 0.025)
                    }
                    .frame(width: geo.size.width * 0.80 * 0.65)
                }
                .frame(
                    width: geo.size.width * 0.80,
                    height: geo.size.height * 0.82
                )
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
    }
}

// MARK: - Fila de criterio con TextField
struct CriterioRow: View {
    let criterio: CriterioModel
    @Binding var calificacion: String
    let geo: GeometryProxy

    var body: some View {
        VStack(alignment: .leading, spacing: geo.size.height * 0.012) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(criterio.nombre_criterio)
                        .font(.system(size: geo.size.width * 0.015, weight: .bold, design: .rounded))
                        .foregroundColor(.black)

                    Text(criterio.descripcion_criterio)
                        .font(.system(size: geo.size.width * 0.011))
                        .foregroundColor(.gray)
                }

                Spacer()

                // Badges peso y máximo
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Peso: \(Int(criterio.peso_porcentual))%")
                        .font(.system(size: geo.size.width * 0.010, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Color.orange))

                    Text("Máx: \(Int(criterio.puntaje_maximo))")
                        .font(.system(size: geo.size.width * 0.010, weight: .semibold))
                        .foregroundColor(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Color.orange.opacity(0.15)))
                }
            }

            // TextField calificación
            HStack {
                TextField("0 – \(Int(criterio.puntaje_maximo))", text: $calificacion)
                    .keyboardType(.decimalPad)
                    .font(.system(size: geo.size.width * 0.016, weight: .semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .frame(width: geo.size.width * 0.10, height: geo.size.height * 0.07)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.85))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.orange.opacity(0.5), lineWidth: 1.5)
                            )
                    )

                Text("/ \(Int(criterio.puntaje_maximo)) pts")
                    .font(.system(size: geo.size.width * 0.012))
                    .foregroundColor(.gray)
            }
        }
        .padding(geo.size.width * 0.018)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.55))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                )
        )
        .frame(width: geo.size.width * 0.80 * 0.60)
    }
}
