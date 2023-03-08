//
//  TutorialViewController.swift
//  句句
//
//  Created by Ben on 2021/4/16.
//

import UIKit
import FirebaseAnalytics
import WidgetKit

class TutorialViewController: UIViewController {
    
    var navigateToHomeAfterDismiss = false
    var navigateToHome = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        
        Analytics.logEvent("tutorial_VC_closed", parameters: nil)
        
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(true, forKey: "widgetTutorialSeen")
        
        if !navigateToHome
        {
            self.dismiss(animated: true, completion: nil)
        }else
        {
            performSegue(withIdentifier: "homepageSegue", sender: nil)
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
