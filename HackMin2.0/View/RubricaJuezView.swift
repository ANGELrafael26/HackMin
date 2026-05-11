//
//  RubricaJuezView.swift
//  HackMin2.0
//
//  Created by Naomi López on 08/05/26.
//
import SwiftUI

struct RubricaJuezView: View {
    let equipo: EquipoModel
    let rubrica: RubricaModel
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

                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                    .frame(width: geo.size.width * 0.80, height: geo.size.height * 0.82)

                HStack(spacing: 0) {

                    // Lado izquierdo — info equipo + puntaje
                    VStack(spacing: geo.size.height * 0.025) {

                        Circle()
                            .fill(Color.white.opacity(0.25))
                            .frame(width: geo.size.width * 0.10, height: geo.size.width * 0.10)
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

                        Divider().padding(.horizontal, 16)

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

                        // Puntaje total + barra de progreso
                        let total = vm.puntajeTotal(rubrica: rubrica)
                        VStack(spacing: geo.size.height * 0.010) {
                            Text("Puntaje total")
                                .font(.system(size: geo.size.width * 0.011, weight: .medium))
                                .foregroundColor(.gray)

                            Text(String(format: "%.1f%%", total))
                                .font(.system(size: geo.size.width * 0.028, weight: .bold, design: .rounded))
                                .foregroundColor(
                                    total > 100 ? .red :
                                    total == 100 ? .green : .orange
                                )
                                .animation(.easeInOut(duration: 0.2), value: total)

                            // Barra
                            GeometryReader { barGeo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 6)
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(
                                            total > 100 ? Color.red :
                                            total == 100 ? Color.green : Color.orange
                                        )
                                        .frame(
                                            width: barGeo.size.width * CGFloat(min(total, 100)) / 100,
                                            height: 6
                                        )
                                        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: total)
                                }
                            }
                            .frame(height: 6)
                            .padding(.horizontal, 8)

                            // Etiqueta debajo de la barra
                            if total == 100 {
                                Text("¡Puntaje completo!")
                                    .font(.system(size: geo.size.width * 0.010, weight: .semibold, design: .rounded))
                                    .foregroundColor(.green.opacity(0.85))
                            } else if total > 100 {
                                Text("Supera el 100%")
                                    .font(.system(size: geo.size.width * 0.010, weight: .semibold, design: .rounded))
                                    .foregroundColor(.red.opacity(0.85))
                            } else {
                                Text("Faltan \(String(format: "%.1f", 100 - total))%")
                                    .font(.system(size: geo.size.width * 0.010, design: .rounded))
                                    .foregroundColor(.gray.opacity(0.7))
                            }
                        }
                        .padding(.bottom, geo.size.height * 0.03)
                    }
                    .frame(width: geo.size.width * 0.80 * 0.32)
                    .padding(.vertical, geo.size.height * 0.04)

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
                                    vm.enviarCalificacion(rubrica: rubrica, equipo: equipo)
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
                            .onChange(of: vm.calificacionEnviada) { enviada in
                                if enviada {
                                    onCalificado()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                        dismiss()
                                    }
                                }
                            }
                            .padding(.bottom, geo.size.height * 0.04)
                        }
                        .padding(.top, geo.size.height * 0.04)
                        .padding(.horizontal, geo.size.width * 0.025)
                    }
                    .frame(width: geo.size.width * 0.80 * 0.65)
                }
                .frame(width: geo.size.width * 0.80, height: geo.size.height * 0.82)
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

    // Calcula si el valor actual es válido para colorear el borde
    private var valorActual: Double? { Double(calificacion) }
    private var bordeColor: Color {
        guard let val = valorActual else { return Color.orange.opacity(0.5) }
        if val > criterio.puntaje_maximo { return .red }
        if val == criterio.puntaje_maximo { return .green }
        return Color.orange.opacity(0.5)
    }

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

            HStack(spacing: geo.size.width * 0.012) {
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
                                    .stroke(bordeColor, lineWidth: 1.5)
                            )
                    )
                    .animation(.easeInOut(duration: 0.2), value: calificacion)

                Text("/ \(Int(criterio.puntaje_maximo)) pts")
                    .font(.system(size: geo.size.width * 0.012))
                    .foregroundColor(.gray)

                // Indicador inline si excede
                if let val = valorActual, val > criterio.puntaje_maximo {
                    Text("Máx \(Int(criterio.puntaje_maximo))")
                        .font(.system(size: geo.size.width * 0.010, weight: .semibold))
                        .foregroundColor(.red)
                }
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

#Preview {
    let mockEquipo = EquipoModel(
        id_equipo: "12", id_concurso: "1", problematica: "Problemas",
        nombre_equipo: "Terra Mind", nombre_proyecto: "Terra Mind",
        integrantes: ["Naomi"]
    )
    let mockCriterios: [CriterioModel] = [
        CriterioModel(id_criterio: "c1", id_concurso: "c1", id_rubrica: "r1",
                      nombre_criterio: "Innovación", descripcion_criterio: "Descripción",
                      peso_porcentual: 30, puntaje_maximo: 10),
        CriterioModel(id_criterio: "c2", id_concurso: "c1", id_rubrica: "r1",
                      nombre_criterio: "Creatividad", descripcion_criterio: "Descripción",
                      peso_porcentual: 40, puntaje_maximo: 10),
        CriterioModel(id_criterio: "c3", id_concurso: "c1", id_rubrica: "r1",
                      nombre_criterio: "Impacto", descripcion_criterio: "Descripción",
                      peso_porcentual: 30, puntaje_maximo: 10),
    ]
    let mockRubrica = RubricaModel(
        id_rubrica: "r1", id_concurso: "c1",
        nombre_rubrica: "Rúbrica General",
        descripcion_rubrica: "Criterios de evaluación para el hackathon.",
        criterios: mockCriterios
    )
    RubricaJuezView(equipo: mockEquipo, rubrica: mockRubrica, onCalificado: {})
        .previewInterfaceOrientation(.landscapeLeft)
}
