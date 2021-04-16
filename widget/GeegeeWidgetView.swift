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
    
    
    
    let quote: Quote
    let quoteSize: Double
    let authorSize: Double
    
  /*
    if let color = UserDefaults.standard.colorForKey(key: "BackgroundColor") as? UIColor
    {
        screenView.backgroundColor = color
        backgroundHideenView.backgroundColor =  color
    }*/
    
   // @AppStorage("BackgroundColor") var color: UIColor = 5
    
 /*   @AppStorage("BackgroundColor", store: UserDefaults(suiteName: "group.BSStudio.Geegee.ios"))
    var value: Any = "5"
   */
    
    
//    UserDefaults(suiteName: "group.BSStudio.Geegee.ios"). as? Int ?? 0
    
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
       // Color(backgroundColor)
        HStack{
            VStack{
                VStack{
                    Image(uiImage: UIImage(named: "allium bulbs")!).resizable().frame(width: 60, height: 60, alignment: .center)
                    Text("罌粟花").font(Display_Font(font_size: Int(12)).getFont()).multilineTextAlignment(.center)
                    Text(Date().getTodayDate).font(.system(size: 8.0)).fontWeight(.light).multilineTextAlignment(.center)
                }
            }
            
            VStack{
                VStack{
                    Text(quote.quote).font(Display_Font(font_size: Int(18)).getFont()).foregroundColor(.black).multilineTextAlignment(.center).padding(.leading,8).padding(.trailing,8)
                    Text(quote.author)
                        .font(Display_Font(font_size: Int(12)).getFont())
                      .multilineTextAlignment(.center)
                      .padding(.top, 5)
                        .foregroundColor(.black)
                }
            }
        }
        /*
        HStack(spacing: 0) {
            Text("Left")
                .font(.largeTitle)
                .foregroundColor(.black)
                .frame(width: geometry.size.width * 0.33)
                .background(Color.yellow)
            Text("Right")
                .font(.largeTitle)
                .foregroundColor(.black)
                .frame(width: geometry.size.width * 0.67)
                .background(Color.orange)
        }
      VStack {
        
       // Text(Date_Manager().getWidgetDisplayDate()).font(Display_Font(font_size: Int(authorSize)).getFont()).multilineTextAlignment(.center)
        Text(quote.quote).font(Display_Font(font_size: Int(quoteSize)).getFont()).foregroundColor(.black).multilineTextAlignment(.center)
        Text(quote.author)
            .font(Display_Font(font_size: Int(authorSize)).getFont())
          .multilineTextAlignment(.center)
          .padding(.top, 5)
            .foregroundColor(.black)
      }*/
    }
    .padding(.vertical, 2.5).padding(.horizontal, 16)
    }
}



struct GeegeeWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
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
