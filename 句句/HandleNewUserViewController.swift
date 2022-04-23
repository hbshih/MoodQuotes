//
//  HandleNewUserViewController.swift
//  句句
//
//  Created by Ben on 2020/11/27.
//

import UIKit
import FirebaseAnalytics

class HandleNewUserViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  print("Running Version: \(UIApplication.version())")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //check if have data before
        if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "NewUserAllSet_Ver 3.0") != nil ||  (UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote")) != nil
        {
            performSegue(withIdentifier: "homeSegue", sender: nil)
        }else
        {
            performSegue(withIdentifier: "onboardSegue", sender: nil)
        }
        
        if appVersionNumberHandler().hasUpdatedSinceLastRun()
        {
            // Do something
        }
        
    }
}
