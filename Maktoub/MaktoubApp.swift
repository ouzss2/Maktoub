//
//  MaktoubApp.swift
//  Maktoub
//
//  Created by user236595 on 3/24/23.
//

import SwiftUI



@main
struct MaktoubApp: App {
    @StateObject var cartManager = CartManager()
    @StateObject var linkManager = LinkManager()
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(cartManager)
                .environmentObject(linkManager)
        }
    }
}
