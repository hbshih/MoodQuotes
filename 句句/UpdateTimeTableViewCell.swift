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
        
        print(timePicker.date)
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func changeTimeTapped(_ sender: Any) {
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        
        timePicker.setDate(sender.date, animated: true)
        
       // print("set date \(sender.date)")
        
        var components = Calendar.current.dateComponents([.hour, .minute], from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        components.hour = sender.date.hour
        components.minute = sender.date.minute
        
        let dateTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        
        print(Calendar.current.date(bySettingHour: sender.date.hour, minute: sender.date.minute, second: 0, of: dateTomorrow ))
        
       // print("update time \(components.date ?? <#default value#>)")
        
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(components.date, forKey: "updateTime")
        
        //print(sender.date)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        let  aClass = NotificationTrigger()
        aClass.setupNotifications()
        
        
        
    }
    
    
}
