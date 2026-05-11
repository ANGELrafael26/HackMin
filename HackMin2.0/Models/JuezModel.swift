//
//  JuezModel.swift
//  HackMin 2.0
//
//  Created by Naomi López on 01/05/26.
//

import Foundation

struct JuezModel: Identifiable {
    let id = UUID()
    var id_juez: String
    var nombre: String          // en Firebase se llama "nombre"
    var correo: String
    var contrasena: String
    var id_concurso_asignado: String?

    func toDictionary() -> [String: Any]? {
        var dict: [String: Any] = [
            "id_juez":    id_juez,
            "nombre":     nombre,   // ← alias se guarda como "nombre"
            "correo":     correo,
            "contrasena": contrasena
        ]
        if let idConcurso = id_concurso_asignado {
            dict["id_concurso_asignado"] = idConcurso
        }
        return dict
    }

    init?(from dictionary: [String: Any]) {
        guard
            let idJuez  = dictionary["id_juez"] as? String,
            let nombre  = dictionary["nombre"] as? String,
            let correo  = dictionary["correo"] as? String,
            let contra  = dictionary["contrasena"] as? String
        else { return nil }

        self.id_juez    = idJuez
        self.nombre      = nombre   // ← "nombre" de Firebase → alias en Swift
        self.correo     = correo
        self.contrasena = contra
        self.id_concurso_asignado = dictionary["id_concurso_asignado"] as? String
    }

    init(id_juez: String, alias: String, correo: String,
         contrasena: String, id_concurso_asignado: String? = nil) {
        self.id_juez                = id_juez
        self.nombre                  = alias
        self.correo                 = correo
        self.contrasena             = contrasena
        self.id_concurso_asignado   = id_concurso_asignado
    }
}
