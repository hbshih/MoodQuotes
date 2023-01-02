//
//  OnboardingStoryViewController.swift
//  句句
//
//  Created by Ben on 2021/4/11.
//

import UIKit
import AVFoundation
import WidgetKit
import FirebaseAnalytics

class OnboardingStoryViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var explationMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // imageView.alpha = 0.0
        
        backgroundView.backgroundColor = UIColor(red: 0.951708, green: 0.878031, blue: 0.87638, alpha: 1.0)
        self.imageView.alpha = 0.0
        self.imageView.isHidden = true
        self.explationMessage.alpha = 0.0
        
        
        // Set date to today's date
        let date = Calendar.current.date(bySettingHour: 9, minute: 00, second: 0, of: Date())!
        let updateTime = Calendar.current.date(byAdding: .day, value: 1, to: date)
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(updateTime, forKey: "updateTime")
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(updateTime, forKey: "updateTimeForWidget")
        print("Next update date \(updateTime)")
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2.0, delay: 1.5, options: .curveLinear) {
            // imageView.image = UIImage(named: "icon_gesture")
            self.explationMessage.text = "正在準備你的語錄⋯"
            self.explationMessage.alpha = 1.0
        } completion: { (true) in
            UIView.animate(withDuration: 0.5, delay: 2.0) {
                self.explationMessage.alpha = 0.0
                self.imageView.isHidden = false
            } completion: { (true) in
                UIView.animate(withDuration: 3.0) {
                    self.explationMessage.text = "準備好了!\n請搖搖手機"
                    self.imageView.alpha = 1.0
                    self.explationMessage.alpha = 1.0
                } completion: { (true) in
                    //
                }
                
            }
            
        }
        
        
        
        imageView.image = UIImage(named: "icon_gesture")
        
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: [.repeat, .autoreverse]) { [self] in
            self.imageView.transform = imageView.transform.rotated(by: .pi/6)
        } completion: { (true) in
            self.imageView.transform = self.imageView.transform.rotated(by: -(.pi/6))
        }
        
        let default_color = UIColor(red: 239/255, green: 216/255, blue: 216/255, alpha: 1.0)
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setColor(color: default_color, forKey: "BackgroundColor")
        
        if #available(iOS 14.0, *)
        {
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        imageView.layer.removeAllAnimations()
        
        if motion == .motionShake
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.imageView.alpha = 0.0
                self.explationMessage.alpha = 0.0
                
                
                
            }, completion: { (true) in
                UIView.animate(withDuration: 0.5, delay: 1.5, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.imageView.image = UIImage(named: "default_flower_story")
                    self.imageView.alpha = 1.0
                }) { (true) in
                    UIView.animate(withDuration: 0.5, delay: 2.0, options: UIView.AnimationOptions.curveEaseIn) {
                        self.explationMessage.text = "這是屬於你今天的植物，\n今天的語錄是⋯"
                        self.explationMessage.alpha = 1.0
                    } completion: { (true) in
                        sleep(4)
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
                
                let defaultFlowerImage = UIImage(named: "flower_10_babys breath_滿天星")
                let defaultFlowerName = "滿天星"
                
                flowerHandler().storeImage(image: defaultFlowerImage!, forKey: "FlowerImage", withStorageType: .userDefaults)
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(defaultFlowerName, forKey: "FlowerName")
                
                VC.defaultFlowerImage = defaultFlowerImage
                VC.defaultFlowerImageName = defaultFlowerName
                
                
                
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

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        
        return self
    }
}
