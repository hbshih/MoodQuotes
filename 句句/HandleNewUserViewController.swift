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
        
        //check if have data before
        if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") != nil
        {
            performSegue(withIdentifier: "homeSegue", sender: nil)
        }else
        {
            performSegue(withIdentifier: "onboardSegue", sender: nil)
        }
    }
}
