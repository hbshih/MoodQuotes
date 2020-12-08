//
//  Onboarding_1ViewController.swift
//  句句
//
//  Created by Ben on 2020/11/22.
//

import UIKit
import FirebaseAnalytics

class Onboarding_1ViewController: UIViewController {

    @IBOutlet weak var timePIcker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        if #available(iOS 14, *) {
            self.timePIcker.preferredDatePickerStyle = .inline
            self.timePIcker.layer.cornerRadius = timePIcker.layer.borderWidth / 2
            
        }else
        {
           // self.timePIcker.frame = CGRect(
        //    timePIcker.constraints.append(timePIcker.centerYAnchor.constraint(equalTo: self.view.centerYAnchor))
            timePIcker.datePickerMode = .time
        }
        

        // Set date to today's date
        let date = Calendar.current.date(bySettingHour: 9, minute: 00, second: 0, of: Date())!
        timePIcker.setDate(date, animated: false)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh-mm"
        let date_today = dateFormatter.string(from: timePIcker.date)
        Analytics.logEvent("onboarding_1_saved_time", parameters: ["noti_time": "\(date_today)"])
        
    }
    @IBAction func nextTapped(_ sender: Any) {
        
        
        Analytics.logEvent("onboarding_1_next_tapped", parameters: nil)
        
        saveTime()
    }
    @IBAction func skipTapped(_ sender: Any) {
        Analytics.logEvent("onboarding_1_skip_tapped", parameters: nil)
        saveTime()
    }
    
    func saveTime()
    {
        // Add next update date to user defaults
        let updateTime = Calendar.current.date(byAdding: .day, value: 1, to: timePIcker.date)
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(timePIcker.date, forKey: "updateTime")
        print("Next update date \(updateTime)")
    }
}
