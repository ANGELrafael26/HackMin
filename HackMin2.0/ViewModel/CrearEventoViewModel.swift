//
//  CrearEventoViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

import Foundation
import SwiftUI
import Combine

@MainActor
final class CrearEventoViewModel: ObservableObject {

    // MARK: - Published Fields
    @Published var nombreEvento: String = ""
    @Published var fechaInicio: Date = Date()
    @Published var fechaFin: Date = Date()

    // MARK: - UI State
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""
    @Published var eventoCreado: Bool = false
    @Published var isLoading: Bool = false

    // MARK: - DAO
    private let dao = ConcursoDAO()

    // MARK: - Formatter
    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f
    }()

    // MARK: - Validation
    var isFormValid: Bool {
        !nombreEvento.trimmingCharacters(in: .whitespaces).isEmpty &&
        fechaFin >= fechaInicio
    }

    // MARK: - Private: construir modelo
    private func construirConcurso() -> ConcursoModel? {
        guard !nombreEvento.trimmingCharacters(in: .whitespaces).isEmpty else {
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
            nombre_evento: nombreEvento.trimmingCharacters(in: .whitespaces),
            fecha_inicio: formatter.string(from: fechaInicio),
            fecha_fin: formatter.string(from: fechaFin)
        )
    }

    // MARK: - Actions
    func guardarEvento() {
        guard let concurso = construirConcurso() else { return }

        isLoading = true

        dao.saveConcurso(concurso) { [weak self] result in
            guard let self else { return }
            self.isLoading = false

            switch result {
            case .success:
                self.eventoCreado = true
                self.mostrarError = false
                self.resetForm()
            case .failure(let error):
                self.mensajeError = error.localizedDescription
                self.mostrarError = true
            }
        }
    }

    // MARK: - Reset
    func resetForm() {
        nombreEvento = ""
        fechaInicio = Date()
        fechaFin = Date()
        mostrarError = false
        mensajeError = ""
    }
}
