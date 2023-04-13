//
//  SwiftUIViewProfile.swift
//  Maktoub
//
//  Created by user236595 on 4/2/23.
//

import SwiftUI
import UIKit
import PhotosUI
import Contacts
import ContactsUI


struct SwiftUIViewProfile: View {
    let gradiant = Gradient(colors: [Color("Black"),Color("Center"),Color("Gold")])
    @State var emailsent:String = UserDefaults.standard.string(forKey: "mail") ?? ""
    @State var nmbr:Int = 0
    
    @State var profileImage: UIImage?
    @State var user: Persondetails?
    @State var isedit:Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var image: UIImage?
    @State private var isShowingImagePicker = false
    @State private var showChangeImageAlert = false
    @State private var showingPopup = false
    let manage = LinkManager()
    func loadImage() {
        guard let inputImage = image else { return }
        let compressedImage = inputImage.jpegData(compressionQuality: 0.5)
        guard let compressedUIImage = UIImage(data: compressedImage!) else { return }
        image = compressedUIImage
    }
    @State private var refreshFlag = false
    
    @State private var name:String = (UserDefaults.standard.string(forKey: "nom") ?? "")
    @State private var tel:String =  (UserDefaults.standard.string(forKey: "tel") ?? "")
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ViewBuilder
    var body: some View {
        if horizontalSizeClass == .compact {
        GeometryReader { geometry in
            NavigationView{
                ScrollView {
                    ZStack(alignment: .bottom) {
                        // Background cover
                        if let imageData = Data(base64Encoded: user?.couverture ?? ""),
                           let image = UIImage(data: imageData) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: geometry.size.width)
                                .frame(height: 200)
                                .padding(.top,-20)
                                .onTapGesture {
                                    showChangeImageAlert = true
                                    nmbr = 2
                                }
                            
                        } else {
                            Image("back")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: geometry.size.width)
                                .frame(height: 200)
                                .padding(.top,-20)
                                .onTapGesture {
                                    showChangeImageAlert = true
                                    nmbr = 2
                                    
                                }
                        }
                        
                        
                        // User image and name
                        VStack {
                            if let imageData = Data(base64Encoded: user?.photo ?? ""),
                               let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                    .shadow(radius: 5)
                                    .onTapGesture {
                                        // isShowingImagePicker = true
                                        showChangeImageAlert = true
                                        nmbr = 1
                                        
                                    }
                            } else {
                                Image("perso")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                    .shadow(radius: 5)
                                    .onTapGesture {
                                        //isShowingImagePicker = true
                                        showChangeImageAlert = true
                                        nmbr = 1
                                        
                                    }
                                
                            }
                            
                            
                        }
                    } .alert(isPresented: $showChangeImageAlert) {
                        Alert(
                            title: Text("Change Image?"),
                            message: Text("Do you want to change the image?"),
                            primaryButton: .default(Text("Yes"), action: {
                                isShowingImagePicker = true
                                
                                
                            }),
                            secondaryButton: .cancel(Text("No"))
                        )
                    }
                    .padding(.bottom,70)
                    .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
                        
                        ImagePicker(image: $image,emailsentup: $emailsent,nbr: $nmbr,refresh: $refreshFlag)
                        
                    }
                    
                    HStack {
                        phoneButton()
                        Spacer()
                        VStack {
                            Button(action: {
                                // Add your button action here
                                let baseUrl = "http://104.225.216.185:9300/profile/"
                                let queryString = user?.mail ?? ""
                                let link = baseUrl + queryString
                                guard let url = URL(string: link) else {
                                    return
                                }
                                
                                let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                                
                                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                   let rootViewController = windowScene.windows.first?.rootViewController {
                                    // For iPad, we need to set the presentation style of the share sheet
                                    activityViewController.popoverPresentationController?.sourceView = rootViewController.view
                                    activityViewController.popoverPresentationController?.sourceRect = CGRect(x: rootViewController.view.bounds.midX, y: rootViewController.view.bounds.midY, width: 0, height: 0)
                                    
                                    rootViewController.present(activityViewController, animated: true, completion: nil)
                                }
                                else {
                                    // For iPhone, we can present the share sheet directly
                                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                       let rootViewController = windowScene.windows.first?.rootViewController {
                                        rootViewController.present(activityViewController, animated: true, completion: nil)
                                    }
                                    
                                }
                                
                            }) {
                                Text("Share Link")
                                    .font(.system(size: 20))
                                    .foregroundColor(.yellow)
                                    .padding(.all,1)
                                    .background(Color.black)
                            }
                        }
                        
                        
                      

                    }.padding(.horizontal,50)
                    
                    
                    
