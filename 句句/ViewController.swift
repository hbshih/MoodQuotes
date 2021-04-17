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
import WidgetKit
import FirebaseUI

var global_quote: String = ""

class ViewController: UIViewController, MessagingDelegate {
    
    @IBOutlet weak var frontStackView: UIStackView!
    @IBOutlet weak var frontQuote: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var hiddenAuthorName: UILabel!
    @IBOutlet weak var hiddenQuote: UILabel!
    @IBOutlet weak var screenView: UIView!
    @IBOutlet weak var backgroundHideenView: UIStackView!
    @IBOutlet weak var hiddenQuoteAdder: UILabel!
    @IBOutlet weak var stack_action_controller: UIStackView!
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched")
        performSegue(withIdentifier: "firstTimeSettingSegue", sender: nil)
    }
    
    
    @objc func loadNewQuotes() {
        
        print("enter foreground now")
       // your code
        //If no quote saved in local & time now >= update time
        if (UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote")) == nil || SyncAppQuotes().checkIfUpdate()
        {
            // Get From API
            DispatchQueue.main.async {
                firebaseService().getQuoteApiResponse { [self] (result) in
                    let quoteInfo: [Quote]
                    if case .success(let fetchedData) = result {
                        quoteInfo = fetchedData
                        self.quote = quoteInfo.first!.quote
                        self.author = quoteInfo.first!.author
                        DispatchQueue.main.async { [self] in
                            // Update Local Data
                            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(self.quote, forKey: "Quote")
                            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(self.author, forKey: "Author")
                            self.frontQuote.text = self.quote
                            self.authorName.text = self.author
                            self.hiddenQuote.text = self.quote
                            self.hiddenAuthorName.text = self.author
                            global_quote = frontQuote.text!
                            
                            //更新Widget
                            if #available(iOS 14.0, *) {
                                WidgetCenter.shared.reloadAllTimelines()
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    } else {
                        let errQuote = Quote(quote: "App當機拉", author: "By Me")
                        quoteInfo = [errQuote,errQuote]
                    }
                }
            }
            
        }else
        {
            print("Load Quotes and Author From Local")
            let Q: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote")!
            let A: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Author")!
            DispatchQueue.main.async { [self] in
                self.frontQuote.text = Q
                self.authorName.text = A
                self.hiddenQuote.text = Q
                self.hiddenAuthorName.text = A
                global_quote = frontQuote.text!
            }
        }
        
        if #available(iOS 14.0, *)
        {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    @IBOutlet weak var ImageOfFlower: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadNewQuotes), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadNewQuotes), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadNewQuotes), name: UIApplication.didBecomeActiveNotification, object: nil)

        //Notifications
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
        
        //UI
        var font = Display_Font(font_size: 30).getUIFont()
        hiddenQuote.font = font
        hiddenQuoteAdder.font = font
        frontQuote.font = font
        font = Display_Font(font_size: 24).getUIFont()
        authorName.font = font
        hiddenAuthorName.font = font
       // ref = Database.database().reference()
        
        
        frontQuote.text = "語錄更新中..."
        authorName.text = "更新中"
        
        //If Screenshot get to share screen
        NotificationCenter.default.addObserver(self, selector: #selector(screenshotTaken), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    
    
    func registerForNotifications() {
      NotificationCenter.default.addObserver(
        forName: .newPokemonFetched,
        object: nil,
        queue: nil) { (notification) in
          print("notification received")
/*        /*For Testing*/
        let content = UNMutableNotificationContent()
        content.title = "test notifaction"
        content.body = "VC GOT notified!"
        content.sound = UNNotificationSound.default

        let tri = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let req  = UNNotificationRequest(identifier: "VC_Notified", content: content, trigger: tri)

        UNUserNotificationCenter.current().add(req) { (error) in
            print("error\(error )")
        }
        /*Testing Ends*/*/
      }
    }

    
    @objc func screenshotTaken()
    {
        performSegue(withIdentifier: "shareSegue", sender: nil)
    }
    
    var ref: DatabaseReference!
    
    var quote: String = "今日App心情都太差了，沒有任何更新"
    @IBOutlet weak var nameOfFlower: UILabel!
    var author: String = "— 斌"
    
    func downloadFlowerImage()
    {
        flowerHandler().getFlowerImageURL { (name, image_url) in
            DispatchQueue.main.async { [self] in
                
                // Get a reference to the storage service using the default Firebase App
                let storage = Storage.storage()

                // Create a storage reference from our storage service
                let storageRef = storage.reference()
                
                print("get url \(image_url)")
                // Reference to an image file in Firebase Storage
                 let reference = storageRef.child("flowers/\(image_url).png")

                // Placeholder image
                let placeholderImage = UIImage(named: "placeholder.jpg")
                

                // Load the image using SDWebImage
                self.ImageOfFlower.sd_setImage(with: reference, placeholderImage: placeholderImage)
                self.nameOfFlower.text = name
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //check Color
        if let color = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.colorForKey(key: "BackgroundColor") as? UIColor
        {
            screenView.backgroundColor = color
            frontStackView.backgroundColor = color
            backgroundHideenView.backgroundColor =  color
        }
        
    /* Comment for now
        //If no quote saved in local & time now >= update time
        if (UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote")) == nil || SyncAppQuotes().checkIfUpdate()
        {
            // Get From API
            DispatchQueue.main.async {
                firebaseService().getQuoteApiResponse { [self] (result) in
                    let quoteInfo: [Quote]
                    if case .success(let fetchedData) = result {
                        quoteInfo = fetchedData
                        self.quote = quoteInfo.first!.quote
                        self.author = quoteInfo.first!.author
                        DispatchQueue.main.async { [self] in
                            // Update Local Data
                            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(self.quote, forKey: "Quote")
                            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(self.author, forKey: "Author")
                            self.frontQuote.text = self.quote
                            self.authorName.text = self.author
                            self.hiddenQuote.text = self.quote
                            self.hiddenAuthorName.text = self.author
                            global_quote = frontQuote.text!
                            //更新Widget
                            if #available(iOS 14.0, *) {
                                WidgetCenter.shared.reloadAllTimelines()
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    } else {
                        let errQuote = Quote(quote: "App當機拉", author: "By Me")
                        quoteInfo = [errQuote,errQuote]
                    }
                }
            }
            
        }else
        {
            print("Load Quotes and Author From Local")
            let Q: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote")!
            let A: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Author")!
            DispatchQueue.main.async { [self] in
                self.frontQuote.text = Q
                self.authorName.text = A
                self.hiddenQuote.text = Q
                self.hiddenAuthorName.text = A
                global_quote = frontQuote.text!
            }
        }
        
        if #available(iOS 14.0, *)
        {
            WidgetCenter.shared.reloadAllTimelines()
        }
        */
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shareSegue"
        {
            if let VC = segue.destination as? ShareViewController
            {
                
                Analytics.logEvent("home_vc_share_tapped", parameters: ["Quote": frontQuote.text, "Author": authorName.text])
                
                
                
                backgroundHideenView.isHidden = false

                
                if #available(iOS 14.0, *)
                {
                   // frontStackView.backgroundColor = .blue
                    buttonView.isHidden = true
                    let image = takeScreenshot(of: frontStackView)
                    VC.imageToShow = image
                    buttonView.isHidden = false
                }else
                {
                    stack_action_controller.isHidden = true
                    let image = screenView.takeScreenShot()
                    VC.imageToShow = image
                }
                
                
                backgroundHideenView.isHidden = true
                stack_action_controller.isHidden = false
                //   VC.screenshotPreview.image = image
                
                
                
                //  VC.screenshotPreview.image = UIImage(named: "icon_notification")
            }
        }else
        {
            Analytics.logEvent("home_vc_settings_tapped", parameters: nil)
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


extension UIView {

    func takeScreenShot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)

        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
