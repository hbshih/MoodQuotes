//
//  AdjustBackgroundColorViewController.swift
//  句句
//
//  Created by Ben on 2022/4/1.
//

import UIKit

class AdjustBackgroundColorViewController: UIViewController {


    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var gray: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ColorPicked(_ sender: UIButton) {
        
        print(backgroundView.backgroundColor)
        backgroundView.backgroundColor = sender.backgroundColor
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setColor(color: backgroundView.backgroundColor, forKey: "BackgroundColor")
    }
    @IBAction func skip(_ sender: Any) {
        
      //  Analytics.logEvent("onboarding_2_skip_tapped", parameters: nil)
        
        if backgroundView.backgroundColor != .systemBackground
        {
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setColor(color: backgroundView.backgroundColor, forKey: "BackgroundColor")
        }else
        {
            let default_color = UIColor(red: 0.951708, green: 0.878031, blue: 0.87638, alpha: 1.0)
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setColor(color: default_color, forKey: "BackgroundColor")
        }
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    
    @IBAction func saveTapped(_ sender: Any) {
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setColor(color: backgroundView.backgroundColor, forKey: "BackgroundColor")
        
        alertViewHandler().alert(title: "背景更新完成", body: "", iconText: "")
        
        self.dismiss(animated: true)
    }
    

}
