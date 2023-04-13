//
//  SwiftUIViewResetPassword.swift
//  Maktoub
//
//  Created by user236595 on 4/11/23.
//

import SwiftUI

struct SwiftUIViewResetPassword: View {
    let gradiant = Gradient(colors: [Color("Black"),Color("Center"),Color("Gold")])
    
    
    var body: some View {
        VStack{
            Spacer()
            BuildViewreset()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(LinearGradient(gradient: gradiant, startPoint: .top, endPoint: .bottom))
    }
}

struct SwiftUIViewResetPassword_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIViewResetPassword()
    }
}

struct BuildViewreset: View {
    @State private var oldp = ""
    @State private var newp = ""
    @State private var error = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var isUpdated = false
    @State var emailsent:String = UserDefaults.standard.string(forKey: "mail") ?? ""

    var body: some View {
        Image("logo")
            .resizable()
            .frame(width: 100, height: 100)
            .padding(.bottom,50)
        //the form
        VStack{
           
            
            
            
            SecureField("Old Password", text: $oldp)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal,20)
                .frame(height: 50)
            SecureField("New Password", text: $newp)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal,20)
                .frame(height: 50)
            
            Text(error)
                .foregroundColor(.red)
                .font(.system(size: 25)).padding(.bottom,15)
            
            
        }
        Divider()
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
                            if  oldp.isEmpty || newp.isEmpty {
                                error = "Empty Fields"
                            }else if oldp.isEmpty != newp.isEmpty {
                                error = "Password Does not Match"
                            }else{
                                guard let url = URL(string: "http://104.225.216.185:9300/persons/updatePassword")
                                else {
                                    return
                                }
                                
                                var request = URLRequest(url: url)
                                request.httpMethod = "POST"
                               
                                
                                do {
                                    let jsonBody = try JSONEncoder().encode(UpdatePass(email: emailsent, oldPass: oldp, newPass: newp))
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
                                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                                UserDefaults.standard.set("", forKey: "mail")
                                UserDefaults.standard.set("", forKey: "nom")
                                UserDefaults.standard.set("", forKey: "prenom")
                                UserDefaults.standard.set("", forKey: "tel")
                                isUpdated = true
                                    }
                                }.resume()
                                
                              
                            }
                        }) {
                            Text("Submit")
                                   .font(.headline)
                                   .foregroundColor(.white)
                                   .padding()
                                   .background(Color.black)
                                   .padding(.horizontal)
                            
                        } .fullScreenCover(isPresented: $isUpdated, content: {
                            LoginView()
                                .navigationBarHidden(true)
                                .onDisappear {
                                    presentationMode.wrappedValue.dismiss()
                                }
                        
                    })
          
            
        }
        
    }
}
func updatePassword(email: String, oldPass: String, newPass: String, completion: @escaping (Bool) -> Void) {
    let endpoint = "http://104.225.216.185:9300/persons/updatePassword"
    let payload: [String: Any] = ["email": email, "oldPass": oldPass, "newPass": newPass]
  
    guard let url = URL(string: endpoint) else {
        completion(false)
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    do {
        let jsonData = try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
        request.httpBody = jsonData
        print(jsonData)
    } catch {
        completion(false)
        return
    }

    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            completion(false)
            return
        }

        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
            if let status = json?["status"] as? String, status == "success" {
                completion(true)
            } else {
                completion(false)
            }
        } catch {
            completion(false)
        }
    }

    task.resume()
}
