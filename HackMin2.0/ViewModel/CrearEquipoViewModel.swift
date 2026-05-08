//
//  CrearEquipoViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

class CrearEquipoViewModel: ObservableObject {
    @Published var nombreEquipo: String = ""
    @Published var nombreProyecto: String = ""
    @Published var problematica: String = ""
    @Published var integrantesTexto: String = ""
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""

    // Convierte el texto de integrantes separado por comas en array
    var integrantesArray: [String] {
        integrantesTexto
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    func crearEquipo(idConcurso: String) -> EquipoModel? {
        guard !nombreEquipo.isEmpty else {
            mensajeError = "El nombre del equipo es obligatorio."
            mostrarError = true
            return nil
        }
        guard !nombreProyecto.isEmpty else {
            mensajeError = "El nombre del proyecto es obligatorio."
            mostrarError = true
            return nil
        }
        guard !integrantesArray.isEmpty else {
            mensajeError = "Agrega al menos un integrante."
            mostrarError = true
            return nil
        }
        mostrarError = false
        return EquipoModel(
            id_equipo: UUID().uuidString,
            id_concurso: idConcurso,
            problematica: problematica,
            nombre_equipo: nombreEquipo,
            nombre_proyecto: nombreProyecto,
            integrantes: integrantesArray
        )
    }
}
