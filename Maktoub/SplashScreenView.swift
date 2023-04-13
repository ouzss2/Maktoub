//
//  SplashScreenView.swift
//  Maktoub
//
//  Created by user236595 on 3/24/23.
//

import SwiftUI


struct SplashScreenView: View {
    let gradiant = Gradient(colors: [Color("Black"),Color("Center"),Color("Gold")])
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    let email:String = UserDefaults.standard.string(forKey: "mail") ?? ""
    
  
    var body: some View {
        
        if isActive {
            if UserDefaults.standard.bool(forKey: "isLoggedIn") && !email.isEmpty{
                MainView()
            } else {
                LoginView()
                // User needs to log in, show the login interface
            }
            
           
        }else {
            
            
            VStack{
                Spacer()
                VStack{
                    Spacer()
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250,height: 250)
                        .font(.system(size: 80))
                    Spacer()
                       
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 1.5)){
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                    
                }
                Spacer()
                
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    withAnimation{
                        self.isActive = true                    }
                    
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: gradiant, startPoint: .top,
                                       endPoint: .bottom))
            .edgesIgnoringSafeArea(.all)
            
        }}
    
    
}
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
    
}


