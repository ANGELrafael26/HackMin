//
//  LogInJuezViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import SwiftUI
import Combine

@MainActor
final class LogInJuezViewModel: ObservableObject {

    // MARK: - Published Fields
    @Published var codigo: String = ""

    // MARK: - UI State
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""
    @Published var isLoading: Bool = false
    @Published var juezAutenticado: JuezModel? = nil

    // MARK: - DAO
    private let dao = JuezDAO()

    // MARK: - Actions
    func ingresar() {
        guard !codigo.trimmingCharacters(in: .whitespaces).isEmpty else {
            mensajeError = "Por favor ingresa tu código."
            mostrarError = true
            return
        }

        isLoading = true
        mostrarError = false

//        dao.loginJuez(codigo: codigo.trimmingCharacters(in: .whitespaces)) { [weak self] result in
//            guard let self else { return }
//            self.isLoading = false
//
//            switch result {
//            case .success(let juez):
//                self.juezAutenticado = juez
//                CurrentUserManager.shared.setCurrentJuez(juez: juez)
//            case .failure(let error):
//                self.mensajeError = error.localizedDescription
//                self.mostrarError = true
//            }
//        }
    }

    // MARK: - Reset
    func resetForm() {
        codigo = ""
        mostrarError = false
        mensajeError = ""
        juezAutenticado = nil
    }
}
