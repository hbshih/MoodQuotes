//
//  NotificationTableViewCell.swift
//  句句
//
//  Created by Ben on 2020/11/16.
//

import UIKit
import NotificationCenter

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var notification: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func notification_toggled(_ sender: Any) {
    
    }
    @IBAction func notificationToggled(_ sender: UISwitch) {
        
        if sender.isOn
        {
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setValue(true, forKey: "isNotificationOn")
        }else
        {
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setValue(false, forKey: "isNotificationOn")
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
        
    }
}
