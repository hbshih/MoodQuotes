//
//  HandleNewUserViewController.swift
//  句句
//
//  Created by Ben on 2020/11/27.
//

import UIKit

class HandleNewUserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //  print(UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.value(forKey: "updateTime"))
        
        if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") != nil
        {
            performSegue(withIdentifier: "homeSegue", sender: nil)
        }else
        {
            performSegue(withIdentifier: "onboardingSegue", sender: nil)
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
