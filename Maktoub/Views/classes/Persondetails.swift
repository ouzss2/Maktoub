//
//  Persondetails.swift
//  Maktoub
//
//  Created by user236595 on 4/3/23.
//

import Foundation

struct Persondetails: Codable {
       var idperson: Int?
    var nom: String?
    var prenom: String?
    var photo: String?
    var couverture: String?
    var mail: String?
    var password: String?
    var tel: String?
    var adresse: String?
    var fonction: String?
    var username: String?
    var about: String?
    var roles: [String?]
    
}
