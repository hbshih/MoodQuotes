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
                    Text(date.getTodayDate).font(.system(size: 8.0)).fontWeight(.light).multilineTextAlignment(.center).foregroundColor(.gray)
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


struct GeegeeWidgetView_2: View {

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
            //quote
            Text(quote.quote).font(Display_Font(font_size: Int(22)).getFont()).foregroundColor(Color(#colorLiteral(red: 0.36, green: 0.36, blue: 0.47, alpha: 1))).tracking(0.22).multilineTextAlignment(.center).minimumScaleFactor(0.5)
            //author
            Text(quote.author).font(Display_Font(font_size: Int(14)).getFont()).foregroundColor(Color(#colorLiteral(red: 0.59, green: 0.59, blue: 0.59, alpha: 1))).tracking(0.84)
        }
    }
    .padding(.vertical, 2.5).padding(.horizontal, 16)
    }
}

struct GeegeeWidgetView_3: View {

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
        
        HStack {
        //Frame 27
            //Uncaria tomentosa 1
            Image(uiImage: #imageLiteral(resourceName: "Uncaria tomentosa 1"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 128, height: 128)
                .clipped()
            .frame(width: 128, height: 128)

        //一種生長在海拔1040公尺的花，可以很浪漫的陪你成長。
            Text("一種生長在海拔1040公尺的花，可以很浪漫的陪你成長。").font(.custom("jf-openhuninn-1.1 Regular", size: 12)).foregroundColor(Color(#colorLiteral(red: 0.31, green: 0.31, blue: 0.31, alpha: 1))).tracking(1.5)

        //罌粟花
            Text("罌粟花").font(.custom("jf-openhuninn-1.1 Regular", size: 18)).foregroundColor(Color(#colorLiteral(red: 0.31, green: 0.31, blue: 0.31, alpha: 1))).tracking(2.25)
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
          VStack(alignment: .leading, spacing: 64){
              
              HStack{
                  
                  HStack{
                      HStack
                      {
                          Text(date.getDateDayOnly).font(Display_Font(font_size: Int(24)).getFont()).fontWeight(.light).multilineTextAlignment(.leading
                          ).foregroundColor(.gray)
                          VStack
                          {
                              Text(date.getFormattedDate).font(Display_Font(font_size: Int(14)).getFont()).multilineTextAlignment(.center).foregroundColor(.gray)
                              Text(date.getTWday).font(Display_Font(font_size: Int(14)).getFont()).multilineTextAlignment(.center).foregroundColor(.gray)
                          }
                      }
                      
                      //Text("今日心情").font(.system(size: 16.0)).fontWeight(.light).multilineTextAlignment(.center).foregroundColor(.gray)
                      
                  }
                  
              }
              
              Text(quote.quote).font(Display_Font(font_size: Int(24)).getFont()).fontWeight(.light).multilineTextAlignment(.leading).foregroundColor(.gray)
              
              Text(quote.author).font(Display_Font(font_size: Int(14)).getFont()).fontWeight(.light).multilineTextAlignment(.center).foregroundColor(.gray)
              
              
              
              /*
              
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
              
              */
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
          Image(uiImage: flowerImage).resizable().frame(width: 128, height: 128, alignment: .center)

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
