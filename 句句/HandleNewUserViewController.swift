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
        
        print("Running Version: \(UIApplication.version())")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("loading")
        
        if hasAppBeenUpdatedSinceLastRun()
        {
            //
        }
        
        //check if have data before
        if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "NewUserAllSet_Ver 3.0") != nil ||  (UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote")) != nil
        {
            print("old user")
          //  UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(true, forKey: "NewUserAllSet_Ver 3.0")
            performSegue(withIdentifier: "homeSegue", sender: nil)
            Analytics.logEvent("handleNewUser_VC_old_user", parameters: nil)
            
        }else
        {
            print("new user")
            performSegue(withIdentifier: "onboardSegue", sender: nil)
            Analytics.logEvent("handleNewUser_VC_new_user", parameters: nil)
        }
    }
    
    func hasAppBeenUpdatedSinceLastRun() -> Bool {
        var bundleInfo = Bundle.main.infoDictionary!
        if let currentVersion = bundleInfo["CFBundleShortVersionString"] as? String {
            
            let defaults = UserDefaults.standard
            var array = defaults.array(forKey: "SavedIntArray")  as? [Double] ?? [Double]()
            
            print("current version \(currentVersion)")
            
            if !array.contains(Double(currentVersion)!)
            {
                array.append(Double(currentVersion)!)
            }
            
            defaults.set(array, forKey: "SavedIntArray")
            
            print("version list \(array)")
            
            let userDefaults = UserDefaults.standard
            if userDefaults.string(forKey: "currentVersion") == (currentVersion) {
                return false
            }
            userDefaults.set(currentVersion, forKey: "currentVersion")
            userDefaults.synchronize()
            return true
        }
        return false;
    }
}
