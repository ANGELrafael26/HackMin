//
//  RubricaViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class RubricaViewModel: ObservableObject {
    @Published var rubricas: [RubricaModel] = []
    @Published var cargando: Bool = true
    @Published var isDeleted: Bool = true
    
    private let rubricaDAO = RubricaDAO()

    var idConcurso: String = ""

    func agregarRubrica(_ rubrica: RubricaModel) {
        rubricas.append(rubrica)
    }

    func actualizarRubrica(_ rubrica: RubricaModel) {
        if let index = rubricas.firstIndex(where: { $0.id_rubrica == rubrica.id_rubrica }) {
            rubricas[index] = rubrica
        }
    }
    
    func eliminarRubrica(id_rubrica: String) {
        rubricaDAO.deleteRubrica(id_rubrica: id_rubrica) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    withAnimation {
                        self?.rubricas.removeAll { $0.id_rubrica == id_rubrica }
                    }
                case .failure(let error):
                    print("Error al eliminar rúbrica: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func cargarRubricas(){
        rubricaDAO.getRubricas(porConcurso: CurrentCourseService.shared.currentCursoID){ [weak self] result in
            DispatchQueue.main.async {
                self?.cargando = false
                switch result {
                case .success(let rubricasObtenidas):
                    withAnimation {
                        self?.rubricas = rubricasObtenidas
                    }
                case .failure(let error):
                    print("Error al cargar equipos: \(error.localizedDescription)")
                }
            }
        }
    }

//   ' func eliminarRubrica(id: String) {
//        rubricas.removeAll { $0.id_rubrica == id }
//    }'
}
