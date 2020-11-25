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
        
        let date = Calendar.current.date(bySettingHour: 9, minute: 00, second: 0, of: Date())!
            
        timePicker.setDate(date, animated: false)
        
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(sender.date, forKey: "updateTime")
    }
}
