//
//  OnboardingStoryViewController.swift
//  句句
//
//  Created by Ben on 2021/4/11.
//

import UIKit
import AVFoundation
import WidgetKit

class OnboardingStoryViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var explationMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageView.image = UIImage(named: "icon_gesture")
        explationMessage.text = "嗨，看看今日的句子與植物吧，請搖搖手機。"
        
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
                    self.imageView.image = UIImage(named: "default_flower")
                    self.imageView.alpha = 1.0
                }) { (true) in
                    UIView.animate(withDuration: 0.5, delay: 1.0, options: UIView.AnimationOptions.curveEaseIn) {
                        self.explationMessage.text = "這是屬於您今日的盆栽，\n它想告訴您"
                        self.explationMessage.alpha = 1.0
                    } completion: { (true) in
                        sleep(2)
                            self.performSegue(withIdentifier: "homepageSegue", sender: nil)
                    }

                }
            })
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homepageSegue"
        {
            if let VC = segue.destination as? ViewController
            {
                let defaultQuote = "星星發亮是為了讓每一個人有一天都能找到屬於自己的星星"
                let defaultAuthor = "小王子"
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(defaultQuote, forKey: "Quote")
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(defaultAuthor, forKey: "Author")
                VC.defaultQuote = defaultQuote
                VC.defaultAuthor = defaultAuthor
                
                let defaultFlowerImage = UIImage(named: "default_flower")
                let defaultFlowerName = "滿天星"
                
                flowerHandler().storeImage(image: defaultFlowerImage!, forKey: "FlowerImage", withStorageType: .userDefaults)
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(defaultFlowerName, forKey: "FlowerName")
                
                VC.defaultFlowerImage = defaultFlowerImage
                VC.defaultFlowerImageName = defaultFlowerName
                
                // Set date to today's date
                let date = Calendar.current.date(bySettingHour: 9, minute: 00, second: 0, of: Date())!
                let updateTime = Calendar.current.date(byAdding: .day, value: 1, to: date)
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(updateTime, forKey: "updateTime")
                print("Next update date \(updateTime)")
                
                //更新Widget
                if #available(iOS 14.0, *) {
                    WidgetCenter.shared.reloadAllTimelines()
                } else {
                    // Fallback on earlier versions
                }
              //  let defaultFlowerName = ""
            }
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
