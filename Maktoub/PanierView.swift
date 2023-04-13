//
//  PanierView.swift
//  Maktoub
//
//  Created by user236595 on 3/27/23.
//
import Combine
import SwiftUI

struct PanierView: View {
    @State var cards: [CardC] = []
   
    let emailuer:String = UserDefaults.standard.string(forKey: "mail") ?? ""
    let gradiant = Gradient(colors: [Color("Black"),Color("Center"),Color("Gold")])
    @Environment(\.presentationMode) var presentationMode
    @State private var isPressedbtn: Bool = false
    
    var body: some View {

        GeometryReader { geometry in
                   VStack {
                       Spacer()
                       CardView(cardList: cards)
                       Spacer()
                       HStack {
                           Button(action: {
                               // Action for first button
                               presentationMode.wrappedValue.dismiss()
                           }) {
                               Text("BACK")
                                   .padding()
                                   
                                   .cornerRadius(10)
                                   .background(.black)
                                   .foregroundColor(.white)
                           }
                          
                           Button(action: {
                               // Action for second button
                               isPressedbtn = true
                           }) {
                               Text("CONFIRM")
                                   .padding()
                                   
                                   .cornerRadius(10)
                                   .background(.black)
                                   .foregroundColor(.white)
                           }.padding()
                               .fullScreenCover(isPresented: $isPressedbtn, content: {
                                   
                                   if emailuer.isEmpty || emailuer.isEmpty {
                                   ConfirmView(cards: cards,person: Person(nom: "", prenom: "", mail: "", password: "", tel: "", username: "", adresse: "")).navigationBarHidden(true)
                                   } else {
                                       SwiftUIViewConfirmView(cards: cards,per: Person(nom: "", prenom: "", mail: "", password: "", tel: "", username: "", adresse: ""))
                                           .navigationBarHidden(true)
                                    }
                                         
                               })
                              /* .sheet(isPresented: $isPressedbtn){
                                   if emailuer.isEmpty || emailuer.isEmpty {
                                   ConfirmView(cards: cards,person: Person(nom: "", prenom: "", mail: "", password: "", tel: "", username: "", adresse: ""))
                                   } else {
                                       SwiftUIViewConfirmView(cards: cards,per: Person(nom: "", prenom: "", mail: "", password: "", tel: "", username: "", adresse: ""))
                                    }
                               }*/
                       }
                       .padding()
                       Spacer()
                   }
                   .frame(maxWidth: .infinity, maxHeight: .infinity)
                   .background(LinearGradient(gradient: gradiant, startPoint: .top, endPoint: .bottom))
                   .ignoresSafeArea(.all)
                   .navigationBarBackButtonHidden(true)
            
               }
     
           }


      
}

struct PanierView_Previews: PreviewProvider {
    static var previews: some View {
        PanierView()
    }
}

struct CardView: View {
    var cardList: [CardC]
    
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
    }
}
