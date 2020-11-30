//
//  SyncAppQuotes.swift
//  句句
//
//  Created by Ben on 2020/11/27.
//

import Foundation
import Firebase
import WidgetKit

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
    
    func updateTime()
    {
        if let notificationDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") as? Date
        {
            print("Original Update Time \(notificationDate) ")
            var components = Calendar.current.dateComponents([.hour, .minute], from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
            components.hour = notificationDate.hour
            components.minute = notificationDate.minute
            print("New Update Time \(components.date!)")
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(components.date, forKey: "updateTime")
            
            /*For Testing*/
            let content = UNMutableNotificationContent()
            content.title = "test notifaction"
            content.body = "Update Time Info, New Time \(components.date)"
            content.sound = UNNotificationSound.default

            let tri = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let req  = UNNotificationRequest(identifier: "testidentifire", content: content, trigger: tri)

            UNUserNotificationCenter.current().add(req) { (error) in
                print("error\(error )")
            }
            /*Testing Ends*/
        }
    }
    
    func handleLocalUpdate()
    {
        
        if (UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote")) == nil || checkIfUpdate()
        {
            /*For Testing*/
            let content = UNMutableNotificationContent()
            content.title = "test notifaction"
            content.body = "Routine Check, Will Update"
            content.sound = UNNotificationSound.default

            let tri = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let req  = UNNotificationRequest(identifier: "testidentifire_", content: content, trigger: tri)

            UNUserNotificationCenter.current().add(req) { (error) in
                print("error\(error )")
            }
            /*Testing Ends*/
            
            // Get From API
            DispatchQueue.main.async {
                firebaseService().getQuoteApiResponse { [self] (result) in
                    let quoteInfo: [Quote]
                    if case .success(let fetchedData) = result {
                        quoteInfo = fetchedData
                        DispatchQueue.main.async { [self] in
                            // Update Local Data
                            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(quoteInfo.first!.quote, forKey: "Quote")
                            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(quoteInfo.first!.author, forKey: "Author")
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                    } else {
                        let errQuote = Quote(quote: "App當機拉", author: "By Me")
                        quoteInfo = [errQuote,errQuote]
                    }
                }
            }
            
            //update [UpdateTime]
            updateTime()
        }else
        {
            /*For Testing*/
            let content = UNMutableNotificationContent()
            content.title = "test notifaction"
            content.body = "Routine Check, Will Not Update"
            content.sound = UNNotificationSound.default

            let tri = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let req  = UNNotificationRequest(identifier: "testidentifire_", content: content, trigger: tri)

            UNUserNotificationCenter.current().add(req) { (error) in
                print("error\(error )")
            }
            /*Testing Ends*/
        }
    }
    
    func getQuoteOfTheDay()
    {
        
    }
    
    func saveLocally()
    {
        
    }
    
}
