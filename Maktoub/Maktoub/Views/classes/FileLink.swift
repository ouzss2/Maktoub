//
//  FileLink.swift
//  Maktoub
//
//  Created by user236595 on 4/9/23.
//

import Foundation
struct FileLink : Codable,Identifiable {
    let id = UUID()

    let email:String
    let name:String
    let url:String
}
