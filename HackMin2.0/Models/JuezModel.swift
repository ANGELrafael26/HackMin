//
//  JuezModel.swift
//  HackMin 2.0
//
//  Created by Naomi López on 01/05/26.
//

import Foundation

struct JuezModel: Codable, Hashable {
    var id_juez: String
    var id_concurso: String
    var alias: String
    var codigo_juez: String

    init(id_juez: String, id_concurso: String, alias: String, codigo_juez: String) {
        self.id_juez = id_juez
        self.id_concurso = id_concurso
        self.alias = alias
        self.codigo_juez = codigo_juez
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
              let decodedModel = try? JSONDecoder().decode(JuezModel.self, from: data) else {
            return nil
        }
        self = decodedModel
    }
}
