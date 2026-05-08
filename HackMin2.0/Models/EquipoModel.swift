//
//  EquipoModel.swift
//  HackMin 2.0
//
//  Created by Naomi López on 01/05/26.
//

import Foundation

struct EquipoModel: Codable, Hashable {
    var id_equipo: String
    var id_concurso: String
    var problematica: String
    var nombre_equipo: String
    var nombre_proyecto: String
    var integrantes: [String] 

    init(id_equipo: String, id_concurso: String, problematica: String, nombre_equipo: String, nombre_proyecto: String, integrantes: [String]) {
        self.id_equipo = id_equipo
        self.id_concurso = id_concurso
        self.problematica = problematica
        self.nombre_equipo = nombre_equipo
        self.nombre_proyecto = nombre_proyecto
        self.integrantes = integrantes
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
              let decodedModel = try? JSONDecoder().decode(EquipoModel.self, from: data) else {
            return nil
        }
        self = decodedModel
    }
}
