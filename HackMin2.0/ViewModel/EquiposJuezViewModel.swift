//
//  EquiposJuezViewModel.swift
//  HackMin2.0
//
//  Created by Naolop on 08/05/26.
//

import SwiftUI
import Combine

class EquiposJuezViewModel: ObservableObject {

    // MARK: - Equipos
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

    // MARK: - Rúbrica
    @Published var rubrica: RubricaModel? = RubricaModel(
        id_rubrica: "r1",
        id_concurso: "c1",
        nombre_rubrica: "Rúbrica General",
        descripcion_rubrica: "Criterios de evaluación del hackathon",
        criterios: [
            CriterioModel(
                id_criterio: "c1",
                id_concurso: "c1",
                id_rubrica: "r1",
                nombre_criterio: "Innovación",
                descripcion_criterio: "Qué tan innovadora es la solución",
                peso_porcentual: 30,
                puntaje_maximo: 10
            ),
            CriterioModel(
                id_criterio: "c2",
                id_concurso: "c1",
                id_rubrica: "r1",
                nombre_criterio: "Impacto Social",
                descripcion_criterio: "Impacto en la comunidad",
                peso_porcentual: 30,
                puntaje_maximo: 10
            ),
            CriterioModel(
                id_criterio: "c3",
                id_concurso: "c1",
                id_rubrica: "r1",
                nombre_criterio: "Presentación",
                descripcion_criterio: "Calidad de la presentación",
                peso_porcentual: 40,
                puntaje_maximo: 10
            )
        ]
    )

    // MARK: - Navegación
    @Published var equipoSeleccionado: EquipoModel? = nil
    @Published var mostrarRubrica: Bool = false

    // MARK: - Funciones
    func seleccionarEquipo(_ equipo: EquipoModel) {
        equipoSeleccionado = equipo
        mostrarRubrica = true
    }

    func agregarEquipo(_ equipo: EquipoModel) {
        equipos.append(equipo)
    }

    func eliminarEquipo(id: String) {
        equipos.removeAll { $0.id_equipo == id }
    }
}
