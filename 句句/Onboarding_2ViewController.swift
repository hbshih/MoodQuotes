//
//  Onboarding_2ViewController.swift
//  句句
//
//  Created by Ben on 2020/11/22.
//

import UIKit
import FirebaseAnalytics

class Onboarding_2ViewController: UIViewController {

    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var gray: UIButton!
    @IBOutlet weak var nav_view: UIView!
    var currentSelectedTag = 0
    var fromSetting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nav_view.isHidden = true
        
        if fromSetting
        {
            skipButton.layer.opacity = 0.0
            nav_view.isHidden = false
            actionButton.setTitle("儲存", for: .normal)
        }
    
        // Do any additional setup after loading the view.
    }
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func nextTapped(_ sender: Any) {
        
        // need to pay
        if currentSelectedTag == 1 && !global_paid_user
        {
            performSegue(withIdentifier: "purchase_segue", sender: nil)
        }else
        {
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setColor(color: backgroundView.backgroundColor, forKey: "BackgroundColor")
            if actionButton.currentTitle == "下一步"
            {
                performSegue(withIdentifier: "selectedFont_segue", sender: nil)
            }else
            {
                self.dismiss(animated: true)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "purchase_segue"
        {
            if let vc = segue.destination as? PurchaseViewController
            {
                vc.purchaseTitle = "獲得更多背景顏色"
                vc.purchaseDescription = "免費試用三十天，獲得更多功能"
            }
        }
        
    }
    
    
    @IBAction func ColorPicked(_ sender: UIButton) {
        
        print(backgroundView.backgroundColor)
        backgroundView.backgroundColor = sender.backgroundColor
        currentSelectedTag = sender.tag
        
    }
    @IBAction func skip(_ sender: Any) {
        
        Analytics.logEvent("onboarding_2_skip_tapped", parameters: nil)
        
        if backgroundView.backgroundColor != .systemBackground
        {
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setColor(color: backgroundView.backgroundColor, forKey: "BackgroundColor")
        }else
        {
            let default_color = UIColor(red: 0.951708, green: 0.878031, blue: 0.87638, alpha: 1.0)
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setColor(color: default_color, forKey: "BackgroundColor")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
          Analytics.logEvent("onboarding_2_color_selected", parameters: ["color": "\(backgroundView.backgroundColor)"])
    }
    
}
