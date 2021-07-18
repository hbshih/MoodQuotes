//
//  GeegeeWidgetView.swift
//  widgetExtension
//
//  Created by Ben on 2020/11/20.
//

import Foundation
import WidgetKit
import SwiftUI

struct GeegeeWidgetView: View {

  //let emojiDetails: EmojiDetails
    
    
    let date: Date
    let quote: Quote
    let flowerImage: UIImage
    let flowerName: String
    let quoteSize: Double
    let authorSize: Double
    
    var backgroundColor: UIColor{
        if let color = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.colorForKey(key: "BackgroundColor")
        {
            print(color)
            return color
        }
        else
        {
            return UIColor.gray
        }
    }

    var body: some View {
        
    ZStack {
        if #available(iOS 14.0, *) {
            Color(backgroundColor).ignoresSafeArea(.all).edgesIgnoringSafeArea(.all)
        } else {
            // Fallback on earlier versions
        }
        // Widget Background Image
      //  Image(uiImage: #imageLiteral(resourceName: "Webp.net-compress-image-removebg-preview.png"))
        HStack{
            VStack{
                VStack{
                    Image(uiImage: flowerImage).resizable().frame(width: 60, height: 60, alignment: .center)
                    Text(flowerName).font(Display_Font(font_size: Int(12)).getFont()).multilineTextAlignment(.center).foregroundColor(.gray)
                    Text(date.getLunarDate).font(.system(size: 8.0)).fontWeight(.light).multilineTextAlignment(.center).foregroundColor(.gray)
                }
            }
            
            VStack{
                VStack{
                    Text(quote.quote).font(Display_Font(font_size: Int(18)).getFont()).foregroundColor(.gray).multilineTextAlignment(.center).padding(.leading,8).padding(.trailing,8).minimumScaleFactor(0.5)
                    Text(quote.author)
                        .font(Display_Font(font_size: Int(12)).getFont())
                      .multilineTextAlignment(.center)
                      .padding(.top, 5)
                        .foregroundColor(.gray)
                }
            }
        }

    }
    .padding(.vertical, 2.5).padding(.horizontal, 16)
    }
}



struct GeegeeWidgetView_Large: View {
    //let emojiDetails: EmojiDetails
      
      let date: Date
      let quote: Quote
      let flowerImage: UIImage
      let flowerName: String
      let quoteSize: Double
      let authorSize: Double
      
      var backgroundColor: UIColor{
          if let color = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.colorForKey(key: "BackgroundColor")
          {
              print(color)
              return color
          }
          else
          {
              return UIColor.gray
          }
      }

      var body: some View {
          
      ZStack {
          if #available(iOS 14.0, *) {
              Color(backgroundColor).ignoresSafeArea(.all).edgesIgnoringSafeArea(.all)
          } else {
              // Fallback on earlier versions
          }
          // Widget Background Image
        //  Image(uiImage: #imageLiteral(resourceName: "Webp.net-compress-image-removebg-preview.png"))
          VStack{
              HStack{
                  HStack{
                    Image(uiImage: flowerImage).resizable().frame(width: 100, height: 100, alignment: .center)
                      Text(flowerName).font(Display_Font(font_size: Int(12)).getFont()).multilineTextAlignment(.center).foregroundColor(.gray)
                      //Text(date.getTodayDate).font(.system(size: 8.0)).fontWeight(.light).multilineTextAlignment(.center).foregroundColor(.gray)
                  }
              }
              
              VStack{
                  VStack{
                      Text(quote.quote).font(Display_Font(font_size: Int(18)).getFont()).foregroundColor(.gray).multilineTextAlignment(.center).padding(.leading,8).padding(.trailing,8).minimumScaleFactor(0.5)
                      Text(quote.author)
                          .font(Display_Font(font_size: Int(12)).getFont())
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                          .foregroundColor(.gray)
                  }
              }
          }

      }
      .padding(.vertical, 2.5).padding(.horizontal, 16)
      }
}

struct GeegeeWidgetView_small: View {
    //let emojiDetails: EmojiDetails
      
      let date: Date
      let quote: Quote
      let flowerImage: UIImage
      let flowerName: String
      let quoteSize: Double
      let authorSize: Double
      
      var backgroundColor: UIColor{
          if let color = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.colorForKey(key: "BackgroundColor")
          {
              print(color)
              return color
          }
          else
          {
              return UIColor.gray
          }
      }

      var body: some View {
          
      ZStack {
          if #available(iOS 14.0, *) {
              Color(backgroundColor).ignoresSafeArea(.all).edgesIgnoringSafeArea(.all)
          } else {
              // Fallback on earlier versions
          }
          // Widget Background Image
        //  Image(uiImage: #imageLiteral(resourceName: "Webp.net-compress-image-removebg-preview.png"))
          HStack{
                      Text(quote.quote).font(Display_Font(font_size: Int(18)).getFont()).foregroundColor(.gray).multilineTextAlignment(.center).padding(.leading,8).padding(.trailing,8).minimumScaleFactor(0.5)
          }

      }
      .padding(.vertical, 2.5).padding(.horizontal, 16)
      }
}

struct GeegeeWidgetView_Previews_2: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

struct GeegeeWidgetView_Previews_3: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
