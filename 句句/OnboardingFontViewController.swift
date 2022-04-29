//
//  OnboardingFontViewController.swift
//  句句
//
//  Created by Ben on 2022/3/30.
//

import UIKit
import WidgetKit

class OnboardingFontViewController: UIViewController {

    @IBOutlet weak var nav_view: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var exampleView: UIView!
    @IBOutlet weak var exampleLabel: UILabel!
    
    var fromSetting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let color = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.colorForKey(key: "BackgroundColor")
        {
            exampleView.backgroundColor = color
        }
        // Do any additional setup after loading the view.
        
        if fromSetting
        {
            skipButton.layer.opacity = 0.0
            nav_view.isHidden = false
            actionButton.setTitle("儲存", for: .normal)
        }
        
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
    var selectedFont = "jf-openhuninn-1.1"
    
    @IBAction func fontSelected(_ sender: UIButton) {
        exampleLabel.text = "真正重要的事物，用肉眼是看不見的。只有用心，才能看得清楚。"
        exampleLabel.font = sender.titleLabel?.font
        //selectedFont = sender.titleLabel?.font
        switch sender.tag {
        case 1:
            selectedFont = "I.PenCrane-B"
        case 2:
            selectedFont = "JasonHandwriting5"
        case 3:
            selectedFont = "I.Ngaan"
        case 4:
            selectedFont = "GenRyuMinTW-M"
        case 5:
            selectedFont = "jf-openhuninn-1.1"
        default:
            print("null")
        }
    }
    
    func checkIfPayFont() -> Bool
    {
        if selectedFont == "jf-openhuninn-1.1" || selectedFont == "I.PenCrane-B"
        {
            return false
        }else
        {
            return true
        }
    }
    
    
    
    @IBAction func fontSelectedTapped(_ sender: Any) {
    // need to pay
    if checkIfPayFont() && !global_paid_user
    {
        performSegue(withIdentifier: "purchase_segue", sender: nil)
    }else
    {
        WidgetCenter.shared.reloadAllTimelines()
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(selectedFont, forKey: "userFont")
        if actionButton.currentTitle == "下一步"
        {
            performSegue(withIdentifier: "selectUpdateTime_segue", sender: nil)
        }else
        {
            alertViewHandler().alert(title: "字體更新完成", body: "", iconText: "🍻")
            self.dismiss(animated: true)
        }
    }
    
}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "purchase_segue"
    {
        if let vc = segue.destination as? PurchaseViewController
        {
            vc.purchaseTitle = "獲得更多字體"
            vc.purchaseDescription = "免費試用三十天，獲得更多功能"
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
