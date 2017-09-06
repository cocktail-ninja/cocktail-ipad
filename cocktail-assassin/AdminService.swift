//
//  AdminService.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 21/1/16.
//  Copyright © 2016 tw. All rights reserved.
//

import Foundation

class AdminService {
    
    var isAdmin = false
    
    static let sharedInstance = AdminService()
    
    func login(_ password: String) -> Bool {
        if password == "tasty" {
            isAdmin = true
            return true
        }
        return false
    }
    
    func logout() {
        isAdmin = false
    }
    
}
