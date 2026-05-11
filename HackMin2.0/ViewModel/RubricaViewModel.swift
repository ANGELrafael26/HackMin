//
//  RubricaViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

class RubricaViewModel: ObservableObject {
    @Published var rubricas: [RubricaModel] = []

    var idConcurso: String = ""

    func agregarRubrica(_ rubrica: RubricaModel) {
        rubricas.append(rubrica)
    }

    func actualizarRubrica(_ rubrica: RubricaModel) {
        if let index = rubricas.firstIndex(where: { $0.id_rubrica == rubrica.id_rubrica }) {
            rubricas[index] = rubrica
        }
    }

    func eliminarRubrica(id: String) {
        rubricas.removeAll { $0.id_rubrica == id }
    }
}
