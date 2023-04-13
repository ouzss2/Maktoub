//
//  SwiftUIViewEditProfile.swift
//  Maktoub
//
//  Created by user236595 on 4/3/23.
//

import SwiftUI

struct SwiftUIViewEditProfile: View {
    
    let gradiant = Gradient(colors: [Color("Black"),Color("Center"),Color("Gold")])
    @State var usertoup: Persondetails?
    @State public var username: String = ""
    @State  public var Firstname: String = ""
    @State  public var lastname: String = ""
    @State  public var password: String = ""
    @State  public var email: String = ""
    @State  public var Phone = ""
    @State  public var Adresse: String = ""
    @State  public var idper: Int = 0
    @State  public var photo: String = ""
    @State  public var couv: String = ""
    @State  public var fonct: String = ""
    @State  public var about: String = ""
    @State  public var roles: [String] = []
    
    @State var islink:Bool = false
    @State var ispass:Bool = false
    @Environment(\.presentationMode) var presentationMode
    func getUserByEmailtoupdate(email: String, completion: @escaping (Persondetails?) -> Void) {
        var components = URLComponents(string: "http://104.225.216.185:9300/persons/getUser")!
        components.queryItems = [URLQueryItem(name: "email", value: email)]
        
        guard let url = components.url else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let person = try decoder.decode(Persondetails.self, from: data)
                
                completion(person)
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
    let emailupdate = UserDefaults.standard.string(forKey: "mail") ?? ""
    
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    Spacer()
                    VStack (){
                        Image("logo") // Replace "logo" with the name of your logo image asset
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding(.bottom,50)
                            .padding(.top,50)
                        
                        
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
                        
                        TextField("Phone", text: $Phone)
                            .frame(height: 50)                   .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal,20)
                        
                        TextField("Adresse", text:$Adresse)
                            .frame(height: 50)
                            .foregroundColor(.black)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal,20)
                        
                        TextField("Fonction", text:$fonct)
                            .frame(height: 50)
                            .foregroundColor(.black)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal,20)
   
                        
                        VStack{
                        HStack{
                           
                            Button(action: {
                                islink = true
                            }, label: {
                                Text("Other Links")
                                    .font(.headline)
                                    .foregroundColor(Color("Gold"))
                                    .padding()
                                    .background(Color.black)
                                    .padding(.horizontal)
                            })
                           
                            .fullScreenCover(isPresented: $islink, content: {
                                SwiftUIViewLinks()
                                    .navigationBarHidden(true)
                                    /*.onDisappear {
                                        presentationMode.wrappedValue.dismiss()
                                    }*/
                        })
                        }.padding(.top,20)
                        HStack{
                        Button(action: {
                            ispass = true
                        }, label: {
                            Text("Update password")
                                .font(.headline)
                                .foregroundColor(Color("Gold"))
                                .padding()
                                .background(Color.black)
                                .padding(.horizontal)
                        })
                       
                        .fullScreenCover(isPresented: $ispass, content: {
                            SwiftUIViewResetPassword()
                                .navigationBarHidden(true)
                                /*.onDisappear {
                                    presentationMode.wrappedValue.dismiss()
                                }*/
                        }) }
                    }
                        HStack{
                            TwoButtonViewUpdate(username: $username, Firstname: $Firstname, lastname: $lastname, password: $password, email: $email, Phone: $Phone, Adresse: $Adresse, idper: $idper, photo: $photo, couv: $couv, fonct: $fonct, roles: $roles, about: $about)
                                .padding(.top,30)
                                .padding(.bottom,30)
                        }.padding(.bottom,50)
                        
                    }
                    Spacer()
                    
                }
                
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                
                getUserByEmailtoupdate(email: emailupdate) { person in
                    self.usertoup = person
                    self.username = person?.username ?? ""
                    self.Firstname = person?.nom ?? ""
                    self.lastname = person?.prenom ?? ""
                    self.email = person?.mail ?? ""
                    self.Phone = person?.tel ?? ""
                    self.Adresse = person?.adresse ?? ""
                    self.idper = person?.idperson ?? 0
                    self.photo = person?.photo ?? ""
                    self.couv = person?.couverture ?? ""
                    self.roles = person?.roles as! [String]
                    self.fonct = person?.fonction ?? ""
                    self.password = person?.password ?? ""
                    self.about = person?.about ?? ""
                    
                }}.background(LinearGradient(gradient: gradiant, startPoint: .top,
                                             endPoint: .bottom))
            
        }
        
    }}



struct SwiftUIViewEditProfile_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIViewEditProfile()
    }
}
struct TwoButtonViewUpdate: View {
    @Binding public var username: String
    @Binding  public var Firstname: String
    @Binding  public var lastname: String
    @Binding  public var password: String
    @Binding  public var email: String
    @Binding  public var Phone: String
    @Binding  public var Adresse: String
    @Binding  public var idper: Int
    @Binding  public var photo: String
    @Binding  public var couv: String
    @Binding  public var fonct: String
    @Binding  public var roles: [String]
    @Binding  public var about: String
    @State  private var isRegistred: Bool = false
    
    @State private var isPresented = false

    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        let per = PersonUpdate(nom: Firstname, prenom: lastname, email: email, tel: Phone, adresse: Adresse, fonction: fonct, username: username)
        
        HStack {
    
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                //isPresented = true
            }, label: {
                Text("Back")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .padding(.horizontal)
            })
                
           
                        Button(action: {
                          
                            guard let baseURL = URL(string: "http://104.225.216.185:9300") else {
                                return
                            }

                            let endpoint = "/persons/upuserr"

                            let queryParameters = [
                                "email": per.email,
                                "username": per.username,
                                "nom": per.nom,
                                "prenom": per.prenom,
                                "adresse": per.adresse,
                                "fonction": per.fonction,
                                "tel": per.tel
                            ]

                            var urlComponents = URLComponents(url: baseURL.appendingPathComponent(endpoint), resolvingAgainstBaseURL: true)

                            let queryItems = queryParameters.map {
                                URLQueryItem(name: $0.key, value: $0.value)
                            }

                            urlComponents?.queryItems = queryItems

                            guard let url = urlComponents?.url else {
                                return
                            }

                            var request = URLRequest(url: url)
                            request.httpMethod = "PUT"

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
                            
                        } .fullScreenCover(isPresented: $isRegistred, content: {
                            MainView()
                                .navigationBarHidden(true)
                                .onDisappear {
                                    presentationMode.wrappedValue.dismiss()
                                }
                        
                    })
          
            
        }
        
        }
    
}
