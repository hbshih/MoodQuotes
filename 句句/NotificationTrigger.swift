import UIKit
import UserNotifications

class NotificationTrigger : NSObject {
    let startDate = Date()
    let cal = Calendar.current
    let center = UNUserNotificationCenter.current()
    
    func setupNotifications() {
        
        
        
        // Has Notification Turned On
        if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.bool(forKey: "isNotificationOn")
        {
            notifyQuoteHasChanged()

            /*
            center.getPendingNotificationRequests { (results) in
                print("### \n pending notifications \(results) \n###")
            }
            
            if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote") == nil
            {
                print("yes")
                DispatchQueue.main.async{
                    SyncAppQuotes().handleLocalUpdate { (result) in
                        self.getNotified()
                    }
                }
            }else
            {
                self.getNotified()
            }
            
            */
        }else
        {
            center.removeAllPendingNotificationRequests()
            //   NotificationCenter()
        }
        /*
         if (UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote")) == nil || SyncAppQuotes().checkIfUpdate()
         {
         
         
         print("Set up notification")
         
         if let notificationDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") as? Date
         {
         var components = Calendar.current.dateComponents([.hour, .minute], from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
         components.hour = notificationDate.hour
         components.minute = notificationDate.minute
         
         let dateTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
         
         //  print(Calendar.current.date(bySettingHour: sender.date.hour, minute: sender.date.minute, second: 0, of: dateTomorrow ))
         
         // print("update time \(components.date ?? <#default value#>)")
         
         UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(components.date, forKey: "updateTime")
         
         }
         
         DispatchQueue.main.async {
         firebaseService().getQuoteApiResponse {(result) in
         let quoteInfo: [Quote]
         if case .success(let fetchedData) = result {
         quoteInfo = fetchedData
         
         UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(quoteInfo.first!.quote, forKey: "Quote")
         UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(quoteInfo.first!.author, forKey: "Author")
         
         content.body = quoteInfo.first!.quote
         content.sound = UNNotificationSound.default
         content.categoryIdentifier = "Daily Notifier"
         if let notificationDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") as? Date
         {
         var components = cal.dateComponents([.hour, .minute], from:startDate)
         components.hour = notificationDate.hour
         components.minute = notificationDate.minute
         //   components.weekday = day
         
         let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
         let request = UNNotificationRequest(identifier: identifier,
         content: content, trigger: trigger)
         
         
         /*For Testing*/
         let content = UNMutableNotificationContent()
         content.title = "test notifaction"
         content.body = "Set Notification for \(content.body) at \(components.date)"
         content.sound = UNNotificationSound.default
         
         let tri = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
         let req  = UNNotificationRequest(identifier: "testidentifire", content: content, trigger: tri)
         
         UNUserNotificationCenter.current().add(req) { (error) in
         print("error\(error )")
         }
         /*Testing Ends*/
         
         center.add(request, withCompletionHandler: { (error) in
         if let error = error {
         // Something went wrong
         print("ERROR ADDING NOTIFICATION TO CENTER \(error.localizedDescription)")
         } else
         {
         print("ADDING NOTIFCIATION \(content.categoryIdentifier) \n \(content.body) \(request.content)")
         }
         })
         }
         
         } else {
         let errQuote = Quote(quote: "App當機拉", author: "By Me")
         quoteInfo = [errQuote,errQuote]
         }
         }
         }
         }else
         {
         
         print("load from local")
         let Q: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote")!
         let A: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Author")!
         
         let content = UNMutableNotificationContent()
         content.title = "test notifaction"
         content.body = "test notification every 30 minutes, checking database, remain local with (\(Q)"
         content.sound = UNNotificationSound.default
         
         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
         let request  = UNNotificationRequest(identifier: "testidentifire", content: content, trigger: trigger)
         
         UNUserNotificationCenter.current().add(request) { (error) in
         print("error\(error )")
         }
         
         }*/
    }
    
    func getNotified()
    {
      //  testing()
        
        let identifier = "dailyNotifier"
        let content = UNMutableNotificationContent()
        content.title = "我說啊"
        let Q: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote")!
        let A: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Author")!
        content.body = "\(Q) \n —\(A)"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "Daily Notifier"
        
        if let notificationDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") as? Date
        {
            var components = cal.dateComponents([.hour, .minute], from:startDate)
            components.hour = notificationDate.hour
            components.minute = notificationDate.minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content, trigger: trigger)
            center.add(request, withCompletionHandler: { [self] (error) in
                if let error = error {
                    // Something went wrong
                    print("ERROR ADDING NOTIFICATION TO CENTER \(error.localizedDescription)")
                } else
                {
                    print("ADDING NOTIFCIATION \(content.categoryIdentifier) \n \(content.body) \(request.content)")
                    center.getPendingNotificationRequests { (results) in
                        print("### \n pending notifications \(results) \n###")
                    }
                }
            })
        }
    }
    func testing()
    {
        /*For Testing*/
        let content = UNMutableNotificationContent()
        content.title = "test notifaction"
        content.body = "notification updating..."
        content.sound = UNNotificationSound.default

        let tri = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let req  = UNNotificationRequest(identifier: "testidentifire", content: content, trigger: tri)

        UNUserNotificationCenter.current().add(req) { (error) in
            print("error\(error )")
        }
        /*Testing Ends*/
        
        
        
    }
    
    // Notify Tomorrow
    func notifyQuoteHasChanged()
    {
        let identifier = "dailyNotifier"
        let content = UNMutableNotificationContent()
        content.title = "看看今日給你的話 👀"
        content.body = "點開查看屬於你的植物與花語吧！別忘了順便記錄今天的心情！"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "defaultNotifier"
        
        if let notificationDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") as? Date
        {
            var components = cal.dateComponents([.hour, .minute], from: notificationDate)
            components.hour = notificationDate.hour
            components.minute = notificationDate.minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content, trigger: trigger)
            center.add(request, withCompletionHandler: { [self] (error) in
                if let error = error {
                    // Something went wrong
                    print("ERROR ADDING NOTIFICATION TO CENTER \(error.localizedDescription)")
                } else
                {
                    print("ADDING NOTIFCIATION \(content.categoryIdentifier) \n \(content.body) \(request.content)")
                    center.getPendingNotificationRequests { (results) in
                        print("### \n pending notifications \(results) \n###")
                    }
                }
            })
            
        }
    }
    
    // Notify Tomorrow
    func notifyQuoteHasChanged(from: Date)
    {
        let identifier = "dailyNotifier"
        let content = UNMutableNotificationContent()
        content.title = "每日語錄更新"
        
        let trialWords = ["你今天的專屬語錄準備好了，打開看看吧！", "今天心情好嗎？來看看專屬你的語錄吧！", "打開看看今天的語錄吧！","想看看今天的語錄嗎？","看完今天的語錄再出門吧！"]
        // get random elements
        let randomTrialName = trialWords.randomElement()!
        
        content.body = randomTrialName
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "defaultNotifier"
        
        if let notificationDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") as? Date
        {
            var components = cal.dateComponents([.hour, .minute], from: Calendar.current.date(byAdding: .day, value: 1, to: from)!)
            components.hour = notificationDate.hour
            components.minute = notificationDate.minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content, trigger: trigger)
            center.add(request, withCompletionHandler: { [self] (error) in
                if let error = error {
                    // Something went wrong
                    print("ERROR ADDING NOTIFICATION TO CENTER \(error.localizedDescription)")
                } else
                {
                    print("ADDING NOTIFCIATION \(content.categoryIdentifier) \n \(content.body) \(request.content)")
                    center.getPendingNotificationRequests { (results) in
                        print("### \n pending notifications \(results) \n###")
                    }
                }
            })
            
        }
    }
    
    func checkIfPushTodayNotification()
    {
        
        
        
    }
    
}


