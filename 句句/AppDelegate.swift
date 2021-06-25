//
//  AppDelegate.swift
//  句句
//
//  Created by Ben on 2020/11/14.
//

import UIKit
import Firebase
import UserNotifications
import BackgroundTasks
//import UXCam
import WidgetKit
//import UXCam
//import GoogleMobileAds
import AppTrackingTransparency
//import FacebookCore
//import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //GADMobileAds.sharedInstance().start(completionHandler: nil)

        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        if NSClassFromString("ATTrackingManager") == nil {
          // Avoid showing the App Tracking Transparency explainer if the
          // framework is not linked.
          //InAppMessaging.inAppMessaging().messageDisplaySuppressed = true
        }else
        {
            ATTrackingManager.requestTrackingAuthorization { status in
              switch status {
              case .authorized:
                // Optionally, log an event when the user accepts.
                Analytics.setUserID(UIDevice.current.identifierForVendor?.uuidString)
                Analytics.logEvent("tracking_authorized", parameters: nil)
              case _: break
                
                // Optionally, log an event here with the rejected value.
              }
            }

        }
        
        
        
      //  handleNotificationUpdate()

        // Fetch data once an hour.
        UIApplication.shared.setMinimumBackgroundFetchInterval(3600)
      
       // UXCam.optIntoSchematicRecordings()
        //UXCam.start(withKey:"6ffyck6abrvtjx0")
