//
//  OnboardingFontViewController.swift
//  句句
//
//  Created by Ben on 2022/3/30.
//

import UIKit

class OnboardingFontViewController: UIViewController {

    @IBOutlet weak var exampleView: UIView!
    @IBOutlet weak var exampleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    var selectedFont = "jf-openhuninn-1.1"
    
    @IBAction func fontSelected(_ sender: UIButton) {
        exampleLabel.text = sender.currentTitle
        exampleLabel.font = sender.titleLabel?.font
        switch sender.tag {
        case 1:
            selectedFont = "I.Ngaan"
        case 2:
            selectedFont = "JasonHandwriting5"
        case 3:
            selectedFont = "I.PenCrane-B"
        case 4:
            selectedFont = "QIJIC"
        case 5:
            selectedFont = "jf-openhuninn-1.1"
        default:
            print("null")
        }
    }
    
    @IBAction func fontSelectedTapped(_ sender: Any) {
        
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(selectedFont, forKey: "userFont")
        
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
