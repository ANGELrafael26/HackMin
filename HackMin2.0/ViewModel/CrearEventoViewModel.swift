//
//  CrearEventoViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

class CrearEventoViewModel: ObservableObject {
    @Published var nombreEvento: String = ""
    @Published var fechaInicio: Date = Date()
    @Published var fechaFin: Date = Date()
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""
    @Published var eventoCreado: Bool = false

    // Formateador para convertir Date a String
    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f
    }()

    func crearEvento() -> ConcursoModel? {
        guard !nombreEvento.isEmpty else {
            mensajeError = "El nombre del evento es obligatorio."
            mostrarError = true
            return nil
        }
        guard fechaFin >= fechaInicio else {
            mensajeError = "La fecha de fin debe ser después de la fecha de inicio."
            mostrarError = true
            return nil
        }
        mostrarError = false
        return ConcursoModel(
            id_concurso: UUID().uuidString,
            nombre_evento: nombreEvento,
            fecha_inicio: formatter.string(from: fechaInicio),
            fecha_fin: formatter.string(from: fechaFin)
        )
    }
}
