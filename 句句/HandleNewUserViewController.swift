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
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("loading")
        
        //check if have data before
        if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "NewUserAllSet") != nil
        {
            print("old user")
            performSegue(withIdentifier: "homeSegue", sender: nil)
        }else
        {
            print("new user")
          //  performSegue(withIdentifier: "onboardSegue", sender: nil)
            performSegue(withIdentifier: "onboardSegue", sender: nil)
        //    self.present(OnboardingStoryViewController(), animated: true, completion: nil)
        }
    }
}
