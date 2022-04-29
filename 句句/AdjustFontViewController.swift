//
//  AdjustFontViewController.swift
//  句句
//
//  Created by Ben on 2022/4/1.
//

import UIKit
import FirebaseAnalytics

class AdjustFontViewController: UIViewController {


    @IBOutlet weak var exampleView: UIView!
    @IBOutlet weak var exampleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent("view_font_page", parameters: nil)
        
        if let color = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.colorForKey(key: "BackgroundColor")
        {
            exampleView.backgroundColor = color
        }

        // Do any additional setup after loading the view.
    }
    var selectedFont = "jf-openhuninn-1.1"
    
    @IBAction func fontSelected(_ sender: UIButton) {
        exampleLabel.text = "真正重要的事物，用肉眼是看不見的。只有用心，才能看得清楚。"
        exampleLabel.font = sender.titleLabel?.font
        switch sender.tag {
        case 1:
            selectedFont = "I.Ngaan"
        case 2:
            selectedFont = "JasonHandwriting5"
        case 3:
            selectedFont = "I.PenCrane-B"
        case 4:
            selectedFont = "GenRyuMin-M"
        case 5:
            selectedFont = "jf-openhuninn-1.1"
        default:
            print("null")
        }
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func fontSelectedTapped(_ sender: Any) {
        
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(selectedFont, forKey: "userFont")
        Analytics.logEvent("font_selected", parameters: ["font": selectedFont])
        
        alertViewHandler().alert(title: "字體更新完成", body: "", iconText: "")
        
        self.dismiss(animated: true)
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
