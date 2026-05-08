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
    
    @Published private(set) var isAdmin: Bool = false
    @Published private(set) var currentAdmin: AdministradorModel? = nil
    @Published private(set) var currentJuez: JuezModel? = nil
    
    private let adminDAO = AdministradorDAO()
    
    private init() {}
    
    func setCurrentJuez(juez: JuezModel?) {
        self.currentJuez = juez
        self.isAdmin = false
    }
    
    func setCurrentAdmin(admin: AdministradorModel?) {
        self.currentAdmin = admin
        self.isAdmin = (admin != nil)
    }
    
    var currentAdminName: String {
        return self.currentAdmin?.nombre ?? "Desconocido"
    }
    
    func loginAdministrador(correo: String, contrasena: String, completion: @escaping (Result<Void, Error>) -> Void) {
        adminDAO.getAdministrador(correo: correo) { [weak self] result in
            switch result {
            case .success(let admin):
                if admin.contrasena == contrasena {
                    self?.setCurrentAdmin(admin: admin)
                    completion(.success(()))
                } else {
                    completion(.failure(AdministradorError.invalidPassword))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logout() {
        self.currentAdmin = nil
        self.currentJuez = nil
        self.isAdmin = false
    }
}

