//
//  CardC.swift
//  Maktoub
//
//  Created by user236595 on 3/27/23.
//

import Foundation

struct CardC: Codable,Hashable {
      var idpro: Int
      var nom: String
      var description: String
      var picture: String
      var prix: Double
      var qte:Int
    
    func hash(into hasher: inout Hasher) {
          hasher.combine(idpro)
          hasher.combine(nom)
          hasher.combine(picture)
          hasher.combine(prix)
        hasher.combine(qte)
        
    }
    
}
