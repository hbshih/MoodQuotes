import UIKit
import UserNotifications

class NotificationTrigger : NSObject {
    
    func setupNotifications() {
        
        let startDate = Date()
     //   let weekDays =  CustomNotification.everyOtherDay(wtihStartDate: startDate)
        let cal = Calendar.current
        let center = UNUserNotificationCenter.current()
        
        let identifier = UUID().uuidString
        
        let content = UNMutableNotificationContent()
        content.title = "每天進步一點點"
        
        var hasPendingNoti = false
        
        center.getPendingNotificationRequests(completionHandler: { requests in
            if requests.count > 0
            {
                hasPendingNoti = true
            }
        })
        
        
        if (UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote")) == nil || SyncAppQuotes().checkIfUpdate() || !hasPendingNoti
            {
            
            print("Set up notification")
            
            if let notificationDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") as? Date
            {
                let updateTime = Calendar.current.date(byAdding: .day, value: 1, to: notificationDate)
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(updateTime, forKey: "updateTime")
                
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
                        // content.setValue("YES", forKeyPath: "shouldAlwaysAlertWhileAppIsForeground")
                        
                        if let notificationDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") as? Date
                        {
                            var components = cal.dateComponents([.hour, .minute], from:startDate)
                            components.hour = notificationDate.hour
                            components.minute = notificationDate.minute
                         //   components.weekday = day
                            
                            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                            let request = UNNotificationRequest(identifier: identifier,
                                                                content: content, trigger: trigger)
                            
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
        }
    }
}


