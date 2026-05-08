//
//  RubricaModel.swift
//  HackMin 2.0
//
//  Created by Naomi Lopez on 07/05/26.
//

import Foundation

struct RubricaModel: Codable, Hashable {
    var id_rubrica: String
    var id_concurso: String
    var nombre_rubrica: String
    var descripcion_rubrica: String
    var criterios: [CriterioModel]

    init(
        id_rubrica: String,
        id_concurso: String,
        nombre_rubrica: String,
        descripcion_rubrica: String,
        criterios: [CriterioModel] = []
    ) {
        self.id_rubrica = id_rubrica
        self.id_concurso = id_concurso
        self.nombre_rubrica = nombre_rubrica
        self.descripcion_rubrica = descripcion_rubrica
        self.criterios = criterios
    }

    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return nil
        }
        return dictionary
    }

    init?(from dictionary: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []),
              let decodedModel = try? JSONDecoder().decode(RubricaModel.self, from: data) else {
            return nil
        }
        self = decodedModel
    }

    var pesoTotal: Double {
        criterios.map(\.peso_porcentual).reduce(0, +)
    }
}
