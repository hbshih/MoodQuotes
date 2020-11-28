//
//  SyncAppQuotes.swift
//  句句
//
//  Created by Ben on 2020/11/27.
//

import Foundation
import Firebase

struct SyncAppQuotes {
    
    func checkIfUpdate() -> Bool
    {
        if let updateDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") as? Date
        {
            print("Date now \(Date())")
            print("Update date \(updateDate)")
            if Date() >= updateDate
            {
                return true
            }else
            {
                return false
            }
        }else
        {
            return true
        }
    }
    
    func getQuoteOfTheDay()
    {
        
    }
    
    func saveLocally()
    {
        
    }
    
}
