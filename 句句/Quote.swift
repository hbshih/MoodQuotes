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
    let selected_font = "QIJIC"
    let font_size: Int
    
    func getUIFont() -> UIFont
    {
       // return UIFont.systemFont(ofSize: 30)
     //   return UIFont.systemFont(ofSize: 30)
            
           return UIFont(name: selected_font, size: CGFloat(font_size))!
            //UIFont(name: sys, size: CGFloat(font_size))!
    }
    
    func getFont() -> Font
    {
        return Font.custom(selected_font, size: CGFloat(font_size))
            
          //  Font(Font.custom(selected_font, size: CGFloat(font_size)))
    }
}


