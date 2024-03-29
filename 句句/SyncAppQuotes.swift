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
                updateTime()
                return true
            }else
            {
                if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote") == "點開查看今日給你的話吧"
                {
                    return true
                }
                return false
            }
        }else
        {
            return true
        }
    }
    
    func checkIfUpdate_widget() -> Bool
    {
        if let updateDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTimeForWidget") as? Date
        {
            print("Date now \(Date())")
            print("Update date \(updateDate)")
            
            if Date() >= updateDate
            {
                updateTime_widget()
                return true
            }else
            {
                return false
            }
        }else
        {
            if let notificationDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") as? Date
            {
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(notificationDate, forKey: "updateTimeForWidget")
            }
            return true
        }
    }
    
    func updateTime_widget()
    {
        if let notificationDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTimeForWidget") as? Date
        {
            print("Original Update Time \(notificationDate) ")

            let date = Calendar.current.date(bySettingHour: notificationDate.hour, minute: notificationDate.minute, second: 0, of: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)!
            print("New Update Time \(date)")
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(date, forKey: "updateTimeForWidget")
        }else
        {
            if let notificationDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") as? Date
            {
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(notificationDate, forKey: "updateTimeForWidget")
            }
        }
    }
    
    func updateTime()
    {
        if let notificationDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") as? Date
        {
            print("Original Update Time \(notificationDate) ")

            let date = Calendar.current.date(bySettingHour: notificationDate.hour, minute: notificationDate.minute, second: 0, of: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)!

            
            print("New Update Time \(date)")
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(date, forKey: "updateTime")
            
            /*
            /* TESTING */
            let content = UNMutableNotificationContent()
            content.title = "我在更新下次更新時間"
            content.body = "現在時間\(notificationDate), 預計更新時間 \(date)"
            content.sound = UNNotificationSound.default

            let tri = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let req  = UNNotificationRequest(identifier: "check_3", content: content, trigger: tri)

            UNUserNotificationCenter.current().add(req) { (error) in
                print("error\(error )")
            }
            */
            /*TESTING**/
            
//            /*For Testing*/
//            let content = UNMutableNotificationContent()
//            content.title = "test notifaction"
//            content.body = "Update Time Info, New Time \(date)"
//            content.sound = UNNotificationSound.default
//
//            let tri = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//            let req  = UNNotificationRequest(identifier: "testidentifire", content: content, trigger: tri)
//
//            UNUserNotificationCenter.current().add(req) { (error) in
//                print("error\(error )")
//            }
//            /*Testing Ends*/
        }
    }
    
    func handleLocalUpdate(completion: @escaping (Result<[Quote], Error>) -> Void)
    {
        
        if (UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote")) == nil || checkIfUpdate()
        {
            print("update Local")
            
//            /*For Testing*/
//            let content = UNMutableNotificationContent()
//            content.title = "test notifaction"
//            content.body = "Routine Check, Will Update"
//            content.sound = UNNotificationSound.default
//
//            let tri = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//            let req  = UNNotificationRequest(identifier: "testidentifire_", content: content, trigger: tri)
//
//            UNUserNotificationCenter.current().add(req) { (error) in
//                print("error\(error )")
//            }
//            /*Testing Ends*/
            
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
                            if #available(iOS 14.0, *)
                            {
                                WidgetCenter.shared.reloadAllTimelines()
                            }
                            let data = Quote(quote: quoteInfo.first!.quote, author: quoteInfo.first!.author)
                            completion(.success([data]))
                        }
                    } else {
                        let errQuote = Quote(quote: "App當機拉", author: "By Me")
                        quoteInfo = [errQuote,errQuote]
                       // completion(.failure(result.error))
                    }
                }
            }
            
            //update [UpdateTime]
            updateTime()
        }else
        {
//            /*For Testing*/
//            let content = UNMutableNotificationContent()
//            content.title = "test notifaction"
//            content.body = "Routine Check, Will Not Update"
//            content.sound = UNNotificationSound.default
//
//            let tri = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//            let req  = UNNotificationRequest(identifier: "testidentifire_", content: content, trigger: tri)
//
//            UNUserNotificationCenter.current().add(req) { (error) in
//                print("error\(error )")
//            }
//            /*Testing Ends*/
        }
    }
    
    func handleLocalUpdate()
    {
        
        if (UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote")) == nil || checkIfUpdate()
        {
            print("update Local")
            
//            /*For Testing*/
//            let content = UNMutableNotificationContent()
//            content.title = "test notifaction"
//            content.body = "Routine Check, Will Update"
//            content.sound = UNNotificationSound.default
//
//            let tri = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//            let req  = UNNotificationRequest(identifier: "testidentifire_", content: content, trigger: tri)
//
//            UNUserNotificationCenter.current().add(req) { (error) in
//                print("error\(error )")
//            }
//            /*Testing Ends*/
            
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
                            if #available(iOS 14.0, *)
                            {
                                WidgetCenter.shared.reloadAllTimelines()
                            }
                        }
                    } else {
                        let errQuote = Quote(quote: "App當機拉", author: "By Me")
                        quoteInfo = [errQuote,errQuote]
                       // completion(.failure(result.error))
                    }
                }
            }
            
            //update [UpdateTime]
            updateTime()
        }else
        {
//            /*For Testing*/
//            let content = UNMutableNotificationContent()
//            content.title = "test notifaction"
//            content.body = "Routine Check, Will Not Update"
//            content.sound = UNNotificationSound.default
//
//            let tri = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//            let req  = UNNotificationRequest(identifier: "testidentifire_", content: content, trigger: tri)
//
//            UNUserNotificationCenter.current().add(req) { (error) in
//                print("error\(error )")
//            }
//            /*Testing Ends*/
        }
    }
    
    func getQuoteOfTheDay()
    {
        
    }
    
    func saveLocally()
    {
        
    }
    
}
