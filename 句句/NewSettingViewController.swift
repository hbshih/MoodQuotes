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
import UserNotifications
import Instabug

class NewSettingViewController: UIViewController {

    @IBOutlet weak var purchaseCell: UIView!
    @IBOutlet weak var notificationToggle: UISwitch!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var fontAppearanceButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Instabug.setLocale(.chineseTaiwan)

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
        
        if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.bool(forKey: "isNotificationOn")
        {
            notificationToggle.isOn = true
        }else
        {
            notificationToggle.isOn = false
            
        }
        
        fontAppearanceButton.titleLabel?.font = Display_Font(font_size: 12).getUIFont()
        
        if global_paid_user
        {
            purchaseCell.isHidden = true
        }
        
        
        var seeInstructionCount = 0
        
        if let counter = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.integer(forKey: "seeWidgetInstruction") as? Int
        {
            
            if counter != nil
            {
                seeInstructionCount = counter
                //old user
                print("counter is \(counter)")
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set((counter + 1), forKey: "seeWidgetInstruction")
            }else
            {
                //new user
                print("counter is nil")
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(1, forKey: "seeWidgetInstruction")
            }
        }
        
        
    }
    @IBAction func feedback_button(_ sender: Any) {
        Instabug.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presentingViewController?.viewWillAppear(true)
    }
    
    @IBAction func notificationToggled(_ sender: UISwitch) {
        //Analytics.logEvent("set_vc_adjust_noti", parameters: ["notification_on": "\(sender.isOn)"])
        
        if sender.isOn
        {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                guard granted else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                  //  let  aClass = NotificationTrigger()
                  //  aClass.setupNotifications()
                    
                    NotificationTrigger().notifyQuoteHasChanged()
                }
            }
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setValue(true, forKey: "isNotificationOn")
        //    let  aClass = NotificationTrigger()
          //  aClass.setupNotifications()
        }else
        {
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setValue(false, forKey: "isNotificationOn")
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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
    @IBAction func restorePurchase(_ sender: Any) {
        
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                alertViewHandler().control(title: "恢復購買失敗", body: "如有問題請和開發團隊聯絡", iconText: "🍻")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                global_paid_user = true
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(true, forKey: "isPaidUser")
                alertViewHandler().control(title: "恢復購買成功", body: "可以繼續使用完整版植語錄囉！", iconText: "🍻")
            }
            else {
                print("Nothing to Restore")
                alertViewHandler().control(title: "恢復購買失敗", body: "如有問題請和開發團隊聯絡", iconText: "🍻")
            }
        }
        
        
        
    }
    @IBAction func dismissTapped(_ sender: Any) {
        //NotificationCenter.default.post(name: Notification.Name("homepageRefresh"), object: nil)
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
