//
//  AdministradorModel.swift
//  HackMin 2.0
//
//  Created by Naomi López on 01/05/26.
//

import Foundation

struct AdministradorModel: Codable, Hashable {
    var id: UUID
    var nombre: String
    var correo: String
    var contrasena: String

    init(id: UUID,nombre: String, correo: String, contrasena: String) {
        self.id = id
        self.nombre = nombre
        self.correo = correo
        self.contrasena = contrasena
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
              let decodedModel = try? JSONDecoder().decode(AdministradorModel.self, from: data) else {
            return nil
        }
        self = decodedModel
    }
}
