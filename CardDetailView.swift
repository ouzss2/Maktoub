//
//  CardDetailView.swift
//  Maktoub
//
//  Created by user236595 on 3/27/23.
//

import SwiftUI

struct CardDetailView: View {
    let gradiant = Gradient(colors: [Color("Black"),Color("Center"),Color("Gold")])
    @State var card: Card
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                ShowElements(card: $card)
                
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: gradiant, startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            
        }
    }
    
    struct CardDetailView_Previews: PreviewProvider {
        static var previews: some View {
            let card = Card(id: 0, nom: "Card 1", description: "This is card 1", picture: "logo", prix: 9.99)
            
            return CardDetailView(card: card)
        }
    }}





struct ShowElements: View {
    @Binding var card:Card
    @State var isPressedAdd: Bool = false
    @State var isPressedBack: Bool = false
    @State var isPressedPanier: Bool = false
    
   // @EnvironmentObject var cardManager: CardManager
    @State private var text = "1"
    @StateObject var cartManager = CartManager()
    

    @Environment(\.presentationMode) var presentationMode
    var items: [CardC] = []
    var body: some View {
        VStack {
          Spacer()
            if let imageData = Data(base64Encoded: card.picture),
               let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .background(.clear)
                    .padding(.bottom,20)
                
            } else {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            }
            
            VStack(alignment: .center, spacing: 5) {
                Text(card.nom)
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                Text(String(format: "%.2f", card.prix))
                    .font(.system(size: 20))
                    .foregroundColor(.green)
                    .padding(.top,15)
                
                TextField("Enter text",text: $text)
                    .frame(width: 50)
                    .padding(.top,15)
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                
                
                Button(action: {
                    // Action for first button
                  
                    let qte:Int = Int(text) ?? 0
                    let car = CardC(idpro: card.id, nom: card.nom, description: card.description, picture: card.picture, prix: card.prix, qte: qte)
                    //objectNode.add(card: car)
                    cartManager.add(card: car);
                    
                }) {
                    Text("ADD TO CART")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .background(.black)
                        .foregroundColor(.white)
                }
                .padding(.all,20)
              
            }
            
            
            Spacer()
            
            HStack {
                Button(action: {
                    
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("BACK")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .background(.black)
                        .foregroundColor(.white)
                }
                .padding()
              
                Button(action: {
                   isPressedPanier = true
                }) {
                    Text("PANIER")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .background(.black)
                        .foregroundColor(.white)
                }.padding()
               
                .fullScreenCover(isPresented: $isPressedPanier, content: {
                    
                    PanierView(cards: cartManager.cards)
                            .navigationBarHidden(true)
                          
                })
            }
            .padding()
        }
    }
}


