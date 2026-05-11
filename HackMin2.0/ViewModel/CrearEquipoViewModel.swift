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
    @Published var cargando: Bool = false

    var integrantesArray: [String] {
        integrantesTexto
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    func guardarEquipo(completion: @escaping (EquipoModel?) -> Void) {
        guard !nombreEquipo.trimmingCharacters(in: .whitespaces).isEmpty else {
            mensajeError = "El nombre del equipo es obligatorio."
            mostrarError = true
            completion(nil)
            return
        }
        guard !nombreProyecto.trimmingCharacters(in: .whitespaces).isEmpty else {
            mensajeError = "El nombre del proyecto es obligatorio."
            mostrarError = true
            completion(nil)
            return
        }
        guard !integrantesArray.isEmpty else {
            mensajeError = "Agrega al menos un integrante."
            mostrarError = true
            completion(nil)
            return
        }

        mostrarError = false
        cargando = true

        EquipoRubricaService.shared.crearEquipo(
            nombre:         nombreEquipo.trimmingCharacters(in: .whitespaces),
            nombreProyecto: nombreProyecto.trimmingCharacters(in: .whitespaces),
            problematica:   problematica.trimmingCharacters(in: .whitespaces),
            integrantes:    integrantesArray,
            fotoPerfil:     EquipoModel.fotoPredeterminada
        ) { [weak self] result in
            guard let self else { return }
            self.cargando = false
            switch result {
            case .success(let equipo):
                completion(equipo)
            case .failure(let error):
                self.mensajeError = error.localizedDescription
                self.mostrarError = true
                completion(nil)
            }
        }
    }
}
