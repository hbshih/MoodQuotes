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
        }else
        {
        
            backgroundColor.backgroundColor = UIColor(red: 239/255, green: 233/255, blue: 230/255, alpha: 1.0)
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setColor(color: backgroundColor.backgroundColor, forKey: "BackgroundColor")
            
        }
            
        // Do any additional setup after loading the view.
    }
    @IBAction func FinishProcessTapped(_ sender: Any) {
        
        
        
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
    
    func checkSegue()
    {
        if #available(iOS 14.0, *) {
           performSegue(withIdentifier: "showTutorialSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "homeSegue", sender: nil)
        }
    }
    
}
