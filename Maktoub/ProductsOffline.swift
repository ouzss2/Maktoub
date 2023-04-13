//
//  ProductsOffline.swift
//  Maktoub
//
//  Created by user236595 on 3/26/23.
//
import SwiftUI
import Connectivity

struct ProductsOffline: View {
    let connectivity = Connectivity()
    @ObservedObject var networkMonitor = NetworkMonitor()
    let gradiant = Gradient(colors: [Color("Black"),Color("Center"),Color("Gold")])
    var body: some View {
        
    
        
            
        
        GeometryReader { geometry in
                   VStack {
                       Spacer()
                       
                       if networkMonitor.isConnected {
                           Connected()
                             } else {
                                 Disconected()
                             }
                       
                       Spacer()
                   }
                   .frame(maxWidth: .infinity, maxHeight: .infinity)
                   .background(LinearGradient(gradient: gradiant, startPoint: .top, endPoint: .bottom))
                   .ignoresSafeArea(.all)
                   .navigationBarBackButtonHidden(true)
               }
           }
                 

}

struct ProductsOffline_Previews: PreviewProvider {
    static var previews: some View {
        ProductsOffline()
    }
}




struct Disconected: View {
    let connectivity = Connectivity()
    
    var body: some View {
        VStack {
            Image(systemName: "wifi.slash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.red)
                .frame(width: 100, height: 100)
            Text("No internet connection")
        }
        .onAppear {
            connectivity.checkConnectivity { status in
                print("Connectivity status: \(status)")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}



class CardListViewModel: ObservableObject {
    @Published var cardList: [Card] = []
    
    func getCardList() {
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
                    
                     guard let jsonArray = jsonObject as? [[String: Any]] else {
                         print("Invalid JSON format")
                         return
                     }
                   
                     let cards = parseCards(jsonArray: jsonArray)
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

func parseCards(jsonArray: [[String: Any]]) -> [Card] {
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
        
           
        
        if idpro != 0 {
            let card = Card(id: idpro, nom: nom, description: description, picture: picture, prix: prix)
            cards.append(card)
            
        } else {
            print("Failed to parse card: \(json)")
        }
    }
    return cards
}





struct Connected: View {
    @ObservedObject var viewModel = CardListViewModel()
    @State private var inPressedbtn: Bool = false
    @State private var inPressedbtnr: Bool = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
           VStack {
               if viewModel.cardList.isEmpty {
                   ProgressView()
                       .progressViewStyle(CircularProgressViewStyle())
               } else {
                   CardListView(cardList: viewModel.cardList)
               }
               
               HStack {
                   Button(action: {
                       // Action for first button
                       inPressedbtnr = true
                   }) {
                       Text("SIGNUP")
                           .padding()
                           .frame(maxWidth: .infinity)
                           .cornerRadius(10)
                           .background(.black)
                           .foregroundColor(.white)
                   }
                   .padding()
                   .sheet(isPresented: $inPressedbtnr){
                       RegisterView()
                   }
                   Button(action: {
                       // Action for second button
                       inPressedbtn = true
                       presentationMode.wrappedValue.dismiss()
                   }) {
                       Text("SIGNIN")
                           .padding()
                           .frame(maxWidth: .infinity)
                           .cornerRadius(10)
                           .background(.black)
                           .foregroundColor(.white)
                   }.padding()
            
               }
               .padding()
           }
           .background(.clear)
           .onAppear {
               viewModel.getCardList()
           }

       }
            



}
struct CardListView: View {
    var cardList: [Card]
    
    var body: some View {
        ScrollView{
            ForEach(cardList, id: \.id) { card in
                NavigationLink(destination: CardDetailView(card: card)) {
                    VStack() {
                        HStack() {
                            Spacer()
                            if let imageData = Data(base64Encoded: card.picture),
                               let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 200, height: 200)
                                    .background(.clear)
                                
                            } else {
                                Image(systemName: "logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 200, height: 200)
                            }
                            Spacer()
                        }.background(.clear)
                        VStack(alignment: .center, spacing: 5) {
                            Text(card.nom)
                                .foregroundColor(.white)
                                .font(.system(size: 25))
                               
                            
                            
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
