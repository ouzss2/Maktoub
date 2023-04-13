//
//  LoginView.swift
//  Maktoub
//
//  Created by user236595 on 3/24/23.
//

import SwiftUI




struct LoginView: View {
    
    var body: some View{
        
        NavigationView {
                  ContentV()
                      .navigationBarBackButtonHidden(true)
                      .navigationViewStyle(StackNavigationViewStyle())
              }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct ContentV: View {
    
    let gradiant = Gradient(colors: [Color("Black"),Color("Center"),Color("Gold")])
    @State private var email: String = ""
    @State  private var password: String = ""
    @State  private var errormessage: String = ""
    
    @State  private var showRegister: Bool = false
    @State  private var isLoged: Bool = false
    @State private var showAlert = false
    @State  private var showProgressBar: Bool = false
    @State private var isLoggingIn = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isActive = false
    @State private var showRegisterView:Bool = false
    @State private var showProductView:Bool = false

    let decoder = JSONDecoder()
    
   
    func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        var components = URLComponents(string: "http://104.225.216.185:9300/persons/signin")!
        components.queryItems = [
            URLQueryItem(name: "email", value: email),
            URLQueryItem(name: "password", value: password),
        ]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                // Hide progress bar
                showProgressBar = false
            }

            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                print("Error: \(error!)")
                completion(false)
                return
            }

            print("Status code: \(httpResponse.statusCode)")

            if (200...299).contains(httpResponse.statusCode) {
                completion(true)
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.set(email, forKey: "mail")
            } else {
                print("Invalid response status code: \(httpResponse.statusCode)")
                completion(false)
            }
        }

        task.resume()
    }



    
    @ViewBuilder
    var body: some View {
        //  Text("Hello World").foregroundColor(.red)
        if UIDevice.current.userInterfaceIdiom == .phone {
            // create phone layout
            NavigationStack {
                VStack{
                    Spacer()
                    VStack (){
                        Image("logo") // Replace "logo" with the name of your logo image asset
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding(.bottom,50)
                        
                        
                        TextField("Email", text: $email)
                            .frame(height: 50)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal,20)
                        
                        
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal,20)
                            .frame(height: 50)
                        
                        Text(errormessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                        
                        VStack {
                            
                            
                            Button(action: {
                                if email.isEmpty && password.isEmpty {
                                    errormessage = "Empty Mail and Password"
                                } else if email.isEmpty && !password.isEmpty {
                                    errormessage = "Empty Mail "
                                } else if !email.isEmpty && password.isEmpty {
                                    errormessage = "Empty Password"
                                } else {
                                    errormessage = ""
                                    showProgressBar = true
                                    loginUser(email: email, password: password) { success in
                                        print(success)
                                        if success {
                                            print(success)
                                            isLoggingIn = true
                                            //showAlert = true // Set flag to show MainView
                                        } else {
                                            showProgressBar = false
                                            showAlert = true
                                        }
                                    }
                                }
                            }) {
                                if showProgressBar {
                                    
                                    ProgressView()
                                        .scaleEffect(2)
                                        .foregroundColor(.green)
                                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                                        .padding(.bottom,20)
                                    
                                } else {
                                    Text("Log In")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.black)
                                        .padding(.horizontal)
                                }
                            }
                            .fullScreenCover(isPresented: $isLoggingIn, content: {
                                MainView()
                            })
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Login Failed"),
                                    message: Text("Invalid email or password. Please try again."),
                                    dismissButton: .default(Text("OK"))
                                )
                                
                            }
                            
                        }
                        .padding(.top,20)
                        
                        NavigationLink(
                            destination: RegisterView(),
                            label: {
                                Text("Register")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.black)
                                    .padding(.horizontal)
                            }
                            
                        )
                        /* Button(action: {
                         // Add your button action here
                         
                         
                         
                         }) {
                         Text("Change Languages")
                         .font(.headline)
                         .foregroundColor(.white)
                         .padding()
                         .background(Color.black)
                         .padding(.horizontal)
                         }*/
                        
                    }
                    NavigationLink(
                        destination: ProductsOffline(),
                        label: {
                            Text("Products")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black)
                                .padding(.horizontal)
                        }
                        
                    )
                    Button(action: {
                        // Add your button action here
                    }){
                        Text("Lost Your Password")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top,45)
                        
                    }
                    
                    Spacer()
                }   .background(LinearGradient(gradient: gradiant, startPoint: .top, endPoint: .bottom))
                    .ignoresSafeArea(.all)
                
                
            }.onAppear {
                // Lock the orientation to portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }
        } else {
            NavigationView {
                 List {
                     NavigationLink(destination: ProductsOffline()) {
                         Text("Products")
                     }
                     NavigationLink(destination: RegisterView()) {
                         Text("Register")
                     }
                     Button(action: {
                         // Add your button action here
                     }) {
                         Text("Lost Your Password")
                     }
                 }
                 .navigationTitle("My App")
                 .listStyle(SidebarListStyle())
             }
             .onAppear {
                 // Lock the orientation to portrait
                 UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
             }
            
            
            // create iPad layout
          //  Text("Hello World")
            /*eometryReader { geo in
                Text("Hello World")
                  
                
                
            }.onAppear {
                // Lock the orientation to portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }*/
        }
     
        
    } }
 
