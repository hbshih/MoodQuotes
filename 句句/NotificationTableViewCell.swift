//
//  NotificationTableViewCell.swift
//  句句
//
//  Created by Ben on 2020/11/16.
//

import UIKit
import NotificationCenter
import FirebaseAnalytics

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.bool(forKey: "isNotificationOn")
        {
            `switch`.isOn = true
        }else
        {
            `switch`.isOn = false
            
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func notification_toggled(_ sender: Any) {
    
    }
    @IBAction func notificationToggled(_ sender: UISwitch) {
        
        Analytics.logEvent("set_vc_adjust_noti", parameters: ["notification_on": "\(sender.isOn)"])
        
        if sender.isOn
        {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                guard granted else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    let  aClass = NotificationTrigger()
                    aClass.setupNotifications()
                }
            }
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setValue(true, forKey: "isNotificationOn")
        //    let  aClass = NotificationTrigger()
          //  aClass.setupNotifications()
        }else
        {
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setValue(false, forKey: "isNotificationOn")
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
        
    }
}
