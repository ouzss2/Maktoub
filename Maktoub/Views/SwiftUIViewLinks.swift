//
//  SwiftUIViewLinks.swift
//  Maktoub
//
//  Created by user236595 on 4/6/23.
//

import SwiftUI
import SystemConfiguration



struct SwiftUIViewLinks: View {
   // @State private var selectedOption = 0
       let options = ["Option 1", "Option 2", "Option 3"]
    @State private var selectedOption: String? = nil
    @State private var linkText: String = ""
    @State private var isLinkValid: Bool = false
    @State private var isSentCorrectly: Bool = false
    @State  public var link = ""
    
    let manage = LinkManager()
    
    let gradiant = Gradient(colors: [Color("Black"),Color("Center"),Color("Gold")])
    @State private var errorMessage: String?
    @State var emailsentlink:String = UserDefaults.standard.string(forKey: "mail") ?? ""
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        GeometryReader { geometry in
               VStack {
                   Spacer()
                   Image("logo") // Replace "logo" with the name of your logo image asset
                       .resizable()
                       .frame(width: 200, height: 120)
                       .padding(.bottom,50)
                       .padding(.bottom,50)
                   
                   Text("Website Name")
                       .foregroundColor(.white)
                       .font(.system(size: 22, weight:.bold))
                       .multilineTextAlignment(.center)
                       .lineLimit(nil) // Allow text to wrap to multiple lines
                       .padding()
                   
                   HStack{
                       
                           Menu(selectedOption ?? "Choose a Site") {
                               ForEach(LinkItem.linkItems, id: \.title) { option in
                                   Button(action: {
                                       self.selectedOption = option.title
                                   }) {
                                       Text(option.title)
                                         
                                   }
                               }
                           }.padding(.all)
                           .frame(height: 50)
                           .font(.headline)
                           .background(.white)
                           .clipShape(RoundedRectangle(cornerRadius: 10))
                           .shadow(color: Color.black.opacity(0.3), radius: 4,x: 2,y: 2)
                   }

                   TextField("Link", text: $link)
                       .frame(height: 50)                   .textFieldStyle(RoundedBorderTextFieldStyle())
                       .padding(.horizontal,20)
                       .padding(.top,20)
                   if let message = errorMessage {
                             Text(message)
                                 .foregroundColor(.red)
                         }
                   
                   Button(action: {
                      // print(String(selectedOption))
                       if let selectedOption = selectedOption {
                           let myString = String(selectedOption)
                         // This will print the value of selectedOption as a non-optional string
                           
                           if validateURL(link) {
                               // Do something with the valid link
                               errorMessage = nil // Clear the error message
                               let jsonObject: [String: Any] = [
                                      "email": emailsentlink,
                                      "name": myString,
                                      "url": link
                                  ]
                               let liksent:FileLink = FileLink(email: emailsentlink, name: myString, url: link)
                               guard let url = URL(string: "http://104.225.216.185:9300/persons/addlink")
                               else {
                                   return
                               }
                               
                               var request = URLRequest(url: url)
                               request.httpMethod = "POST"
                               
                               
                               do {
                                   let jsonBody = try JSONEncoder().encode(liksent)
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
                                       manage.clearLinks()
                                        fetchLinkItems(email: emailsentlink) { linkItems in
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
                                       presentationMode.wrappedValue.dismiss()
                                    
                                   }
                               }.resume()
                          
                               
                           } else  {
                               errorMessage = "Invalid link. Please enter a valid link."
                           }
                           
                       } else {
                           errorMessage = "No Option Was Selected ."
                       }
                    
                            
                          },label:  {
                              Text("Submit")
                                  .foregroundColor(.white)
                                  .font(.headline)
                                  .padding()
                                  .background(Color.blue)
                                  .cornerRadius(10)
                          })
                              Spacer()
               }
                .frame(width: geometry.size.width, height: geometry.size.height)
               .background(
                   LinearGradient(gradient: gradiant, startPoint: .top, endPoint: .bottom)
               )
           }
       }
  
   }


func validateURL(_ urlString: String) -> Bool {
    let urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
    
    var urlStringWithScheme = urlString
    if !urlStringWithScheme.contains("://") {
        urlStringWithScheme = "http://" + urlStringWithScheme
    }
    
    if let url = URL(string: urlStringWithScheme), UIApplication.shared.canOpenURL(url), urlTest.evaluate(with: urlStringWithScheme) {
        return true
    } else {
        return false
    }
}



struct SwiftUIViewLinks_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIViewLinks()
    }
}
