//
//  CrearCriterioViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

// CrearCriterioViewModel.swift
class CrearCriterioViewModel: ObservableObject {
    @Published var nombreCriterio: String = ""
    @Published var descripcion: String = ""
    @Published var pesoPorcentual: String = ""
    @Published var puntajeMaximo: String = ""
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""

    func crearCriterio(idConcurso: String, idRubrica: String, pesoUsado: Double) -> CriterioModel? {
        guard !nombreCriterio.trimmingCharacters(in: .whitespaces).isEmpty else {
            mensajeError = "El nombre del criterio es obligatorio."
            mostrarError = true
            return nil
        }
        guard !descripcion.trimmingCharacters(in: .whitespaces).isEmpty else {
            mensajeError = "La descripción es obligatoria."
            mostrarError = true
            return nil
        }
        guard let peso = Double(pesoPorcentual), peso > 0, peso <= 100 else {
            mensajeError = "El peso debe ser un número entre 1 y 100."
            mostrarError = true
            return nil
        }
        
        // ← validación clave: el nuevo peso no puede exceder el disponible
        let pesoDisponible = 100.0 - pesoUsado
        guard peso <= pesoDisponible else {
            mensajeError = pesoDisponible <= 0
                ? "Ya se usó el 100% del peso disponible."
                : "Solo quedan \(Int(pesoDisponible))% disponibles (total no puede superar 100%)."
            mostrarError = true
            return nil
        }
        
        guard let puntaje = Double(puntajeMaximo), puntaje > 0 else {
            mensajeError = "El puntaje máximo debe ser mayor a 0."
            mostrarError = true
            return nil
        }
        mostrarError = false
        return CriterioModel(
            id_criterio: UUID().uuidString,
            id_concurso: idConcurso,
            id_rubrica: idRubrica,
            nombre_criterio: nombreCriterio.trimmingCharacters(in: .whitespaces),
            descripcion_criterio: descripcion.trimmingCharacters(in: .whitespaces),
            peso_porcentual: peso,
            puntaje_maximo: puntaje
        )
    }
}