                    VStack{
                        Text(user?.nom ?? "")
                            .font(.system(size:28).bold())
                            .foregroundColor(.white)
                            .padding(.top,5)
                        HStack {
                            Image(systemName: "briefcase.fill")
                                .foregroundColor(.gray)
                                .padding(.leading,5)
                            Text(user?.fonction ?? "Mobile and web Developer")
                                .font(.system(size:22).bold())
                                .foregroundColor(.white)
                        }.padding(.top,10)
                    }.frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
                    VStack{
                        
                        GridView(lst: manage.links).padding(.top,20)
                        LazyVStack {
                            Spacer()
                            VStack {
                                
                                Button(action: {
                                    isedit = true
                                }) {
                                    Text("Edit Profile")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.black)
                                }
                                .fullScreenCover(isPresented: $isedit, content: {
                                    SwiftUIViewEditProfile()
                                        .navigationBarHidden(true)
                                    
                                })
                                Image("")
                                    .frame(height: 150)
                            }
                            Spacer()
                        }.padding(.top,50)
                        
                    }.frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
                    
                }.background(LinearGradient(gradient: gradiant, startPoint: .top, endPoint: .bottom))
                    .onAppear {
                        getUserByEmail(email: emailsent) { person in
                            self.user = person
                            UserDefaults.standard.set(user?.nom, forKey: "nom")
                            UserDefaults.standard.set(user?.prenom, forKey: "prenom")
                            UserDefaults.standard.set(user?.tel, forKey: "tel")
                        }
                        
                        manage.clearLinks()
                        fetchLinkItems(email: emailsent) { linkItems in
                            var uniqueLinks = [FileLink]()
                            for item in linkItems {
                                if !uniqueLinks.contains(where: { $0.name == item.name && $0.url == item.url }) {
                                    uniqueLinks.append(FileLink(email: "", name: item.name, url: item.url))
                                }
                            }
                            // Add the unique links to `manage`
                            for link in uniqueLinks {
                                print(link.url)
                                manage.add(link: link)
                            }
                        }
                                         }
            } }
        }else {
            GeometryReader { geometry in
                VStack{
                    ScrollView {
                        VStack() {
                            // Background cover
                            if let imageData = Data(base64Encoded: user?.couverture ?? ""),
                               let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: geometry.size.width)
                                    .frame(height: 200)
                                    .padding(.top,-20)
                                    .onTapGesture {
                                        showChangeImageAlert = true
                                        nmbr = 2
                                    }
                                
                            } else {
                                Image("back")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: geometry.size.width)
                                    .frame(height: 200)
                                    
                                    .onTapGesture {
                                        showChangeImageAlert = true
                                        nmbr = 2
                                        
                                    }
                            }
                            
                            
                            // User image and name
                            VStack {
                                if let imageData = Data(base64Encoded: user?.photo ?? ""),
                                   let image = UIImage(data: imageData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                        .shadow(radius: 5)
                                        .onTapGesture {
                                            // isShowingImagePicker = true
                                            showChangeImageAlert = true
                                            nmbr = 1
                                            
                                        }
                                } else {
                                    Image("perso")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                        .shadow(radius: 5)
                                        .onTapGesture {
                                            //isShowingImagePicker = true
                                            showChangeImageAlert = true
                                            nmbr = 1
                                            
                                        }
                                    
                                }
                                
                                
                            }
                        } .alert(isPresented: $showChangeImageAlert) {
                            Alert(
                                title: Text("Change Image?"),
                                message: Text("Do you want to change the image?"),
                                primaryButton: .default(Text("Yes"), action: {
                                    isShowingImagePicker = true
                                    
                                    
                                }),
                                secondaryButton: .cancel(Text("No"))
                            )
                        }
                        .padding(.bottom,10)
                        .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
                            
                            ImagePicker(image: $image,emailsentup: $emailsent,nbr: $nmbr,refresh: $refreshFlag)
                            
                        }
                        
                        HStack {
                            phoneButton()
                            Spacer()
                            VStack
                            {
                                Button(action: {
                                    // Add your button action here
                                    let baseUrl = "http://104.225.216.185:9300/profile/"
                                    let queryString = user?.mail ?? ""
                                    let link = baseUrl + queryString
                                    guard let url = URL(string: link) else {
                                        return
                                    }
                                    
                                    let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                                    
                                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                       let rootViewController = windowScene.windows.first?.rootViewController {
                                        // For iPad, we need to set the presentation style of the share sheet
                                        activityViewController.popoverPresentationController?.sourceView = rootViewController.view
                                        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: rootViewController.view.bounds.midX, y: rootViewController.view.bounds.midY, width: 0, height: 0)
                                        
                                        rootViewController.present(activityViewController, animated: true, completion: nil)
                                    }
                                    else {
                                        // For iPhone, we can present the share sheet directly
                                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                           let rootViewController = windowScene.windows.first?.rootViewController {
                                            rootViewController.present(activityViewController, animated: true, completion: nil)
                                        }
                                        
                                    }
                                    
                                }) {
                                    Text("Share Link")
                                        .font(.system(size: 20))
                                        .foregroundColor(.yellow)
                                        .padding(.all,1)
                                        .background(Color.black)
                                }
                            }
                            
                            
                          

                        }.padding(.horizontal,50)
                            .padding(.top,150)
                        
                        
                        
                        VStack{
                            Text(user?.nom ?? "")
                                .font(.system(size:28).bold())
                                .foregroundColor(.white)
                                .padding(.top,5)
                            HStack {
                                Image(systemName: "briefcase.fill")
                                    .foregroundColor(.gray)
                                    .padding(.leading,5)
                                Text(user?.fonction ?? "Mobile and web Developer")
                                    .font(.system(size:22).bold())
                                    .foregroundColor(.white)
                            }.padding(.top,10)
                        }.frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
                        VStack{
                            
                            GridView(lst: manage.links).padding(.top,20)
                            LazyVStack {
                                Spacer()
                                VStack {
                                    
                                    Button(action: {
                                        isedit = true
                                    }) {
                                        Text("Edit Profile")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.black)
                                    }
                                    .fullScreenCover(isPresented: $isedit, content: {
                                        SwiftUIViewEditProfile()
                                            .navigationBarHidden(true)
                                        
                                    })
                                    Image("")
                                        .frame(height: 150)
                                }
                                Spacer()
                            }.padding(.top,50)
                            
                        }.frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
                        
                    }.background(LinearGradient(gradient: gradiant, startPoint: .top, endPoint: .bottom))
                        .onAppear {
                            getUserByEmail(email: emailsent) { person in
                                self.user = person
                                UserDefaults.standard.set(user?.nom, forKey: "nom")
                                UserDefaults.standard.set(user?.prenom, forKey: "prenom")
                                UserDefaults.standard.set(user?.tel, forKey: "tel")
                            }
                            
                            manage.clearLinks()
                            fetchLinkItems(email: emailsent) { linkItems in
                                var uniqueLinks = [FileLink]()
                                for item in linkItems {
                                    if !uniqueLinks.contains(where: { $0.name == item.name && $0.url == item.url }) {
                                        uniqueLinks.append(FileLink(email: "", name: item.name, url: item.url))
                                    }
                                }
                                // Add the unique links to `manage`
                                for link in uniqueLinks {
                                    print(link.url)
                                    manage.add(link: link)
                                }
                            }
                                             }
                } }
        }
    }
    
    private func phoneButton() -> some View {
        Button(action: {
            showingPopup = true
        }) {
            VStack {
                
                Image(systemName: "phone")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30,height: 30)
                    .cornerRadius(10)
                
            }
        }.alert(isPresented: $showingPopup) {
            Alert(title: Text("Add Contact"), message: Text("Do you want to save '\(name)' with telephone number '\(tel)'?"), primaryButton: .default(Text("OK"), action: {
                // Execute code to save the data here
                saveData()
            }), secondaryButton: .cancel())
        }
        
    }
    func saveData(){
        let contact = CNMutableContact()
        
        // Store the profile picture as data.
        let image = UIImage(systemName: "person.crop.circle")
        contact.imageData = image?.jpegData(compressionQuality: 1.0)
        
        contact.givenName = (UserDefaults.standard.string(forKey: "nom") ?? "")
        contact.familyName = (UserDefaults.standard.string(forKey: "prenom") ?? "")
        
        
        
        contact.phoneNumbers = [CNLabeledValue(
            label: CNLabelPhoneNumberiPhone,
            value: CNPhoneNumber(stringValue: UserDefaults.standard.string(forKey: "tel") ?? "(408) 555-0126"))]
        
        
        
        
        // Save the newly created contact.
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        
        do {
            try store.execute(saveRequest)
        } catch {
            print("Saving contact failed, error: \(error)")
            // Handle the error.
        } }
    
}

