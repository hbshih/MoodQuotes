//
//  UpdateTimeTableViewCell.swift
//  句句
//
//  Created by Ben on 2020/11/16.
//

import UIKit

class UpdateTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var timePicker: UIDatePicker!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        
        
        // 更新時間
        var components = Calendar.current.dateComponents([.hour, .minute], from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        components.hour = sender.date.hour
        components.minute = sender.date.minute
        print("New Update Time \(components.date!)")
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(components.date, forKey: "updateTime")
        
        // Reset Notification Time
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        let  aClass = NotificationTrigger()
        aClass.setupNotifications()
    }
    
    
}
