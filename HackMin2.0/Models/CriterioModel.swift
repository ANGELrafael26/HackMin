//
//  CriterioModel.swift
//  HackMin 2.0
//
//  Created by Naomi López on 01/05/26.
//

import Foundation
struct CriterioModel: Codable, Hashable {
    var id_criterio: String
    var id_concurso: String
    var nombre_criterio: String
    var descripcion_criterio: String
    var peso_porcentual: Double  
    var puntaje_maximo: Double

    init(id_criterio: String, id_concurso: String, nombre_criterio: String, descripcion_criterio: String, peso_porcentual: Double, puntaje_maximo: Double) {
        self.id_criterio = id_criterio
        self.id_concurso = id_concurso
        self.nombre_criterio = nombre_criterio
        self.descripcion_criterio = descripcion_criterio
        self.peso_porcentual = peso_porcentual
        self.puntaje_maximo = puntaje_maximo
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
              let decodedModel = try? JSONDecoder().decode(CriterioModel.self, from: data) else {
            return nil
        }
        self = decodedModel
    }
}
