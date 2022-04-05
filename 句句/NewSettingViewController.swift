//
//  NewSettingViewController.swift
//  句句
//
//  Created by Ben on 2022/3/29.
//

import UIKit
import PopupDialog
import SwiftyStoreKit
import SwiftMessages

class NewSettingViewController: UIViewController {

    @IBOutlet weak var notificationToggle: UISwitch!
    @IBOutlet weak var timePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // update timepicker
        if let notificationDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") as? Date
        {
            // Set Notification Date
            timePicker.date = notificationDate
            let date = Calendar.current.date(bySettingHour: notificationDate.hour, minute: notificationDate.minute, second: 0, of: Date())!
            timePicker.setDate(date, animated: false)
        }else
        {
            let date = Calendar.current.date(bySettingHour: 9, minute: 00, second: 0, of: Date())!
            timePicker.setDate(date, animated: false)
        }
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        //更新TimePicker
        timePicker.setDate(sender.date, animated: true)
        
        if #available(iOS 14.0, *) {
            timePicker.setDate(sender.date, animated: true)
        }
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh-mm"
        let date_today = dateFormatter.string(from: sender.date)
        
      //  Analytics.logEvent("set_vc_update_time", parameters: ["updated_time": "\(date_today)"])
        
        
        // 更新時間
        let date = Calendar.current.date(bySettingHour: sender.date.hour, minute: sender.date.minute, second: 0, of: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)!

        print("New Update Time \(date)")
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(date, forKey: "updateTime")
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(date, forKey: "updateTimeForWidget")
        alertViewHandler().alert(title: "更新時間設定完成", body: "", iconText: "🍻")
        
        // Reset Notification Time
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        NotificationTrigger().notifyQuoteHasChanged()
    }
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func adjustBackgroundColor(_ sender: Any) {
        
        /*
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
            
         //   Analytics.logEvent("set_vc_update_color", parameters: ["updated_color": "\(ratingVC.exampleBackground.backgroundColor)"])
            
            print("reload color")
            if let vc = UIApplication.topViewController() as? SettingViewController
            {
                print("VC")
                vc.tableview.reloadData()
            }
            if #available(iOS 14.0, *)
            {
                //WidgetCenter.shared.reloadAllTimelines()
            }
        }
        
        buttonTwo.backgroundColor = .systemGray6
        buttonTwo.titleColor = .systemGray
     //   buttonTwo.titleLabel.
        
        
        
        popup.addButtons([buttonTwo])
        
        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
         */
    }
    
    @IBAction func adjustFont(_ sender: Any) {
        
        /*
        // Create a custom view controller
        let ratingVC = UpdateFontViewController(nibName: "UpdateFontViewController", bundle: nil)
            
        //    RatingViewController(nibName: "RatingViewController", bundle: nil)
        
        

        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        
        
        
    
        // Create second button
        let buttonTwo = DefaultButton(title: "儲存", height: 60) {
            
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(ratingVC.selectedFont, forKey: "userFont")

        }
        
        buttonTwo.backgroundColor = .systemGray6
        buttonTwo.titleColor = .systemGray
     //   buttonTwo.titleLabel.
        
        
        
        popup.addButtons([buttonTwo])
        
        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
         */
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func restorePurchase(_ sender: Any) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                alertViewHandler().control(title: "沒有什麼可以回復的", body: "", iconText: "")
                print("Restore Failed: \(results.restoreFailedPurchases)")
                global_paid_user = true
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(true, forKey: "isPaidUser")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
            }
            else {
                alertViewHandler().control(title: "沒有什麼可以回復的", body: "", iconText: "")
                print("Nothing to Restore")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adjustBackground_segue"
        {
            if let vc = segue.destination as? Onboarding_2ViewController
            {
                vc.fromSetting = true
            }
        }
        
        if segue.identifier == "adjustText_segue"
        {
            if let vc = segue.destination as? OnboardingFontViewController
            {
                vc.fromSetting = true
            }
        }
    }
    
}
