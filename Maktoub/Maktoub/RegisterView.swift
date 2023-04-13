//
//  RegisterView.swift
//  Maktoub
//
//  Created by user236595 on 3/24/23.
//

import SwiftUI


struct RegisterView: View {
 

    let gradiant = Gradient(colors: [Color("Black"),Color("Center"),Color("Gold")])
    @State public var username: String = ""
    @State  public var Firstname: String = ""
    @State  public var lastname: String = ""
    @State  public var password: String = ""
    @State  public var email: String = ""
    @State  public var Phone = ""
    @State  public var Adresse: String = ""
    
    
    @State  private var checkuser: Bool = false
    var body: some View {
        NavigationStack {
            VStack{
            Spacer()
            VStack (){
                Image("logo") // Replace "logo" with the name of your logo image asset
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.bottom,50)
                
                
                TextField("Username", text: $username)
                    .frame(height: 50)                   .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal,20)
                    
                
                
                TextField("First Name", text:$Firstname)
                    .frame(height: 50)                   .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal,20)
                    
                
                
                TextField("Last Name", text:$lastname)
                    .frame(height: 50)                   .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal,20)
                    
                TextField("Email", text:$email)
                    .frame(height: 50)                   .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal,20)
                
                TextField("Phone", value: $Phone,formatter:NumberFormatter())
                    .keyboardType(.decimalPad)
                    .frame(height: 50)                   .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal,20)
                
                TextField("Adresse", text:$Adresse)
                    .frame(height: 50)                   .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal,20)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal,20)
                    .frame(height: 50)
                
                
                HStack{
                    TwoButtonView(username: $username, Firstname: $Firstname, lastname: $lastname, password: $password, email: $email, Phone: $Phone, Adresse: $Adresse)
                        .padding(.top,30)
                }
                
            }
            Spacer()
        
        }.background(LinearGradient(gradient: gradiant, startPoint: .top,
                                    endPoint: .bottom))
            
        }
   .edgesIgnoringSafeArea(.all)
   .navigationBarBackButtonHidden(true)
        
        
        
    }
}
    struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

struct TwoButtonView: View {
    @Binding public var username: String
    @Binding  public var Firstname: String
    @Binding  public var lastname: String
    @Binding  public var password: String
    @Binding  public var email: String
    @Binding  public var Phone: String
    @Binding  public var Adresse: String
    
    @State  private var isRegistred: Bool = false
    
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        let per = Person(nom: Firstname, prenom: lastname, mail: email, password: password, tel: Phone, username: username,adresse: Adresse)
        
        HStack {
    
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Back")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .padding(.horizontal)
            })

                
           
                        Button(action: {
                            guard let url = URL(string: "http://104.225.216.185:9300/persons/signup")
                            else {
                                return
                            }
                            
                            var request = URLRequest(url: url)
                            request.httpMethod = "POST"
                            
                            
                            do {
                                let jsonBody = try JSONEncoder().encode(per)
                                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                request.httpBody = jsonBody
                            } catch {
                                print("Error encoding post: \(error)")
                                return
                            }
                            
                            URLSession.shared.dataTask(with: request) { data, response, error in
                                if let error = error {
                                    print("Error posting data: \(error)")
                                    return
                                }
                                
                                guard let httpResponse = response as? HTTPURLResponse,
                                      (200...299).contains(httpResponse.statusCode) else {
                                    print("Error with the response, unexpected status code: \(String(describing: response))")
                                    return
                                }
                                
                                if httpResponse.statusCode == 200 {
                                    isRegistred = true
                                }
                            }.resume()
                        }) {
                            Text("Submit")
                                   .font(.headline)
                                   .foregroundColor(.white)
                                   .padding()
                                   .background(Color.black)
                                   .padding(.horizontal)
                            
                        }.sheet(isPresented: $isRegistred)
                          {
                             LoginView()
                        }
            
        }
        
        }
    
}
