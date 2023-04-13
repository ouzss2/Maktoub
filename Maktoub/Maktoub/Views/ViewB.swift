//
//  ViewB.swift
//  Maktoub
//
//  Created by user236595 on 3/31/23.
//

import SwiftUI

struct ViewB: View {
    let gradiant = Gradient(colors: [Color("Black"),Color("Center"),Color("Gold")])
    
    var body: some View {
  
        GeometryReader { geometry in
            VStack {
                Spacer()
                MyView(backgroundImageName: "back", profileImageName: "perso")
                Spacer()
                
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: gradiant, startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea(.all)
            .navigationBarBackButtonHidden(true)
        }
        Spacer()
        
            
    }
}


struct ViewB_Previews: PreviewProvider {
    static var previews: some View {
        ViewB()
    }
}

  

    struct MyView: View {
        let backgroundImageName: String
        let profileImageName: String
        
        var body: some View {
            GeometryReader { geo in
                VStack {
                    Image(backgroundImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: 270)
                    
                    Image(profileImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .background(.clear)
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 5)
                        )
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(60)
                        .clipShape(Circle())
                        .padding(.trailing, 180)
                        .padding(.vertical, -80)
                    Button(action: {
                        // Add your button action here
                        
                           
                        
                    }) {
                        Text("Share Link")
                            .font(.system(size: 20))
                            .foregroundColor(.yellow)
                            .padding(.all,1)
                            .background(Color.black)
        
                    }
                    .padding(.trailing,-250)
                    
                    Spacer()
                    
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
