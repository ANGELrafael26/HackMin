//
//  ConcursoModel.swift
//  HackMin 2.0
//
//  Created by Naomi López on 01/05/26.
//

import Foundation

struct ConcursoModel: Codable, Hashable {
    var id_concurso: String
    var nombre_evento: String
    var fecha_inicio: String
    var fecha_fin: String

    init(id_concurso: String, nombre_evento: String, fecha_inicio: String, fecha_fin: String) {
        self.id_concurso = id_concurso
        self.nombre_evento = nombre_evento
        self.fecha_inicio = fecha_inicio
        self.fecha_fin = fecha_fin
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
              let decodedModel = try? JSONDecoder().decode(ConcursoModel.self, from: data) else {
            return nil
        }
        self = decodedModel
    }
}
