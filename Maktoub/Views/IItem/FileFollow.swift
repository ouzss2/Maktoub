//
//  FileFollow.swift
//  Maktoub
//
//  Created by user236595 on 4/9/23.
//

import Foundation
struct FileFollow: Decodable,Identifiable{
    
    var id: UUID
    let name: String
    let imaget: String
    let mail: String
    init(name: String, imaget: String, mail: String) {
         self.id = UUID()
         self.name = name
         self.imaget = imaget
         self.mail = mail
     }
    
    static var lst: [FileFollow] = [
        FileFollow(name: "Follower 1", imaget: "perso",mail: "Follower1@gmail.com"),
        FileFollow(name: "Follower 2", imaget: "perso",mail: "Follower1@gmai2.com"),
        FileFollow(name: "Follower 3", imaget: "perso",mail: "Follower1@gmai3.com")
    ]
    
    static var lstf: [FileFollow] = [
        FileFollow(name: "Followeing 1", imaget: "perso",mail: "Followeing1@gmail.com"),
        FileFollow(name: "Followeing 2", imaget: "perso",mail: "Followeing2@gmai2.com"),
        FileFollow(name: "Followeing 3", imaget: "perso",mail: "Followeing3@gmai3.com")
    ]
}
