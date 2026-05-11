//
//  JuezModel.swift
//  HackMin 2.0
//
//  Created by Naomi López on 01/05/26.
//

import Foundation

struct JuezModel {
    var id_juez: String
    var alias: String
    var correo: String
    var contrasena: String
    var id_concurso_asignado: String?
 
    init(id_juez: String, nombre: String, correo: String, contrasena: String, id_concurso_asignado: String? = nil) {
        self.id_juez = id_juez
        self.alias = nombre
        self.correo = correo
        self.contrasena = contrasena
        self.id_concurso_asignado = id_concurso_asignado
    }
 
    init?(from dictionary: [String: Any]) {
        guard
            let id = dictionary["id_juez"] as? String,
            let nombre = dictionary["nombre"] as? String,
            let correo = dictionary["correo"] as? String,
            let contrasena = dictionary["contrasena"] as? String
        else { return nil }
 
        self.id_juez = id
        self.alias = nombre
        self.correo = correo
        self.contrasena = contrasena
        self.id_concurso_asignado = dictionary["id_concurso_asignado"] as? String
    }
 
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id_juez": id_juez,
            "nombre": alias,
            "correo": correo,
            "contrasena": contrasena
        ]
        if let idConcurso = id_concurso_asignado {
            dict["id_concurso_asignado"] = idConcurso
        }
        return dict
    }
}
