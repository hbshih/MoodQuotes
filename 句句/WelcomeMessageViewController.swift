//
//  WelcomeMessageViewController.swift
//  句句
//
//  Created by Ben on 2023/1/1.
//

import UIKit

class WelcomeMessageViewController: UIViewController {
    
    @IBOutlet weak var buttonBackground: UIView!
    @IBOutlet weak var triggerButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var explationMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.resetStandardUserDefaults()
        // imageView.alpha = 0.0
        
        triggerButton.alpha = 0.0
        
        buttonBackground.alpha = 0.0
        
        backgroundView.backgroundColor = UIColor(red: 0.951708, green: 0.878031, blue: 0.87638, alpha: 1.0)
        self.explationMessage.alpha = 0.0
        
        
        // set default font
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set("jf-openhuninn-1.1", forKey: "userFont")
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2.0, delay: 1.5, options: .curveLinear) {
            // imageView.image = UIImage(named: "icon_gesture")
            self.explationMessage.text = "歡迎來到為你打造的語錄 App"
            self.explationMessage.alpha = 1.0
        } completion: { (true) in
            UIView.animate(withDuration: 0.5, delay: 2.0) {
                self.explationMessage.alpha = 0.0
            } completion: { (true) in
                UIView.animate(withDuration: 3.0) {
                    self.explationMessage.text = "從今天起，\n你每天都將獲得一句語錄\n及一株陪伴你的植物。"
                    self.explationMessage.alpha = 1.0
                } completion: { (true) in
                    UIView.animate(withDuration: 0.5, delay: 2.0) {
                        self.explationMessage.alpha = 0.0
                    } completion: { (true) in
                        UIView.animate(withDuration: 3.0) {
                            self.explationMessage.text = "在那之前，我需要先好好認識你"
                            self.explationMessage.alpha = 1.0
                            self.buttonBackground.alpha = 1.0
                            self.triggerButton.alpha = 1.0
                        }
                        
                    }
                    
                }
                
            }
        }
    }
    @IBAction func triggerButton(_ sender: Any) {
        performSegue(withIdentifier: "welcomeSegue", sender: nil)
    }
}
