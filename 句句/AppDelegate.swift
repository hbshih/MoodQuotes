//
//  AppDelegate.swift
//  句句
//
//  Created by Ben on 2020/11/14.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging
import FBSDKCoreKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        /*
         UIApplication.shared.backgroundTimeRemaining
         UIApplication.shared.setMinimumBackgroundFetchInterval(1800)
         */
        UIApplication.shared.setMinimumBackgroundFetchInterval(1800)
        registerBackgroundTasks()
        
        // Facebook Required
        let _ = ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        NotificationCenter.default.addObserver(forName:UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { (_) in
            // Your Code here
            print("in background")
            self.submitBackgroundTasks()
        }
        return true
    }
    
    func registerBackgroundTasks() {
        // Declared at the "Permitted background task scheduler identifiers" in info.plist
        let backgroundAppRefreshTaskSchedulerIdentifier = "com.example.MyID"
        //     let backgroundProcessingTaskSchedulerIdentifier = "com.example.fooBackgroundProcessingIdentifier"
        
        // Use the identifier which represents your needs
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundAppRefreshTaskSchedulerIdentifier, using: nil) { (task) in
            
            print("BackgroundAppRefreshTaskScheduler is executed NOW!")
            print("Background time remaining: \(UIApplication.shared.backgroundTimeRemaining)s")
            task.expirationHandler = {
                task.setTaskCompleted(success: false)
            }
            
            // Do some data fetching and call setTaskCompleted(success:) asap!
            let isFetchingSuccess = true
            task.setTaskCompleted(success: isFetchingSuccess)
            
            DispatchQueue.main.async{
                SyncAppQuotes().handleLocalUpdate { (result) in
                    NotificationTrigger().getNotified()
                }
            }
        }
    }
    
    func submitBackgroundTasks() {
        // Declared at the "Permitted background task scheduler identifiers" in info.plist
        if #available(iOS 13.0, *) {
            do {
                let request = BGAppRefreshTaskRequest(identifier: "com.example.MyID")
                request.earliestBeginDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())
                try BGTaskScheduler.shared.submit(request)
                
                print("Submitted task request")
            } catch {
                print("Failed to submit BGTask")
            }
        }
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // FETCH DATA and REFRESH NOTIFICATIONS
        // We need to do this to ensure the current week value is updated to either 1 or 0
        // You will need to delete all notifications with same same category first else your going to be getting both weeks notifications
        
        print("fetch for something")
        
        DispatchQueue.main.async{
            SyncAppQuotes().handleLocalUpdate { (result) in
                NotificationTrigger().getNotified()
            }
        }

        /*For Testing*/
        let content = UNMutableNotificationContent()
        content.title = "test notifaction"
        content.body = "Background Fetch Performing"
        content.sound = UNNotificationSound.default

        let tri = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let req  = UNNotificationRequest(identifier: "test_background", content: content, trigger: tri)

        UNUserNotificationCenter.current().add(req) { (error) in
            print("error\(error )")
        }
        /*Testing Ends*/
        
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