/*
 VStack {
     Spacer()
         VStack {
             Image("logo") // Replace "logo" with the name of your logo image asset
                 .resizable()
                 .frame(width: 200, height: 200)
                 .padding(.bottom,50)
             
            

             TextField("Email", text: $email)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                 .padding(.horizontal,20)
                 
                 .fixedSize(horizontal: false, vertical: false)
                 
             
            
             SecureField("Password", text: $password)
                 .textFieldStyle(RoundedBorderTextFieldStyle())
                 .padding(.horizontal,20)
                 .frame(height: 50)
             
                 Text(errormessage)
                 .font(.footnote)
                 .foregroundColor(.red)
            
             VStack {
                 Button(action: {
                     if email.isEmpty && password.isEmpty {
                         errormessage = "Empty Mail and Password"
                     } else if email.isEmpty && !password.isEmpty {
                         errormessage = "Empty Mail "
                     } else if !email.isEmpty && password.isEmpty {
                         errormessage = "Empty Password"
                     } else {
                         errormessage = ""
                         showProgressBar = true
                         loginUser(email: email, password: password) { success in
                             print(success)
                             if success {
                               print(success)
                                   isLoggingIn = true
                                 //showAlert = true // Set flag to show MainView
                             } else {
                                 showProgressBar = false
                                 showAlert = true
                             }
                         }
                     }
                 }) {
                     if showProgressBar {
                                
                         ProgressView()
                             .scaleEffect(2)
                             .foregroundColor(.green)
                             .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                             .padding(.bottom,20)

                            } else {
                                Text("Log In")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.black)
                                    .padding(.horizontal)
                            }
                 }
                 .fullScreenCover(isPresented: $isLoggingIn, content: {
                     MainView()
                 })
                 .alert(isPresented: $showAlert) {
                     Alert(
                         title: Text("Login Failed"),
                         message: Text("Invalid email or password. Please try again."),
                         dismissButton: .default(Text("OK"))
                     )
                     
                 }
                 
             }
             .padding(.top,20)
         
             Button(action: {
                 // navigate to RegisterView
                 showRegisterView = true
             }) {
                 Text("Register")
                     .font(.headline)
                     .foregroundColor(.white)
                     .padding()
                     .background(Color.black)
                     .padding(.horizontal)
             }
             .fullScreenCover(isPresented: $showRegisterView) {
                 RegisterView()
             }

            /* Button(action: {
                 // Add your button action here
                 
                    
                 
             }) {
                 Text("Change Languages")
                     .font(.headline)
                     .foregroundColor(.white)
                     .padding()
                     .background(Color.black)
                     .padding(.horizontal)
             }*/
            
         }
     Button(action: {
         // navigate to RegisterView
         showProductView = true
     }) {
         Text("Register")
             .font(.headline)
             .foregroundColor(.white)
             .padding()
             .background(Color.black)
             .padding(.horizontal)
     }
     .fullScreenCover(isPresented: $showProductView) {
         ProductsOffline()
     }
         Button(action: {
             // Add your button action here
         }){
             Text("Lost Your Password")
                 .font(.headline)
                 .foregroundColor(.white)
                 .padding(.top,45)
                 
         }
     
         Spacer()
         }
 }  .background(LinearGradient(gradient: gradiant, startPoint: .top, endPoint: .bottom))
         .ignoresSafeArea(.all)
 
 */
