//
//  SwiftUIViewFinalView.swift
//  Maktoub
//
//  Created by user236595 on 4/5/23.
//

import SwiftUI

struct SwiftUIViewFinalView: View {
    let gradiant = Gradient(colors: [Color("Black"),Color("Center"),Color("Gold")])
    @State var per:Person
    @StateObject var cartManager = CartManager()
    let emailuerd:String = UserDefaults.standard.string(forKey: "mail") ?? ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                PersonDetailViewF(person: per)
                Spacer()
                CardViewConFt(cardList: cartManager.cards)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: gradiant, startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            .onAppear {
               getUserByEmail(email: emailuerd) { person in
                   per.tel = person?.tel ?? ""
                   per.adresse = person?.adresse ?? ""
                   per.username = person?.username ?? ""
                   per.prenom = person?.prenom ?? ""
                   per.nom = person?.nom ?? ""
                   per.mail = person?.mail ?? ""
                  
               }}
            
        }
    }
}

struct SwiftUIViewFinalView_Previews: PreviewProvider {
    static var previews: some View {
        let rr = Person(nom: "", prenom: "", mail: "", password: "", tel: "", username: "", adresse: "")
        SwiftUIViewFinalView(per:rr)
    }
}

struct PersonDetailViewF: View {
    var person: Person
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.bottom,30)
            Text("Nom: \(person.nom)")
                .foregroundColor(.white)
                .padding(.all,2)
            Text("Prénom: \(person.prenom)")
                .foregroundColor(.white)
                .padding(.all,2)
            Text("E-mail: \(person.mail)")
                .foregroundColor(.white)
                .padding(.all,2)
            Text("Téléphone: \(person.tel)")
                .foregroundColor(.white)
                .padding(.all,2)
            Text("Adresse: \(person.adresse)")
                .foregroundColor(.white)
                .padding(.all,2)
        }
        Spacer()
       
    }
}
struct CardViewConFt: View {
    var cardList: [CardC]
    @Environment(\.presentationMode) var presentationMode
    @StateObject var cartManager = CartManager()
    @State var isCommandF: Bool = false
    var body: some View {
        ScrollView{
            ForEach(cardList, id: \.idpro) { card in
                VStack{
                    
                    HStack() {
                        HStack() {
                            
                            if let imageData = Data(base64Encoded: card.picture),
                               let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .background(.clear)
                                    .padding(.horizontal,30)
                                
                            } else {
                                Image(systemName: "logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .padding(.horizontal,30)
                            }
                            
                        }.background(.clear)
                        VStack(alignment: .center, spacing: 5) {
                            Text(card.nom)
                                .foregroundColor(.white)
                                .font(.system(size: 25))
                            
                            
                            Text("\(card.qte)")
                                .font(.system(size: 20))
                                .foregroundColor(.green)
                                .padding(.top,15)
                            
                            
                            Text(String(format: "%.2f", card.prix))
                                .font(.system(size: 20))
                                .foregroundColor(.green)
                                .padding(.top,15)
                            
                        }
                    }
                    .padding(.top,20)
                    .background(.clear)
                    
                    
                    
                }
            }
        }
        
        VStack (){
            Spacer()
            HStack{
                Button(action: {
                
                    isCommandF = true
                    cartManager.clearCart()
                
                    
                    
                }) {
                    Text("Back")
                        .padding()
                        .frame(maxWidth: 150)
                        .cornerRadius(10)
                        .background(.black)
                        .foregroundColor(.white)
                }.padding(.all,20)
                   .fullScreenCover(isPresented: $isCommandF, content: {
                       MainView()
                               .navigationBarHidden(true)
                               .onDisappear {
                                   presentationMode.wrappedValue.dismiss()
                               }
               
                   })
                                    
                                    }
           
            
        }
        Spacer()
    }
    
}


