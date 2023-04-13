//
//  LinkManager.swift
//  Maktoub
//
//  Created by user236595 on 4/9/23.
//

import Foundation
class LinkManager: ObservableObject {
    @Published var links: [FileLink] = []
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        if let data = userDefaults.data(forKey: "links"), let savedLinks = try? JSONDecoder().decode([FileLink].self, from: data) {
            links = savedLinks
        }
    }
    
    func add(link: FileLink) {
        links.append(link)
        saveLinks()
    }
    
 
    
    func clearLinks() {
        links = []
        saveLinks()
    }
    
    private func saveLinks() {
        if let encodedLinks = try? JSONEncoder().encode(links) {
            userDefaults.set(encodedLinks, forKey: "links")
        }
    }
    
    func refresh() {
         if let data = userDefaults.data(forKey: "links"), let savedLinks = try? JSONDecoder().decode([FileLink].self, from: data) {
             links = savedLinks
         } else {
             links = []
         }
     }
}
