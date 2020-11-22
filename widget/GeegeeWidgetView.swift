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
      Color(backgroundColor)
      VStack {
            Text(quote.quote).font(Display_Font(font_size: 28).getFont()).foregroundColor(.black).multilineTextAlignment(.center)
        Text(quote.author)
            .font(Display_Font(font_size: 20).getFont())
          .multilineTextAlignment(.center)
          .padding(.top, 5)
          .padding([.leading, .trailing])
            .foregroundColor(.black)
      }
    }
  }
}


