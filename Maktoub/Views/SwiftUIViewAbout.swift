//
//  SwiftUIViewAbout.swift
//  Maktoub
//
//  Created by user236595 on 4/4/23.
//

import SwiftUI

struct SwiftUIViewAbout: View {
    let gradiant = Gradient(colors: [Color("Black"),Color("Center"),Color("Gold")])
    let longText = "Welcome To Maktub For Online Trading And Marketing"
    let mision = "Our Mission is to make life easier , and your bussiness grow with our modern service you can buy your Comfort"
    let Vision = "Our vision is to be the leading company in Qatar for online trading and marketing and to be known globally"
    
    var body: some View {
        ZStack {
                  LinearGradient(gradient: gradiant, startPoint: .top, endPoint: .bottom)
                      .edgesIgnoringSafeArea(.all) // Set gradient background for entire screen
                  ScrollView {
                      VStack {
                          Image("logo")
                              .resizable()
                              .frame(width: 250, height: 150)
                              .padding(.top,50)
                          Divider().padding(.top,20)
                         SectionViewP(sectionTitle: "AboutUs", sectionText: longText)
                          Divider()
                          SectionViewP(sectionTitle: "Our Mission", sectionText: mision)
                          Divider()
                          SectionViewP(sectionTitle: "Our Vision", sectionText: Vision)
                          Divider().padding(.top,10)
                          VStack {
                            
                              Text("Contact information")
                                  .foregroundColor(Color("Gold"))
                                  .font(.system(size: 28, weight: .bold, design: .serif))
                                  .padding(.bottom, 10)
                              HStack {
                                  Image(systemName: "location.fill")
                                      .foregroundColor(.white)
                                      .font(.system(size: 28))
                                  Text("Maktub Qatar, lusail\nState of Qatar")
                                      .foregroundColor(.white)
                                      .font(.system(size: 20))
                                      .multilineTextAlignment(.center)
                              }
                              HStack {
                                  Image(systemName: "phone.fill")
                                      .foregroundColor(.white)
                                      .font(.system(size: 28))
                                  Text("+974 77776849")
                                      .foregroundColor(.white)
                                      .font(.system(size: 20))
                              }
                              HStack {
                                  Image(systemName: "envelope.fill")
                                      .foregroundColor(.white)
                                      .font(.system(size: 28))
                                  Text("Sales@Maktubqa.com")
                                      .foregroundColor(.white)
                                      .font(.system(size: 20))
                              }
                              
                              Spacer().padding(.top,100)
                          }
                         
                      }.padding(.horizontal,25)
                  }
              }
       
    }
}
struct SwiftUIViewAbout_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIViewAbout()
    }
}
struct SectionViewP: View {
    
    let sectionTitle: String
    let sectionText: String
    
    var body: some View {
        VStack {
          
            Text(sectionTitle)
                .foregroundColor(Color("Gold"))
                .font(.system(size: 28, weight: .bold, design: .serif))
                .padding(.bottom, 10)
            Text(sectionText)
                .foregroundColor(.white)
                .font(.system(size: 22, weight:.bold))
                .multilineTextAlignment(.center)
                .lineLimit(nil) // Allow text to wrap to multiple lines
                .padding()
           
        }
    }
}
