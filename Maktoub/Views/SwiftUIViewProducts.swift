//
//  SwiftUIViewProducts.swift
//  Maktoub
//
//  Created by user236595 on 4/2/23.
//

import SwiftUI

import Connectivity



struct SwiftUIViewProducts: View {
    let connectivity = Connectivity()
    @ObservedObject var networkMonitor = NetworkMonitor()
    let gradiant = Gradient(colors: [Color("Black"),Color("Center"),Color("Gold")])
    @ObservedObject var viewModelc = CardListViewModelPr()
    var body: some View {
       
        NavigationView {
                  VStack {
                      if networkMonitor.isConnected {
                          VStack{
                             
                              if viewModelc.cardList.isEmpty {
                                  ProgressView()
                                      .progressViewStyle(CircularProgressViewStyle())
                              } else {
                                  CardListViewPr(cardList: viewModelc.cardList).padding()
                              }
                          }
                      } else {
                          Disconected()
                      }
                     
                  }
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
                  .onAppear {
                      viewModelc.getCardListpr()
                  }
                  
                  .background(LinearGradient(gradient: gradiant, startPoint: .top, endPoint: .bottom))
                  .ignoresSafeArea(.all)
                  
              }
        
        
        
        
                   
               }
           
                 

}

struct SwiftUIViewProducts_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIViewProducts()
    }
}

class CardListViewModelPr: ObservableObject {
    @Published var cardList: [Card] = []
    
    func getCardListpr() {
         if let url = URL(string: "http://104.225.216.185:9300/products") {
             URLSession.shared.dataTask(with: url) { data, response, error in
                 if let error = error {
                     print("Error: \(error.localizedDescription)")
                     return
                 }
                 guard let httpResponse = response as? HTTPURLResponse,
                       (200...299).contains(httpResponse.statusCode) else {
                     print("Invalid response")
                     return
                 }
                 guard let data = data else {
                     print("No data received")
                     return
                 }
                 do {
                     let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    //print(jsonObject)
                     guard let jsonArray = jsonObject as? [[String: Any]] else {
                         print("Invalid JSON format")
                         return
                     }
                   
                     let cards = parseCardspr(jsonArray: jsonArray)
                     DispatchQueue.main.async {
                         self.cardList = cards
                     }
                 } catch {
                     print("Error decoding JSON: \(error.localizedDescription)")
                 }
             }.resume()
         }
     }
 }

func parseCardspr(jsonArray: [[String: Any]]) -> [Card] {
    var idpro = 0
       var nom = ""
       var description = ""
       var picture = ""
       var prix = 0.0
    
    var cards = [Card]()
    for json in jsonArray {
        idpro = json["idpro"] as? Int ?? 0
        nom = json["nom"] as? String ?? ""
        description = json["description"] as? String ?? ""
        picture = json["picture"] as? String ?? ""
        prix = json["prix"] as? Double ?? 0.0
        
               print("idpro: \(idpro)")
               print("nom: \(nom)")
               print("description: \(description)")
             //  print("picture: \(picture)")
               print("prix: \(prix)")
        
        if idpro != 0 {
            let card = Card(id: idpro, nom: nom, description: description, picture: picture, prix: prix)
            cards.append(card)
            
        } else {
            print("Failed to parse card: \(json)")
        }
    }
    return cards
}




struct CardListViewPr: View {
    let cardList: [Card]
    @State private var selectedCard: Card?
    
    var body: some View {
        ScrollView {
            ForEach(cardList, id: \.id) { card in
                Button(action: {
                    selectedCard = card
                }) {
                    VStack(alignment: .center, spacing: 5) {
                        // Display the image or a placeholder
                        HStack{
                            Spacer()
                        Image(uiImage: card.image ?? UIImage(systemName: "photo")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .background(Color.clear)
                            Spacer()
                        }
                        // Display the card name and price
                        Text(card.nom)
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                        
                        Text(String(format: "%.2f", card.prix))
                            .font(.system(size: 20))
                            .foregroundColor(.green)
                    }
                    .padding(.top, 2)
                    .background(Color.clear)
                    .overlay(Divider(), alignment: .bottom)
                }
                .buttonStyle(PlainButtonStyle())
                .fullScreenCover(item: $selectedCard) { card in
                    CardDetailViewo_Product(carp: card)
                }
            }
            // Add an empty image to create some space at the bottom of the ScrollView
            Image("").frame(height: 150)
        }.frame(width: UIScreen.main.bounds.width)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



extension Card {
    var image: UIImage? {
        guard let imageData = Data(base64Encoded: picture) else { return nil }
        return UIImage(data: imageData)
    }
}



