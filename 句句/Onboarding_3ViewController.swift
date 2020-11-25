//
//  Onboarding_3ViewController.swift
//  句句
//
//  Created by Ben on 2020/11/22.
//

import UIKit
import NotificationCenter

class Onboarding_3ViewController: UIViewController {

    @IBOutlet var backgroundColor: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let color = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.colorForKey(key: "BackgroundColor")
        {
            print(color)
            backgroundColor.backgroundColor = color
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func AcceptedNotification(_ sender: Any) {
        
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setValue(true, forKey: "isNotificationOn")
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                let  aClass = NotificationTrigger()
                aClass.setupNotifications()
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
