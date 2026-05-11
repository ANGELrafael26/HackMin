//
//  CurrentCourseService.swift
//  HackMin2.0
//
//  Created by Jesus Ortega on 10/05/26.
//

import Foundation

class CurrentCourseService{
    static var shared = CurrentCourseService()
    var currentConcurso: ConcursoModel? = nil
    init(){}
    
    var currentCursoName: String{
        return currentConcurso?.nombre_evento ?? "Hackaton"
    }
    
    var currentCursoID: String{
        return currentConcurso?.id_concurso ?? "not found"
    }
    
    
}
