//
//  Onboarding_1ViewController.swift
//  句句
//
//  Created by Ben on 2020/11/22.
//

import UIKit

class Onboarding_1ViewController: UIViewController {

    @IBOutlet weak var timePIcker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.timePIcker.layer.cornerRadius = timePIcker.layer.borderWidth / 2
        
        // Set date to today's date
        let date = Calendar.current.date(bySettingHour: 9, minute: 00, second: 0, of: Date())!
        timePIcker.setDate(date, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    @IBAction func nextTapped(_ sender: Any) {
        saveTime()
    }
    @IBAction func skipTapped(_ sender: Any) {
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
