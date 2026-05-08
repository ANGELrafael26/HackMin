//
//  CrearEquipoViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class CrearEquipoViewModel: ObservableObject {
    @Published var nombreEquipo: String = ""
    @Published var nombreProyecto: String = ""
    @Published var problematica: String = ""
    @Published var integrantesTexto: String = ""
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""

    // Instancia del DAO
    private let equipoDAO = EquipoDAO()

    // Convierte el texto de integrantes separado por comas en array
    var integrantesArray: [String] {
        integrantesTexto
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    func guardarEquipo(idConcurso: String) -> EquipoModel? {
        guard !nombreEquipo.trimmingCharacters(in: .whitespaces).isEmpty else {
            mensajeError = "El nombre del equipo es obligatorio."
            mostrarError = true
            return nil
        }
        guard !nombreProyecto.trimmingCharacters(in: .whitespaces).isEmpty else {
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
        
        let nuevoEquipo = EquipoModel(
            id_equipo: UUID().uuidString,
            id_concurso: idConcurso,
            problematica: problematica.trimmingCharacters(in: .whitespaces),
            nombre_equipo: nombreEquipo.trimmingCharacters(in: .whitespaces),
            nombre_proyecto: nombreProyecto.trimmingCharacters(in: .whitespaces),
            integrantes: integrantesArray
        )
        
        // Llamada al DAO para guardar
        equipoDAO.saveEquipo(nuevoEquipo) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.mostrarError = false
                    // Aquí puedes agregar lógica adicional si necesitas limpiar los campos
                    // o notificar a la vista que se guardó exitosamente.
                case .failure(let error):
                    self?.mensajeError = error.localizedDescription
                    self?.mostrarError = true
                }
            }
        }
        
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
