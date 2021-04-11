//
//  OnboardingStoryViewController.swift
//  句句
//
//  Created by Ben on 2021/4/11.
//

import UIKit
import AVFoundation

class OnboardingStoryViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var explationMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageView.image = UIImage(named: "icon_gesture")
        explationMessage.text = "看看今日的句子與植物吧，請搖搖手機。"
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            UIView.animate(withDuration: 0.5, delay: 1.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.imageView.alpha = 0.0
                self.explationMessage.alpha = 0.0
            }, completion: { (true) in
                UIView.animate(withDuration: 0.5, delay: 1.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.imageView.image = UIImage(named: "example_plant")
                    self.explationMessage.text = "這是屬於您今日的盆栽，\n它想告訴您"
                    self.imageView.alpha = 1.0
                    self.explationMessage.alpha = 1.0
                }, completion: nil)
            })
            
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
