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
        
        //  print(UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.value(forKey: "updateTime"))
        
        if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") != nil
        {
           // performSegue(withIdentifier: "homeSegue", sender: nil)
        }
        
    }
    
  //  view
    
    override func viewWillDisappear(_ animated: Bool) {
        print("will")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setValue(timePIcker.date, forKey: "Time Picker")
        print("did")
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(timePIcker.date, forKey: "updateTime")
        
     //   setValue(timePIcker.date, forKey: "updateTime")
        
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
