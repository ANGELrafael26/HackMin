//
//  ViewPrincipalAdminViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//
import SwiftUI
import Combine

class ViewPrincipalAdminViewModel: ObservableObject {
    @Published var navegarCrearEvento: Bool = false
    @Published var navegarHistorial: Bool = false
    @Published var mostrarTabView: Bool = false
    @Published var concursoActivo: ConcursoModel? = nil

    private let conectorDAO = ConectorConcursoDAO()
    private let concursoDAO = ConcursoDAO()

    init() {
        verificarConcursoActivo()
    }

    func verificarConcursoActivo() {
        conectorDAO.getConcursoActivo { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure:
                break 

            case .success(let conector):
                guard let conector else { return }

                self.concursoDAO.getConcurso(id_concurso: conector.id_concurso) { concursoResult in
                    DispatchQueue.main.async {
                        switch concursoResult {
                        case .success(let concurso):
                            CurrentCourseService.shared.currentConcurso = concurso
                            self.concursoActivo = concurso
                            self.mostrarTabView = true
                        case .failure:
                            break
                        }
                    }
                }
            }
        }
    }
}
