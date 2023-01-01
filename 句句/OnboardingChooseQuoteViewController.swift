//
//  OnboardingChooseQuoteViewController.swift
//  句句
//
//  Created by Ben on 2023/1/1.
//

import UIKit
import FirebaseAnalytics
import Firebase

class OnboardingChooseQuoteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func quoteTapped(_ sender: UIButton) {
        
        var val = ""
        
        switch sender.tag {
        case 0:
            val = "啟發人心"
        case 1:
            val = "負能量"
        case 2:
            val = "愛情"
        default:
            val = "nothing"
        }
        
        Analytics.logEvent("typeOfQuote", parameters: ["Type": val])
        
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(val, forKey: "typeOfQuote")
        
        performSegue(withIdentifier: "selectColorSegue", sender: nil)
        
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
