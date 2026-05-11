//
//  ConectorCurso.swift
//  HackMin2.0
//
//  Created by Jesus Ortega on 10/05/26.
//

import Foundation

struct ConectorConcursoModel {
    var id_concurso: String
    var id_jueces: [String]
    var id_admin: String
    var activo: Bool
 
    init(id_concurso: String, id_jueces: [String] = [], id_admin: String, activo: Bool = true) {
        self.id_concurso = id_concurso
        self.id_jueces = id_jueces
        self.id_admin = id_admin
        self.activo = activo
    }
 
    init?(from dictionary: [String: Any]) {
        guard
            let id = dictionary["id_concurso"] as? String,
            let idAdmin = dictionary["id_admin"] as? String
        else { return nil }
 
        self.id_concurso = id
        self.id_admin = idAdmin
        self.activo = dictionary["activo"] as? Bool ?? true
 
        // Los jueces se guardan como dict { id_juez: true } para facilitar queries en Firebase
        if let juecesDict = dictionary["id_jueces"] as? [String: Bool] {
            self.id_jueces = juecesDict.filter { $0.value }.map { $0.key }
        } else {
            self.id_jueces = []
        }
    }
 
    func toDictionary() -> [String: Any] {
        let juecesDict = Dictionary(uniqueKeysWithValues: id_jueces.map { ($0, true) })
        return [
            "id_concurso": id_concurso,
            "id_jueces": juecesDict,
            "id_admin": id_admin,
            "activo": activo
        ]
    }
}

enum IDGenerator {
    static func newConcursoID() -> String {
        let suffix = UUID().uuidString.prefix(6).uppercased()
        return "CONCURSO-\(suffix)"
    }
    
    static func newJuezID() -> String {
        let suffix = UUID().uuidString.prefix(2).uppercased()
        return "JUEZ-\(suffix)"
    }
    static func newRubricaID() -> String {
        let suffix = UUID().uuidString.prefix(6).uppercased()
        return "RUBRICA-\(suffix)"
    }

    static func newCriterioID() -> String {
        let suffix = UUID().uuidString.prefix(6).uppercased()
        return "CRITERIO-\(suffix)"
    }

    static func newCalificacionID() -> String {
        let suffix = UUID().uuidString.prefix(6).uppercased()
        return "CALIF-\(suffix)"
    }
}
