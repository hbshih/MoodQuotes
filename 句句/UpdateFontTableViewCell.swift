//
//  UpdateBackgroundColorTableViewCell.swift
//  句句
//
//  Created by Ben on 2020/11/16.
//

import UIKit
import PopupDialog
import WidgetKit
import FirebaseAnalytics
import SwiftUI
import JuiceUI

class UpdateFontTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var actionButton: UIButton!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func changeFontTapped(_ sender: Any) {
        
     //   present(fontPicker, animated: true)
        UIApplication.topViewController()?.present(fontPicker, animated: true, completion: nil)
    }
    
    let fontPicker = UIFontPickerViewController()
    
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        
    guard let descriptor = viewController.selectedFontDescriptor else { return }
    let font = UIFont(descriptor: descriptor, size: 36)
        actionButton.setTitle("done", for: .normal)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected font \(pickerData[row])")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Connect data:
     //   self.fontPicker.delegate = self
      //  self.fontPicker.dataSource = self
        
        var pickerData = ["華康", "惠文", "random"]
        let config = UIFontPickerViewController.Configuration()
    }
    
    var pickerData: [String] = [String]()
    

  //  @IBOutlet weak var fontPicker: UIPickerView!
    @IBOutlet weak var backgrundColor: UIButton!
    @IBAction func backgroundColor(_ sender: Any) {
        
        // Create a custom view controller
        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)
        
        

        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        
        
        
    
        // Create second button
        let buttonTwo = DefaultButton(title: "儲存", height: 60) {
       //     self.label.text = "You rated \(ratingVC.cosmosStarRating.rating) stars"
            
            let defaults = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!
            
            defaults.setColor(color: ratingVC.exampleBackground.backgroundColor, forKey: "BackgroundColor")
            
            Analytics.logEvent("set_vc_update_color", parameters: ["updated_color": "\(ratingVC.exampleBackground.backgroundColor)"])
            
            print("reload color")
            if let vc = UIApplication.topViewController() as? SettingViewController
            {
                print("VC")
                vc.tableview.reloadData()
            }
            if #available(iOS 14.0, *)
            {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        
        buttonTwo.backgroundColor = .systemGray6
        buttonTwo.titleColor = .systemGray
     //   buttonTwo.titleLabel.
        
        
        
        popup.addButtons([buttonTwo])
        
        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

