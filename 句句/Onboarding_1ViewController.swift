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

        let date = Calendar.current.date(bySettingHour: 9, minute: 00, second: 0, of: Date())!
            
        timePIcker.setDate(date, animated: false)
        
    }
    
  //  view
    
    override func viewWillDisappear(_ animated: Bool) {
        print("will")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setValue(timePIcker.date, forKey: "Time Picker")
        print("did")
        
        // Add next update date to user defaults
        let updateTime = Calendar.current.date(byAdding: .day, value: 1, to: timePIcker.date)
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(timePIcker.date, forKey: "updateTime")
        print("current date \(timePIcker.date)")
        print("update date \(updateTime)")
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
