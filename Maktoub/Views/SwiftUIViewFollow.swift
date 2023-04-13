//
//  SwiftUIViewFollow.swift
//  Maktoub
//
//  Created by user236595 on 4/5/23.
//

import SwiftUI

struct SwiftUIViewFollow: View {
    @State private var isFollowersSelected = true
    
    let gradiant = Gradient(colors: [Color("Black"),Color("Center"),Color("Gold")])
    let emailsent:String = UserDefaults.standard.string(forKey: "mail") ?? ""
    @State var selectedOption = "Follow"

      var body: some View {
          
       
              VStack {
                 
                  HStack {
                    Button(action: { self.selectedOption = "Follow" }) {
                        Text("Following")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black)
                            .padding(.horizontal)
                        }
                        Button(action: { self.selectedOption = "Followers" }) {
                            Text("Followers")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black)
                                .padding(.horizontal)
                                }
                  }.padding(.top,50)
                      
                     
                  Spacer()
                            if selectedOption == "Follow" {
                                FollowView(isFollowers: false)
                            } else {
                                FollowView(isFollowers: true)
                            }
                  
             
           } .frame(maxWidth: .infinity, maxHeight: .infinity)
              .background(LinearGradient(gradient: gradiant, startPoint: .top, endPoint: .bottom))
              .ignoresSafeArea(.all)
              .navigationBarBackButtonHidden(true)
              
          }
        
}

struct SwiftUIViewFollow_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIViewFollow()
    }
}

struct ShowFollowers: View {
    var body: some View{
        Text("Hello")
    }
}
struct FollowView: View {
    var isFollowers: Bool
    
    var body: some View {
        ScrollView{
            VStack {
                Text(isFollowers ? "Followers" : "Following")
                    .font(.title)
                    .padding()
                    .foregroundColor(.white)
                VStack {
                    if isFollowers  {
                    ForEach(FileFollow.lst) { index in
                        HStack {
                            Image(index.imaget)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                                .shadow(radius: 5)
                            VStack{
                                Text(index.name)
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight:.bold))
                                    .multilineTextAlignment(.center)
                                    .padding()
                                Text(index.mail)
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight:.bold))
                                    .lineLimit(18)
                                    .truncationMode(.tail)
                                    .padding()
                            }
                          
                        }
                        
                        
                        
                    }
                        
                    }else {
                        ForEach(FileFollow.lstf) { index in
                            HStack {
                                Image(index.imaget)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                                    .shadow(radius: 5)
                                VStack{
                                    Text(index.name)
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight:.bold))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(18)
                                        
                                        .padding()
                                    Text(index.mail)
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(18)
                                        .truncationMode(.tail)
                                        .padding()
                                }
                              
                            }
                            
                            
                            
                        }
                    }
                        Divider().background(.gray)
                 
                }
            }.background(.clear)
        }}
}
