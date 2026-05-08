//
//  CurrentUserManager.swift
//  HackMin 2.0
//
//  Created by Naomi Lopez on 03/05/26.
//

import Foundation
import Combine

class CurrentUserManager {
    
    static let shared = CurrentUserManager()
    private init() {}
    
    private(set) var currentAdmin: AdministradorModel? = nil
    private(set) var currentJuez: JuezModel? = nil
    
    func loginAdmin(correo: String, contrasena: String,
                    completion: @escaping (Result<AdministradorModel, Error>) -> Void) {
        AdministradorDAO().getAdministrador(correo: correo) { result in
            switch result {
            case .success(let admin):
                guard admin.contrasena == contrasena else {
                    completion(.failure(AdministradorError.wrongPassword))
                    return
                }
                self.currentAdmin = admin
                completion(.success(admin))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logout() {
        currentAdmin = nil
        currentJuez = nil
    }
    
    func setCurrentJuez(juez: JuezModel) {
        self.currentJuez = juez
    }
    
    var currentAdminName: String {
        return currentAdmin?.nombre ?? ""
    }
    
    var isLoggedIn: Bool {
        return currentAdmin != nil || currentJuez != nil
    }
}