func fetchLinkItems(email: String, completion: @escaping ([Linkeditem]) -> Void) {
    let urlString = "http://104.225.216.185:9300/links"
    if let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
        let url = URL(string: "\(urlString)?email=\(encodedEmail)")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }
            do {
                let linkItems = try JSONDecoder().decode([Linkeditem].self, from: data)
                completion(linkItems)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion([])
            }
        }
        task.resume()
    }
}
struct SwiftUIViewProfile_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIViewProfile()
    }
}


struct ProfileHeader: View {
    @State private var selectedImage: UIImage?
        @State private var shouldShowImagePicker = false
        
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    VStack {
                   
                        
                        HStack {
                            Text("Eddie Brock")
                                .font(.system(size: 28).bold())
                                .foregroundColor(.white)
                                .padding(.top, 25)
                        }
                        
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .frame(width: 70, height: 70)
                            Text("Mobile and web Developer")
                                .font(.system(size: 22).bold())
                                .foregroundColor(.white)
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
            .background(
                Image(uiImage: selectedImage ?? UIImage(named: "back")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
        }.ignoresSafeArea(.all)
            .navigationViewStyle(StackNavigationViewStyle())
           
        }
    }
  
func convertToUIImage(from bytes: String) -> UIImage? {
    // Convert the string of bytes to Data
    guard let data = Data(base64Encoded: bytes, options: .ignoreUnknownCharacters) else {
        return nil
    }
    
    // Convert the Data to a UIImage
    guard let uiImage = UIImage(data: data) else {
        return nil
    }
    
    return uiImage
}
func getUserByEmail(email: String, completion: @escaping (Persondetails?) -> Void) {
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

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var emailsentup:String
    @Binding var nbr :Int
    @Binding var refresh:Bool
  
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.image = uiImage
            
                if parent.nbr == 1 {
                    let url = URL(string: "http://104.225.216.185:9300/persons/img")!
                    uploadImage(uiImage,email: parent.emailsentup,urlup:url,imgname: "photo"){ res in
                       
                           
                        switch res {
                                          case .success(let isSuccess):
                                              if isSuccess {
                                                  // handle success case
                                                  print("Image upload successful!")
                                                  self.parent.refresh = true
                                                  // refresh the view here
                                              } else {
                                                  // handle failure case
                                                  print("Image upload failed.")
                                              }
                                          case .failure(let error):
                                              // handle error case
                                              print("Error: \(error.localizedDescription)")
                                          }
                   
                    }
                   
                }else if parent.nbr == 2 {
                   
                    let url = URL(string: "http://104.225.216.185:9300/persons/couverture")!
                    uploadImage(uiImage,email: parent.emailsentup,urlup:url,imgname: "couverture"){ res in
                       
                           
                        switch res {
                                          case .success(let isSuccess):
                                              if isSuccess {
                                                  // handle success case
                                                  print("Image upload successful!")
                                                  self.parent.refresh = true
                                                  // refresh the view here
                                              } else {
                                                  // handle failure case
                                                  print("Image upload failed.")
                                              }
                                          case .failure(let error):
                                              // handle error case
                                              print("Error: \(error.localizedDescription)")
                                          }
                   
                    }
                    /*uploadImagec(uiImage,email: parent.emailsentup,urlup:url)*/
                    
                    
                    
                    
                    
                }
                
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    } }







func uploadImage(_ image: UIImage, email: String, urlup:URL, imgname:String,completion: @escaping (Result<Bool, Error>) -> Void) {
    
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
  
        let parameters = ["email": email]
        var request = URLRequest(url: urlup)
        request.httpMethod = "PUT"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let dataBody = NSMutableData()
        
        for (key, value) in parameters {
            dataBody.append("--\(boundary)\r\n".data(using: .utf8)!)
            dataBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            dataBody.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        dataBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        dataBody.append("Content-Disposition: form-data; name=\"\(imgname)\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        dataBody.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        dataBody.append(imageData)
        dataBody.append("\r\n".data(using: .utf8)!)
        dataBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = dataBody as Data
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if httpResponse.statusCode == 200 {
                
                    completion(.success(true))
                   
                    
                
            } else {
                completion(.success(false))
                print("HTTP status code: \(httpResponse.statusCode)")
            }
        }
        
        task.resume()
    }


