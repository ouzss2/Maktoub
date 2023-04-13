//
//  SwiftUIViewConfirmView.swift
//  Maktoub
//
//  Created by user236595 on 4/4/23.
//

import SwiftUI





struct SwiftUIViewConfirmView: View {
    
    @State var cards: [CardC] = []
    @State var per: Person

    let gradiant = Gradient(colors: [Color("Black"),Color("Center"),Color("Gold")])
    

    
    
    var body: some View {
        
        
        GeometryReader { geometry in
            VStack {
                Spacer()
                CardViewConS(cardList: cards)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: gradiant, startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea(.all)
            .navigationBarBackButtonHidden(true)
          
        }
        Spacer()
    }
    
    struct SwiftUIViewConfirmView_Previews: PreviewProvider {
        
        static var previews: some View {
            let rr = Person(nom: "", prenom: "", mail: "", password: "", tel: "", username: "", adresse: "")
            SwiftUIViewConfirmView(per: rr)
        }}
    struct CardViewConS: View {
        var cardList: [CardC]
  
    
        @StateObject var cartManager = CartManager()
        @State  public var isCommand: Bool = false
        let emailuerd:String = UserDefaults.standard.string(forKey: "mail") ?? ""
    
        
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
                      

                        let productList = cartManager.cards.map { ["idpro": "\($0.idpro)", "qte": "\($0.qte)"] }
                                let url = URL(string: "http://104.225.216.185:9300/productsdone/addProductDoneToUser")!
                                let params = [
                                    "person": [
                                        "mail": emailuerd
                                    ],
                                    "code": "55555",
                                    "list": productList
                                ] as [String : Any]

                                // Create the request object with the JSON-encoded parameters
                                var request = URLRequest(url: url)
                                request.httpMethod = "POST"
                                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                request.httpBody = try? JSONSerialization.data(withJSONObject: params)

                                // Send the request
                                URLSession.shared.dataTask(with: request) { data, response, error in
                                    if let error = error {
                                           print("Error: \(error.localizedDescription)")
                                           // Handle error as needed
                                           return
                                       }

                                       guard let httpResponse = response as? HTTPURLResponse else {
                                           print("Invalid response")
                                           // Handle invalid response as needed
                                           return
                                       }

                                       switch httpResponse.statusCode {
                                       case 200...299:
                                           // Successful response
                                           isCommand = true
                                          
                                           
                                           /*cartManager.setPerson(per: per)*/
                                           print("Response status code: \(httpResponse.statusCode)")
                                           // Handle successful response as needed
                                       case 400:
                                           // Bad request
                                           print("Response status code: \(httpResponse.statusCode)")
                                           // Handle bad request as needed
                                       case 401:
                                           // Unauthorized
                                           print("Response status code: \(httpResponse.statusCode)")
                                           // Handle unauthorized access as needed
                                       default:
                                           // Other error
                                           print("Response status code: \(httpResponse.statusCode)")
                                           // Handle other errors as needed
                                       }
                                    
                                    // Handle the response or error here
                                }.resume()
                        isCommand = true
                        
                    }) {
                        Text("CONFIRM COMMANANDE")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                            .background(.black)
                            .foregroundColor(.white)
                    }.padding(.all,20)
                        .sheet(isPresented: $isCommand){
                            let rr = Person(nom: "", prenom: "", mail: "", password: "", tel: "", username: "", adresse: "")
                            SwiftUIViewFinalView(per:rr)
                        }
                   
                }
                
            }
            Spacer()
        }
        
    }
    
    
   

    
}
