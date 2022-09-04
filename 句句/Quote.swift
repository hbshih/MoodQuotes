//
//  Quote.swift
//  句句
//
//  Created by Ben on 2020/11/20.
//

import Foundation
import UIKit
import SwiftUI


struct Quote
{
    let quote: String
    let author: String
}

struct Display_Font
{
    let selected_font = "I.PenCrane-B"
    var font_size: Int
    
    func getUIFont() -> UIFont
    {
       // if let array = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedQuoteArray") as? [String]
        
        
        if let font = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "userFont")
        {
            var final_font_size = Double(font_size)
            if font == "ChenYuluoyan-Thin"
            {
                final_font_size = Double(font_size) * 1.5
            }
            print("current font \(font)")
            return UIFont(name: font, size: CGFloat(final_font_size)) ?? UIFont(name: selected_font, size: CGFloat(final_font_size))!
        }
       // return UIFont.systemFont(ofSize: 30)
     //   return UIFont.systemFont(ofSize: 30)
            
           return UIFont(name: selected_font, size: CGFloat(font_size))!
            //UIFont(name: sys, size: CGFloat(font_size))!
    }
    
    func getFont() -> Font
    {
       // return Font.custom(selected_font, size: CGFloat(font_size))
            
        // if let array = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedQuoteArray") as? [String]
         
         if let font = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "userFont")
         {
             print("current font \(font)")
             return Font.custom(font, size: CGFloat(font_size))
             //UIFont(name: font, size: CGFloat(font_size)) ?? UIFont(name: selected_font, size: CGFloat(font_size))!
         }
        // return UIFont.systemFont(ofSize: 30)
      //   return UIFont.systemFont(ofSize: 30)
             
            return Font.custom(selected_font, size: CGFloat(font_size))
             //UIFont(name: sys, size: CGFloat(font_size))!
    }
}


