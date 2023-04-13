//
//  Card.swift
//  Maktoub
//
//  Created by user236595 on 3/26/23.
//

import Foundation

struct Card: Codable,Hashable,Identifiable {
    
     var id: Int
      var nom: String
    
      var description: String
       var picture: String
      var prix: Double
    
    func hash(into hasher: inout Hasher) {
          hasher.combine(id)
          hasher.combine(nom)
          hasher.combine(picture)
          hasher.combine(prix)
        
    }
    
}
