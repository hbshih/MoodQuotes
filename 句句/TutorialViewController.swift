//
//  TutorialViewController.swift
//  句句
//
//  Created by Ben on 2021/4/16.
//

import UIKit

class TutorialViewController: UIViewController {
    
    var navigateToHomeAfterDismiss = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(true, forKey: "NewUserAllSet_Ver 3.0")
        
        if navigateToHomeAfterDismiss
        {
            self.performSegue(withIdentifier: "homepageSegue", sender: nil)
           // navigationController?.popViewController(animated: true)
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
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
