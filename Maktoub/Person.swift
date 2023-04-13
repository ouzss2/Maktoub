//
//  Person.swift
//  Maktoub
//
//  Created by user236595 on 3/25/23.
//

import Foundation


struct Person: Encodable {
    let id = UUID()
    var nom: String
    var prenom: String
    var mail: String
    var password: String
    var tel: String
    var username: String
    var adresse: String;
 
    
    
}
