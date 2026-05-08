//
//  EquiposViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

class EquiposViewModel: ObservableObject {
    @Published var equipos: [EquipoModel] = [
        EquipoModel(
            id_equipo: "1",
            id_concurso: "c1",
            problematica: "Falta de acceso a agua potable",
            nombre_equipo: "AquaTech",
            nombre_proyecto: "HydroSense",
            integrantes: ["Ana", "Luis", "Sofía"],
            foto_perfil: EquipoModel.fotoPredeterminada
        ),
        EquipoModel(
            id_equipo: "2",
            id_concurso: "c1",
            problematica: "Residuos electrónicos sin reciclar",
            nombre_equipo: "GreenByte",
            nombre_proyecto: "EcoCircuit",
            integrantes: ["Carlos", "María"],
            foto_perfil: EquipoModel.fotoPredeterminada
        ),
        EquipoModel(
            id_equipo: "3",
            id_concurso: "c1",
            problematica: "Desnutrición infantil en zonas rurales",
            nombre_equipo: "NutriBot",
            nombre_proyecto: "SmartFood",
            integrantes: ["Diego", "Valeria", "Jorge"],
            foto_perfil: EquipoModel.fotoPredeterminada
        ),
        EquipoModel(
            id_equipo: "4",
            id_concurso: "c1",
            problematica: "Transporte público ineficiente",
            nombre_equipo: "MoveIQ",
            nombre_proyecto: "RouteAI",
            integrantes: ["Fernanda", "Tomás"],
            foto_perfil: EquipoModel.fotoPredeterminada
        )
    ]

    @Published var mostrarCrearEquipo: Bool = false
    var idConcurso: String = ""

    func agregarEquipo(_ equipo: EquipoModel) {
        equipos.append(equipo)
    }

    func eliminarEquipo(id: String) {
        equipos.removeAll { $0.id_equipo == id }
    }
}
