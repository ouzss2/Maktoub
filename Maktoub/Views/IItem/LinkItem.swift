//
//  LinkItem.swift
//  Maktoub
//
//  Created by user236595 on 4/2/23.
//

import Foundation
struct LinkItem: Identifiable {
    var id = UUID()
    var title: String
    var destination: URL
    var imageName: String
    var linkDescription: String
    
    init(title: String, destination: URL, imageName: String, linkDescription: String) {
        self.title = title
        self.destination = destination
        self.imageName = imageName
        self.linkDescription = linkDescription
    }
    

    static let linkItems: [LinkItem] = [
        LinkItem(title: "Google", destination: URL(string: "https://www.google.com/maps")!, imageName: "Maps", linkDescription: ""),
        LinkItem(title: "Gmail", destination: URL(string: "https://www.google.com/gmail")!, imageName: "Gmail", linkDescription: ""),
        LinkItem(title: "Facebook", destination: URL(string: "https://www.facebook.com")!, imageName: "Facebook", linkDescription: ""),
        LinkItem(title: "Whatsup", destination: URL(string: "https://www.whatsapp.com")!, imageName: "Whatsup", linkDescription: ""),
        LinkItem(title: "youtube", destination: URL(string: "https://www.youtube.com")!, imageName: "Youtube", linkDescription: ""),
        LinkItem(title: "Linkedin", destination: URL(string: "https://www.linkedin.com")!, imageName: "Linkedin", linkDescription: ""),
        LinkItem(title: "instagram", destination: URL(string: "https://www.instagram.com")!, imageName: "Instagram", linkDescription: ""),
        LinkItem(title: "Snapshot", destination: URL(string: "https://www.snapchat.com")!, imageName: "Snapchat", linkDescription: ""),
        LinkItem(title: "google plus", destination: URL(string: "https://plus.google.com")!, imageName: "Googleplus", linkDescription: ""),
        LinkItem(title: "Reddit", destination: URL(string: "https://www.reddit.com")!, imageName: "Reddit", linkDescription: ""),
        LinkItem(title: "Twitter", destination: URL(string: "https://www.twitter.com")!, imageName: "Twitter", linkDescription: "")
       // LinkItem(title: "Other", destination: URL(string: "")!, imageName: "Twitter", linkDescription: "")
    ]

}