//
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.moodquotes.fetchQuotes",
                                        using: nil) { (task) in
          // ...
            print("Register for Background")
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
        
        //registerBackgroundTasks()
        
        // Facebook Required
      //  let _ = ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        
        // GA
        /*
        guard let gai = GAI.sharedInstance() else {
          assert(false, "Google Analytics not configured correctly")
        }
        gai.tracker(withTrackingId: "YOUR_TRACKING_ID")
        // Optional: automatically report uncaught exceptions.
        gai.trackUncaughtExceptions = true

        // Optional: set Logger to VERBOSE for debug information.
        // Remove before app release.
        gai.logger.logLevel = .verbose;
        */
        /*
        NotificationCenter.default.addObserver(forName:UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { (_) in
            // Your Code here
            print("in background")
            //self.submitBackgroundTasks()
            
        }*/
        return true
    }
    

    
    
    func scheduleBackgroundPokemonFetch() {
        let pokemonFetchTask = BGAppRefreshTaskRequest(identifier: "com.moodquotes.fetchQuotes")
        pokemonFetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 1800)
        do {
          try BGTaskScheduler.shared.submit(pokemonFetchTask)
            print("submitted task")
        } catch {
          print("Unable to submit task: \(error.localizedDescription)")
        }
    }
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        
      //  handleNotificationUpdate()
      //  task.setTaskCompleted(success: true)
       // scheduleBackgroundPokemonFetch()
    }
    
    func handleNotificationUpdate()
    {
        
        if let notificationDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") as? Date
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date1String = dateFormatter.string(from: notificationDate)
            let date2String = dateFormatter.string(from: Date())
            
            let upd_date = dateFormatter.date(from: date1String)
            let cur_date = dateFormatter.date(from: date2String)
            
            if cur_date! >= upd_date!
            {
                // 更新Data
                
                // Get From API
                DispatchQueue.main.async {
                    firebaseService().getQuoteApiResponse { [self] (result) in
                        let quoteInfo: [Quote]
                        if case .success(let fetchedData) = result {
                            quoteInfo = fetchedData
                            DispatchQueue.main.async { [self] in
                                
                                let identifier = "daily quotes"
                                let content = UNMutableNotificationContent()
                                content.title = "今天想要和你說"
                                content.body = "\(quoteInfo.first?.quote ?? "語錄已經更新啦") \n —\(quoteInfo.first?.author ?? "去看看吧")"
                                content.sound = UNNotificationSound.default
                                content.categoryIdentifier = "quotes_notification"
                           /*
                                // Update Local Data
                                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(quoteInfo.first!.quote, forKey: "Quote")
                                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(quoteInfo.first!.author, forKey: "Author")*/
                                let cal = Calendar.current
                                var components = cal.dateComponents([.hour, .minute], from: Date())
                                components.hour = notificationDate.hour
                                components.minute = notificationDate.minute
                                
                                if (Date() > components.date!)
                                {
                                    components = cal.dateComponents([.hour, .minute], from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
                                    components.hour = notificationDate.hour
                                    components.minute = notificationDate.minute
                                }
                                
                                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                                let request = UNNotificationRequest(identifier: identifier,
                                                                    content: content, trigger: trigger)
                                let center = UNUserNotificationCenter.current()
                                
                                center.removePendingNotificationRequests(withIdentifiers: ["Daily Notifier"])
                                center.add(request, withCompletionHandler: { [self] (error) in
                                    if let error = error {
                                        // Something went wrong
                                        

                                        
                                        print("ERROR ADDING NOTIFICATION TO CENTER \(error.localizedDescription)")
                                    } else
                                    {
                                        
                                        NotificationTrigger().notifyQuoteHasChanged(from: components.date!)
                                        /*
                                        /* TESTING */
                                        let content = UNMutableNotificationContent()
                                        content.title = "新增了一個更新語錄的通知"
                                        content.body = "下個更新時間會是\(components.date)"
                                        content.sound = UNNotificationSound.default

                                        let tri = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                        let req  = UNNotificationRequest(identifier: "check_1", content: content, trigger: tri)

                                        UNUserNotificationCenter.current().add(req) { (error) in
                                            print("error\(error )")
                                        }*/
                                        
                                        /*TESTING**/
                                        
                                        print("ADDING NOTIFCIATION \(content.categoryIdentifier) \n \(content.body) \(request.content)")
                                        center.getPendingNotificationRequests { (results) in
                                            print("### \n pending notifications \(results) \n###")
                                        }
                                    }
                                })
                                
                                
                                
                                
                            }
                        } else {
                            let errQuote = Quote(quote: "App當機拉", author: "By Me")
                            quoteInfo = [errQuote,errQuote]
                        }
                    }
                }
                
                
            /*    // Add Notification
                NotificationTrigger().notifyQuoteHasChanged()*/
            }
        }
    }
    
    
    /*
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }*/
    
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // FETCH DATA and REFRESH NOTIFICATIONS
        // We need to do this to ensure the current week value is updated to either 1 or 0
        // You will need to delete all notifications with same same category first else your going to be getting both weeks notifications
        
        //task.setTaskCompleted(success: true)
        
        handleNotificationUpdate()
        
       // print("fetch for something")
        NSLog("fetch for something", String())
        /*
        DispatchQueue.main.async{
            SyncAppQuotes().handleLocalUpdate { (result) in
                NotificationTrigger().getNotified()
 /*               /*For Testing*/
                let content = UNMutableNotificationContent()
                content.title = "test notifaction"
                content.body = "Background Fetch Performing"
                content.sound = UNNotificationSound.default

                let tri = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let req  = UNNotificationRequest(identifier: "test_background", content: content, trigger: tri)

                UNUserNotificationCenter.current().add(req) { (error) in
                    print("error\(error.debugDescription)")
                    completionHandler(.failed)
                }
                /*Testing Ends*/*/
                completionHandler(.newData)
            }
        }
        
        
*/

        
    }
    
    // background
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    // The method will be called on the delegate only if the application is in the foreground.
    // If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented.
    // The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list.
    //This decision should be based on whether the information in the notification is otherwise visible to the user.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])// Will present an alert and will play a sound when a notification arrives
    }
}

extension Notification.Name {
  static let newPokemonFetched = Notification.Name("com.moodquotes.fetchQuotes")
}

extension UIApplication {
    static var release: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? "x.x"
    }
    static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String? ?? "x"
    }
    static var version: String {
        return "\(release).\(build)"
    }
}
