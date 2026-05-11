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

    @Published var codigo: String = ""

    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""
    @Published var isLoading: Bool = false
    @Published var juezAutenticado: JuezModel? = nil

    private let dao = JuezDAO()

    func ingresar(completion: @escaping (Bool) -> Void) {
        print("First print")

        guard !codigo.trimmingCharacters(in: .whitespaces).isEmpty else {
            mensajeError = "Por favor ingresa tu código."
            mostrarError = true
            completion(false)
            return
        }

        isLoading = true
        mostrarError = false

        ConcursoJuezService.shared.loginJuez(id_juez: codigo) { [weak self] result in
            print("second print")
            DispatchQueue.main.async {

                guard let self = self else { return }

                self.isLoading = false

                switch result {

                case .success(let (juez, concurso)):

                    print("\(juez.nombre) → \(concurso.nombre_evento)")

                    self.juezAutenticado = juez
                    completion(true)

                case .failure(let error):
                    print("third print")

                    self.mensajeError = error.localizedDescription
                    self.mostrarError = true

                    completion(false)
                }
            }
        }
    }

    func resetForm() {
        codigo = ""
        mostrarError = false
        mensajeError = ""
        juezAutenticado = nil
    }
}
