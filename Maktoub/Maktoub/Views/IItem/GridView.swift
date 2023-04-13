//
//  GridView.swift
//  Maktoub
//
//  Created by user236595 on 4/2/23.
//

import SwiftUI
import Contacts
import ContactsUI




struct GridView: View {
    
    @State private var isShowingPopup = false
    @ObservedObject var linkManager = LinkManager()
    
    @State private var showingPopup = false
   
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @StateObject var lsttManager = LinkManager()
    @State  var lst:[FileLink]
    @State var icons:[LinkItem] = LinkItem.linkItems
    func getObjectForItem(_ it: LinkItem) -> LinkItem? {
        var obj = LinkItem(title: it.title, destination: it.destination, imageName: it.imageName, linkDescription: it.linkDescription)
        
        for item in lst{
           
            if item.name.caseInsensitiveCompare(it.title) == .orderedSame {
                obj.destination = URL(string: item.url) ?? obj.destination
               
                break // Exit the loop after finding the first match
            }
        }
        
        return obj
    }

    
    var body: some View {
        ScrollView {
           

            LazyVGrid(columns: columns, spacing: 20) {
              
                ForEach(LinkItem.linkItems) { item in
                
                    linkView(for :getObjectForItem(item) ?? item)
                 
                }
            }
            .padding(.horizontal,25)
            Divider()
            
           
        }
    
    }

   
    
    private func linkView(for item: LinkItem) -> some View {
    
        

        Link(destination:addHTTPIfNeeded(to: item.destination )) {
            VStack {
               
                Image(item.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50,height: 50)
                    .cornerRadius(10)
            
            }
        }
    }
}
func addHTTPIfNeeded(to url: URL) -> URL {
    if url.scheme == "http" || url.scheme == "https" {
        // URL already has http or https, return as is
        return url
    } else {
        
        let urlStringWithHTTP = "http://" + url.absoluteString
        return URL(string: urlStringWithHTTP)!
    }
}






struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(lst: [])
    }
}
struct PopupView: View {
    @Binding var isShowingPopup: Bool
   
    
    var body: some View {
        VStack {
            Text("Do you want to add Contact ?")
                .padding()
            HStack{
             
                Text(" : ")
             
            }
            
            
            HStack{
                Button("Ok") {
                    print("ok")
                    isShowingPopup = false
                }
                .padding()
                
                Button("Cancel") {
                    isShowingPopup = false
                }
                .padding()
            }
           
        }
        .background(Color("Gold"))
        .frame(width: 300, height: 150)
        .cornerRadius(10)
        .clipShape(Rectangle())
       
    }
}
