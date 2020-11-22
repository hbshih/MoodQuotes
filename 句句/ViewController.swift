//
//  ViewController.swift
//  句句
//
//  Created by Ben on 2020/11/14.
//

import UIKit
import FirebaseDatabase
import UserNotifications
import Firebase
import FirebaseMessaging

var global_quote: String = ""

class ViewController: UIViewController, MessagingDelegate {
    
    @IBOutlet weak var frontQuote: UILabel!
    @IBOutlet weak var hiddenQuote: UILabel!
    @IBOutlet weak var screenView: UIView!
    @IBOutlet weak var backgroundHideenView: UIStackView!
    @IBOutlet weak var hiddenQuoteAdder: UILabel!
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
            
          //  self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
          }
        }
        
        let font = Display_Font(font_size: 36).getUIFont()
        hiddenQuote.font = font
        hiddenQuoteAdder.font = font
        frontQuote.font = font
        
        
        let content = UNMutableNotificationContent()
        content.title = "test notifaction"
        content.body = "test notification after 5 second"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        let request  = UNNotificationRequest(identifier: "testidentifire", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            print("error\(error )")

        }
        
        ref = Database.database().reference()
        
        DispatchQueue.main.async { [self] in
            //  let userID = Auth.auth().currentUser?.uid
            self.ref.child("Quote of the Day").observe(.value) { (snapshot) in
                if let value = snapshot.value as? NSDictionary
                {
                    
                    if let quote = value["Quote"] as? String
                    {
                        self.quote = quote
                        if let author = value["Author"] as? String
                        {
                            self.author = author
                            frontQuote.text = self.quote + "\n" + "— " + self.author
                            hiddenQuote.text = self.quote + "\n" + "— " + self.author
                            global_quote = frontQuote.text!
                        }
                    }
                }
            }
            
        }
        
    }
    
    var ref: DatabaseReference!
    
    var quote: String = "今日App心情都太差了，沒有任何更新"
    var author: String = "— 斌"
    
    override func viewDidAppear(_ animated: Bool) {
        if let color = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.colorForKey(key: "BackgroundColor") as? UIColor
        {
            screenView.backgroundColor = color
            backgroundHideenView.backgroundColor =  color
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shareSegue"
        {
            if let VC = segue.destination as? ShareViewController
            {
                backgroundHideenView.isHidden = false
                let image = takeScreenshot(of: backgroundHideenView)
                
                backgroundHideenView.isHidden = true
                //   VC.screenshotPreview.image = image
                
                VC.imageToShow = image
                
                //  VC.screenshotPreview.image = UIImage(named: "icon_notification")
            }
        }
    }
    
    // MARK: - Actions
    @objc func imageWasSaved(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        print("Image was saved in the photo gallery")
        UIApplication.shared.open(URL(string:"photos-redirect://")!)
    }
    
    func takeScreenshot(of view: UIStackView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: view.bounds.width, height: view.bounds.height),
            false,
            2
        )
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        
        
        
        
        
        //   UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(imageWasSaved), nil)
        return screenshot
    }
    
    @objc func actionButtonTapped() {
        takeScreenshot(of: backgroundHideenView)
    }
    
}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification.request.content.body);
        completionHandler([.alert, .sound])
    }}

