//
//  CalificacionModel.swift
//  HackMin 2.0
//
//  Created by Naomi López on 01/05/26.
//

import Foundation
struct CalificacionModel: Codable, Hashable {
    var id_calificacion: String
    var id_concurso: String
    var id_equipo: String
    var id_juez: String
    var puntajes_asignados: [String: Double] // Dictionary: ["id_criterio_1": 9.5, "id_criterio_2": 8.0]

    init(id_calificacion: String, id_concurso: String, id_equipo: String, id_juez: String, puntajes_asignados: [String: Double]) {
        self.id_calificacion = id_calificacion
        self.id_concurso = id_concurso
        self.id_equipo = id_equipo
        self.id_juez = id_juez
        self.puntajes_asignados = puntajes_asignados
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
              let decodedModel = try? JSONDecoder().decode(CalificacionModel.self, from: data) else {
            return nil
        }
        self = decodedModel
    }
}
