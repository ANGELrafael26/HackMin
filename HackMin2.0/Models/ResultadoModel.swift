//
//  ResultadoModel.swift
//  HackMin 2.0
//
//  Created by Naomi López on 01/05/26.
//

import Foundation
struct ResultadoModel: Codable, Hashable {
    var id_resultado: String
    var id_concurso: String
    var id_equipo: String
    var puntaje_total: Double

    init(id_resultado: String, id_concurso: String, id_equipo: String, puntaje_total: Double) {
        self.id_resultado = id_resultado
        self.id_concurso = id_concurso
        self.id_equipo = id_equipo
        self.puntaje_total = puntaje_total
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
              let decodedModel = try? JSONDecoder().decode(ResultadoModel.self, from: data) else {
            return nil
        }
        self = decodedModel
    }
}
