//
//  ConfirmView.swift
//  Maktoub
//
//  Created by user236595 on 3/29/23.
//

import SwiftUI

struct ConfirmView: View {
    
    @State var cards: [CardC] = []
    @State var person: Person

    let gradiant = Gradient(colors: [Color("Black"),Color("Center"),Color("Gold")])
    

    
    
    var body: some View {
        
        
        GeometryReader { geometry in
            VStack {
                Spacer()
                CardViewCon(cardList: cards, persontosend: person)
                
                
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: gradiant, startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea(.all)
            .navigationBarBackButtonHidden(true)
        }
       
    }
    
    struct ConfirmView_Previews: PreviewProvider {
        
        static var previews: some View {
            let rr = Person(nom: "", prenom: "", mail: "", password: "", tel: "", username: "", adresse: "")
            ConfirmView(person: rr)
        }}
    struct CardViewCon: View {
        var cardList: [CardC]
        @State public var username: String = ""
        @State  public var Firstname: String = ""
        @State  public var lastname: String = ""
        @State  public var password: String = ""
        @State  public var email: String = ""
        @State  public var Phone = ""
        @State  public var Adresse: String = ""
        @State  public var persontosend : Person
        @StateObject var cartManager = CartManager()
        @State  public var isCommand: Bool = false
       
        func sendPersonToServer(_ person: Person, completion: @escaping (Bool) -> Void) {

            
            // Create the request URL
            let url = URL(string: "http://104.225.216.185:9300/persons/new")!

            // Create the request object
            var request = URLRequest(url: url)
            do {
                let jsonBody = try JSONEncoder().encode(person)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonBody
            } catch {
                print("Error encoding post: \(error)")
                return
            }

            // Create a URLSession object
            let session = URLSession.shared

            // Send the request
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    completion(false)
                } else if let httpResponse = response as? HTTPURLResponse {
                    print("Response status code: \(httpResponse.statusCode)")
                    if httpResponse.statusCode == 202 { // 201 = Created
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }

            // Start the request
            task.resume()
        }
        
        var body: some View {
            VStack{
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
                TextField("First Name", text:$Firstname)
                    .frame(height: 50)                   .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal,20)
                
                
                TextField("Last Name", text:$lastname)
                    .frame(height: 50)                   .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal,20)
                
                TextField("Email", text:$email)
                    .keyboardType(.emailAddress)
                    .frame(height: 50)                   .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal,20)
                
                TextField("Phone", text: $Phone)                    .keyboardType(.numberPad)
                    .frame(height: 50)                  .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal,20)
                
                TextField("Adresse", text:$Adresse)
                    .frame(height: 50)                   .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal,20)
                
               
                
                
                HStack{
                    Button(action: {
                        let per = Person(nom: Firstname, prenom: lastname, mail: email, password: "", tel: Phone, username: "",adresse: Adresse)

                        let productList = cartManager.cards.map { ["idpro": "\($0.idpro)", "qte": "\($0.qte)"] }

                        
                        sendPersonToServer(per) { success in
                            if success {
                                print("Person was added successfully")
                                let url = URL(string: "http://104.225.216.185:9300/productsdone/addProductDoneToUser")!
                                let params = [
                                    "person": [
                                        "mail": per.mail
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
                                           persontosend = per
                                           
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
                                
                                
                                
                                
                            } else {
                                print("Failed to add person")
                            }
                        }

                        
                        
                    }) {
                        Text("CONFIRM COMMANANDE")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                            .background(.black)
                            .foregroundColor(.white)
                    }.padding(.all,20)
                        .sheet(isPresented: $isCommand){
                            FinalStepView(perso:persontosend)
                        }
                   
                }
                Spacer()
                
            }
        }
            
        }
        
    }
    
    
   

    
}
