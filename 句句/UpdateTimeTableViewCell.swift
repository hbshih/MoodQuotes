//
//  UpdateTimeTableViewCell.swift
//  句句
//
//  Created by Ben on 2020/11/16.
//

import UIKit
import FirebaseAnalytics

class UpdateTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var timePickeriOS13: UIDatePicker!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if #available(iOS 14.0, *) {
            timePicker.isHidden = false
            timePickeriOS13.isHidden = true
        } else {
            timePicker.sizeToFit()
            timePicker.isHidden = true
            timePickeriOS13.isHidden = false
        }
        
        
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func changeTimeTapped(_ sender: Any) {
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        
        //更新TimePicker
        timePicker.setDate(sender.date, animated: true)
        
        if #available(iOS 14.0, *) {
            timePicker.setDate(sender.date, animated: true)
        } else {
            timePickeriOS13.setDate(sender.date, animated: true)
        }
        
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh-mm"
        let date_today = dateFormatter.string(from: sender.date)
        
        Analytics.logEvent("set_vc_update_time", parameters: ["updated_time": "\(date_today)"])
        
        
        // 更新時間
        let date = Calendar.current.date(bySettingHour: sender.date.hour, minute: sender.date.minute, second: 0, of: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)!

        print("New Update Time \(date)")
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(date, forKey: "updateTime")
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(date, forKey: "updateTimeForWidget")
        
        // Reset Notification Time
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        NotificationTrigger().notifyQuoteHasChanged()
    }
    
    
}
