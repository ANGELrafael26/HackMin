//
//  EquiposJuezViewModel.swift
//  HackMin2.0
//
//  Created by Naomi López on 08/05/26.
//

import SwiftUI
import Combine

@MainActor
class EquiposJuezViewModel: ObservableObject {

    @Published var equipos: [EquipoModel] = []
    @Published var rubrica: RubricaModel? = nil  // ya no mock
    @Published var equipoSeleccionado: EquipoModel? = nil
    @Published var mostrarRubrica: Bool = false
    @Published var cargando: Bool = true

    func seleccionarEquipo(_ equipo: EquipoModel) {
        equipoSeleccionado = equipo
        mostrarRubrica = true
    }

    func agregarEquipo(_ equipo: EquipoModel) {
        equipos.append(equipo)
    }

    func eliminarEquipo(id: String) {
        equipos.removeAll { $0.id_equipo == id }
    }

    func cargarEquipos() {
        EquipoRubricaService.shared.getEquiposConcursoActivo { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.cargando = false
                switch result {
                case .success(let equiposObtenidos):
                    withAnimation { self.equipos = equiposObtenidos }
                case .failure(let error):
                    print("Error al cargar equipos: \(error.localizedDescription)")
                }
            }
        }
    }

    func cargarRubrica() {
        EquipoRubricaService.shared.getRubricaConcursoActivo { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let rubricaObtenida):
                    self.rubrica = rubricaObtenida
                case .failure(let error):
                    print("Error al cargar rúbrica: \(error.localizedDescription)")
                }
            }
        }
    }
}
