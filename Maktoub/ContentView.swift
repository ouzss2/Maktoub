//
//  ContentView.swift
//  Maktoub
//
//  Created by user236595 on 3/24/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            Text("Maktoub")
                .foregroundColor(.white)
                .font(.system(size:30))
            ProgressView()
                .scaleEffect(3)
                .foregroundColor(.green)
                .progressViewStyle(CircularProgressViewStyle(tint: Color.gray))
                .padding(.bottom,20)
      }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
