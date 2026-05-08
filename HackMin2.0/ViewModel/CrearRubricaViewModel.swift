//
//  CrearRubricaViewModel.swift
//  HackMin2.0
//
//  Created by Dan Figueroa on 08/05/26.


import Foundation
import SwiftUI
import Combine

class CrearRubricaViewModel: ObservableObject {
    @Published var nombreRubrica: String = ""
    @Published var descripcion: String = ""
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""

    func crearRubrica(idConcurso: String) -> RubricaModel? {
        guard !nombreRubrica.trimmingCharacters(in: .whitespaces).isEmpty else {
            mensajeError = "El nombre de la rúbrica es obligatorio."
            mostrarError = true
            return nil
        }
        guard !descripcion.trimmingCharacters(in: .whitespaces).isEmpty else {
            mensajeError = "La descripción es obligatoria."
            mostrarError = true
            return nil
        }
        mostrarError = false
        return RubricaModel(
            id_rubrica: UUID().uuidString,
            id_concurso: idConcurso,
            nombre_rubrica: nombreRubrica.trimmingCharacters(in: .whitespaces),
            descripcion_rubrica: descripcion.trimmingCharacters(in: .whitespaces),
            criterios: []
        )
    }
}
