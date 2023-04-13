//
//  MainView.swift
//  Maktoub
//
//  Created by user236595 on 3/31/23.
//

import SwiftUI

enum Tab {
    case home, profile, about, logout
}

struct MainView: View {
    let gradiant = Gradient(colors: [Color("Black"),Color("Center"),Color("Gold")])
    
    @State private var selection: Tab = .profile
    @State private var showLoginView = false
    @State private var selectedTab = 0
    @State var isreg:Bool = false
    @State private var showingLogoutAlert = false
    @State var emailsent:String = UserDefaults.standard.string(forKey: "mail") ?? ""
    //@State var user: Persondetails?
    let manage = LinkManager()
   
  
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var itemslst: [Linkeditem] = []

    func fetchLinkItems(email: String, completion: @escaping ([Linkeditem]) -> Void) {
        let urlString = "http://104.225.216.185:9300/links"
        guard var urlComponents = URLComponents(string: urlString) else {
            completion([])
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "email", value: email)
        ]
        guard let url = urlComponents.url else {
            completion([])
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            let decoder = JSONDecoder()
            do {
                let linkItems = try decoder.decode([Linkeditem].self, from: data)
                completion(linkItems)
            } catch {
                completion([])
            }
        }
        task.resume()
    }
   
    @ViewBuilder
    var body: some View {
       
        VStack{
            
       
        if horizontalSizeClass == .compact {
            ZStack(alignment: .bottom) {
                VStack {
                    Spacer()
                    viewForSelectedTab()
                    Spacer()
                    
                }
                tabBar()
                
                
            }
            .ignoresSafeArea(.all)
            .navigationBarBackButtonHidden(true)
           
            .onAppear {
                self.selectedTab = 1
                  
            }
           
            
        }else{
            GeometryReader { geometry in
                      ZStack(alignment: .bottom) {
                          VStack {
                              Spacer()
                            
                                  viewForSelectedTab()
                              
                              Spacer()
                              
                          }	
                          tabBar()
                        
                      }
                      
                      .onAppear {
                          self.selectedTab = 1
                      }
                      .edgesIgnoringSafeArea(.all)
                      .navigationBarBackButtonHidden(true)
                      .frame(width: geometry.size.width, height: geometry.size.height)
                  }
        }
            
        }
        .ignoresSafeArea(.all)
     
   
     
    }
    
    
    
    func viewForSelectedTab() -> some View {
        switch selectedTab {
        case 0:
            return AnyView(SwiftUIViewProducts().frame(maxWidth: .infinity, maxHeight: .infinity))
        case 1:
            return AnyView(SwiftUIViewProfile())
        case 2:
            return AnyView(SwiftUIViewAbout())
        case 3:
            return AnyView(SwiftUIViewFollow())
        default:
            return AnyView(EmptyView())
        }
    }
    
    func tabBar() -> some View {
        
        HStack(spacing: 8) {
            Spacer()
                tabBarItem(imageName: "house", index: 0)
            tabBarItem(imageName: "person", index: 1)
            tabBarItem(imageName: "info.circle.fill", index: 2)
            tabBarItem(imageName: "heart.fill", index: 3)
            logoutButton()
            Spacer()
        }.padding()
        .background(Color("Gold"))
        .shadow(radius: 0)
        
        
    }
    
    func tabBarItem(imageName: String, index: Int) -> some View {
      
        Button(action: { self.selectedTab = index }) {
            Image(systemName: imageName)
                .foregroundColor(selectedTab == index ? .white : .black)
                .font(.system(size: 30))
                .padding()
        }
       // .background(selectedTab == index ? Color.cyan : Color.clear)
    
    }
    
    func logoutButton() -> some View {
        VStack {
            Button(action: {
                showingLogoutAlert = true
            }) {
                Image(systemName: "arrow.right.to.line")
                    .font(.system(size: 30))
                    .foregroundColor(selectedTab == 4 ? .white : .black)
                    .padding()
            }
           
            .fullScreenCover(isPresented: $isreg, content: {
                LoginView()
                    .navigationBarHidden(true)
                    .onDisappear {
                        SwiftUIViewEditProfile().onDisappear{
                            presentationMode.wrappedValue.dismiss()
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
            })
           
        }
        .alert(isPresented: $showingLogoutAlert) {
            Alert(title: Text("Logout"), message: Text("Are you sure you want to log out?"), primaryButton: .destructive(Text("Logout")) {
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                UserDefaults.standard.set("", forKey: "mail")
                UserDefaults.standard.set("", forKey: "nom")
                UserDefaults.standard.set("", forKey: "prenom")
                UserDefaults.standard.set("", forKey: "tel")
                isreg = true
                selectedTab = 4
                presentationMode.wrappedValue.dismiss()
            }, secondaryButton: .cancel())
        }}
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
