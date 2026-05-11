// EquiposViewModel.swift
import Foundation
import SwiftUI
import Combine

class EquiposViewModel: ObservableObject {
    @Published var equipos: [EquipoModel] = []
    @Published var mostrarError: Bool = false
    @Published var mensajeError: String = ""
    @Published var mostrarCrearEquipo: Bool = false

    private let equipoDAO = EquipoDAO()
    var idConcurso: String = ""

    init() {
        // Equipo estático para pruebas — quita esto cuando conectes el backend
        equipos = [
            EquipoModel(
                id_equipo: "preview-1",
                id_concurso: "preview-concurso",
                problematica: "Falta de acceso a educación en zonas rurales",
                nombre_equipo: "Terra Mind",
                nombre_proyecto: "EduRural App",
                integrantes: ["Naomi", "Diego", "Sofía"]
            )
        ]
    }

    func cargarEquipos() {
        guard !idConcurso.isEmpty else {
            // Si no hay idConcurso (modo preview), dejamos el equipo estático
            return
        }
        equipoDAO.getEquipos(porConcurso: idConcurso) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let equiposObtenidos):
                    self?.equipos = equiposObtenidos
                case .failure(let error):
                    self?.mensajeError = error.localizedDescription
                    self?.mostrarError = true
                }
            }
        }
    }

    func agregarEquipo(_ equipo: EquipoModel) {
        equipos.append(equipo)
    }

    func eliminarEquipo(id: String) {
        equipos.removeAll { $0.id_equipo == id }
    }
}
