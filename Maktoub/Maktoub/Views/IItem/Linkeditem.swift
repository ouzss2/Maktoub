//
//  Linkeditem.swift
//  Maktoub
//
//  Created by user236595 on 4/6/23.
//

import Foundation
struct Linkeditem: Decodable {
    
    let name: String
    let url: String
    let person: Persondetails
    
    static var linkItemsu: [LinkItem] = [
        LinkItem(title: "call", destination: URL(string: "tel://+18143519148")!, imageName: "call", linkDescription: ""),
    ]
}
