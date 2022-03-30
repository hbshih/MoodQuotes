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
import CoreText
import StoreKit
import FirebaseAnalytics
import PopupDialog

var global_quote: String = ""

class ViewController: UIViewController, MessagingDelegate {
    
    @IBOutlet weak var moodButton: UIButton!
    @IBOutlet weak var hiddenQuoteView: UIStackView!
    @IBOutlet weak var hiddenQuoteViewFlowerImage: UIImageView!
    @IBOutlet weak var hiddenQuoteViewAuthor: UILabel!
    @IBOutlet weak var hiddenQuoteViewQuote: UILabel!
    @IBOutlet weak var hiddenQuoteViewFlower: UILabel!
    @IBOutlet weak var quoteView: UIView!
    @IBOutlet weak var twDayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bookmarkNotification: UILabel!
    @IBOutlet weak var Button_bookmark: UIButton!
    @IBOutlet weak var quoteAndAuthorStackView: UIStackView!
    @IBOutlet weak var ratingView: UIStackView!
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
    @IBOutlet weak var onboardingTouchIcon: UIImageView!
    @IBOutlet weak var todayDateLabel: UILabel!
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "NewUserAllSet_Ver 3.0") != nil
        {
            
        }else
        {
            print("touched")
            onboardingTouchIcon.isHidden = true
            if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "isNotificationOn") != nil
            {
                // existing users
                performSegue(withIdentifier: "showTutorialSegue", sender: nil)
            }else
            {
                performSegue(withIdentifier: "firstTimeSettingSegue", sender: nil)
            }
            
        }
    }
    
    var bookmark_saved = false
    
    @IBAction func bookmark_tapped(_ sender: Any) {
        
        if bookmark_saved == false
        {
            self.bookmarkNotification.fadeIn(completion: {
                    (finished: Bool) -> Void in
                    self.bookmarkNotification.fadeOut()
                    })
            Analytics.logEvent("Bookmarked_Quote", parameters: nil)
            bookmark_saved = true
            print("tapped")
            
            if var quoteArray = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedQuoteArray") as? [String]
            {
                print("saved quote \(quoteArray)")
                quoteArray.append(frontQuote.text!)
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.set(quoteArray, forKey: "savedQuoteArray")
            }else
            {
                print("saved quote is empty")
                var quoteArray = [String]()
                quoteArray.append(frontQuote.text!)
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.set(quoteArray, forKey: "savedQuoteArray")
            }
            
            if var authorArray = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedAuthorArray") as? [String]
            {
                print("saved author \(authorArray)")
                authorArray.append(authorName.text!)
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.set(authorArray, forKey: "savedAuthorArray")
            }else
            {
                print("saved author is empty")
                var authorArray = [String]()
                authorArray.append(authorName.text!)
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.set(authorArray, forKey: "savedAuthorArray")
            }
            
            Button_bookmark.setBackgroundImage(UIImage(named: "icon_bookmarked"), for: .normal)
        }else
        {
            Analytics.logEvent("Unbookmarked_Quote", parameters: nil)
            bookmark_saved = false
            if var quoteArray = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedQuoteArray") as? [String]
            {
                // print(frontQuote.text!)
                // in case remove other than today
                if quoteArray.last == frontQuote.text!
                {
                    quoteArray.removeLast()
                    UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.set(quoteArray, forKey: "savedQuoteArray")
                }
            }
            
            if var authorArray = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedAuthorArray") as? [String]
            {
                authorArray.removeLast()
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.set(authorArray, forKey: "savedAuthorArray")
            }
            Button_bookmark.setBackgroundImage(UIImage(named: "icon_unBookmarked"), for: .normal)
        }
        
    }
    
    @IBAction func like_tapped(_ sender: Any) {
        Analytics.logEvent("like", parameters: ["author": author])
        
        if var liked_array = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "Liked_Array") as? [String]
        {
            let today_quote = "\(self.quote),\(self.author)"
            liked_array.append(today_quote)
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(liked_array, forKey: "Liked_Array")
        }else
        {
            let today_quote = "\(self.quote),\(self.author)"
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(today_quote, forKey: "Liked_Array")
        }
        hideRatingView()
    }
    @IBAction func dislike_tapped(_ sender: Any) {
        Analytics.logEvent("dislike", parameters: ["author": author])
        hideRatingView()
    }
    
    func hideRatingView()
    {
        //hide
        ratingView.isHidden = true
    }
    
    func showRatingview()
    {
        ratingView.isHidden = false
    }
    
    @objc func loadNewQuotes() {
        print("enter foreground now")
        // your code
        //If no quote saved in local & time now >= update time
        /*|| UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "NewUserAllSet_Ver 3.0") != nil*/
        
        // comment out for testing purpose
        if SyncAppQuotes().checkIfUpdate()
        {
            print("loading new screen")
            // Get From API
            DispatchQueue.main.async {
                firebaseService().getQuoteApiResponse { [self] (result) in
                    let quoteInfo: [Quote]
                    if case .success(let fetchedData) = result {
                        quoteInfo = fetchedData
                        self.quote = quoteInfo.first!.quote
                        self.author = quoteInfo.first!.author
                        DispatchQueue.main.async { [self] in
                            
                            print("getting new flower")
                            // Update Local Data
                            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(self.quote, forKey: "Quote")
                            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(self.author, forKey: "Author")
                            self.frontQuote.text = self.quote
                            self.authorName.text = self.author
                           // self.hiddenQuote.text = self.quote
                           // self.hiddenAuthorName.text = self.author
                            global_quote = frontQuote.text!
                            
                            // Update Flower
                            downloadFlowerImage()
                            
                            // show rating
                            //  showRatingview()
                            
                            //更新Widget
                            if #available(iOS 14.0, *) {
                                WidgetCenter.shared.reloadAllTimelines()
                            } else {
                                // Fallback on earlier versions
                            }
                            checkIfBookmarked()
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
            let FlowerImage: UIImage = flowerHandler().retrieveImage(forKey: "FlowerImage", inStorageType: .userDefaults) ?? UIImage(named: "flower_10_babys breath_滿天星") as! UIImage
            let FlowerName: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "FlowerName") ?? "滿天星"
            DispatchQueue.main.async { [self] in
                self.frontQuote.text = Q
                self.authorName.text = A
                self.ImageOfFlower.setImage(FlowerImage)
                self.nameOfFlower.text = FlowerName
                
             //   self.hiddenQuote.text = Q
             //   self.hiddenAuthorName.text = A
                global_quote = frontQuote.text!
                checkIfBookmarked()
            }
        }
        
        if #available(iOS 14.0, *)
        {
            WidgetCenter.shared.reloadAllTimelines()
        }
        

    }
    
    @IBOutlet weak var ImageOfFlower: UIImageView!
    var defaultQuote = "正在載入中"
    var defaultAuthor = "正在載入中"
    var defaultFlowerImage = UIImage(named: "noun_seeds_184642")
    var defaultFlowerImageName = "正在載入中"
    
    @objc func flashImageActive(){
        UIView.animate(withDuration: 0.7) {
            self.onboardingTouchIcon.alpha = self.onboardingTouchIcon.alpha == 1.0 ? 0.0 : 1.0
        }
    }
    
    func checkIfBookmarked()
    {
        if let array = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedQuoteArray") as? [String]
        {
            if array.contains(self.frontQuote.text!)
            {
                self.bookmark_saved = true
                self.Button_bookmark.setBackgroundImage(UIImage(named: "icon_bookmarked"), for: .normal)
            }else
            {
                print("quote today \(self.frontQuote.text)")
                print("quote array \(array)")
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //    self.bookmarkNotification.alpha = 0
    //    self.bookmarkNotification.text = "語錄已儲存！"
        
        if let arr = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedQuoteArray") as? [String]
        {
            print("saved quotes")
            print(arr)
        }
        
        //  print(flowerHandler().retrieveImage(forKey: "FlowerImage", inStorageType: .userDefaults))
        
        // user open app count
        if let counter = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.integer(forKey: "open_app_count") as? Int
        {
            if counter != nil
            {
                //old user
                print("counter is \(counter)")
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set((counter + 1), forKey: "open_app_count")
                Analytics.logEvent("counter", parameters: ["counter": "\(counter)"])
                
                if counter > 3
                {
                    Analytics.logEvent("requested_review", parameters: nil)
                    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: scene)
                    }
                }
                
                
            }else
            {
                //new user
                print("counter is nil")
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(1, forKey: "open_app_count")
            }
        }
        
        
        if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "NewUserAllSet_Ver 3.0") != nil
        {
            self.onboardingTouchIcon.alpha = 0.0
            self.onboardingTouchIcon.isHidden = true
            // Existing User
        } else
        {
            // New User
            self.onboardingTouchIcon.alpha = 0.0
            Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(self.flashImageActive), userInfo: nil, repeats: true)
        }
        
        if var author = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedAuthorArray") as? [String]
        {
            print("author \(author)")
        }
        
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
        var font = Display_Font(font_size: 18).getUIFont()
   //     hiddenQuote.font = font
     //   hiddenQuoteAdder.font = font
        frontQuote.font = font
        font = Display_Font(font_size: 16).getUIFont()
        authorName.font = font
    //    hiddenAuthorName.font = font
        // ref = Database.database().reference()
        
        //todayDateLabel.text = Date().getTodayDate
        frontQuote.text = defaultQuote
        authorName.text = defaultAuthor
        ImageOfFlower.setImage(defaultFlowerImage!)
        nameOfFlower.text = defaultFlowerImageName
        
        
        
        if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "isNotificationOn") != nil
        {
            onboardingTouchIcon.image = UIImage(named: "icon_touch_tutorial")
        }
        /*
         rubyLabel.text = "｜成功《せいこう》するかどうかは、きみの｜努力《どりょく》に｜係《かか》る。｜人々《ひとびと》の｜生死《せいし》に｜係《かか》る。"  //2
         //3
         rubyLabel.textAlignment = .left
         rubyLabel.font = .systemFont(ofSize: 20.0)
         rubyLabel.orientation = .horizontal
         rubyLabel.lineBreakMode = .byCharWrapping
         
         frontQuote.textAlignment = .left
         frontQuote.lineBreakMode = .byCharWrapping
         */
        /*    DispatchQueue.main.async {
         self.loadNewQuotes()
         }*/
        //  loadNewQuotes()
        
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
        Analytics.logEvent("Screenshot_Taken", parameters: nil)
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
                self.ImageOfFlower.sd_setImage(with: reference, placeholderImage: placeholderImage) { (image, error, cache, ref) in
                    if error != nil
                    {
                        print("unable to load new image \(error)")
                        flowerHandler().storeImage(image: UIImage(named: "flower_10_babys breath_滿天星")!, forKey: "FlowerImage", withStorageType: .userDefaults)
                        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set("滿天星", forKey: "FlowerName")
                        //更新Widget
                        if #available(iOS 14.0, *) {
                            WidgetCenter.shared.reloadAllTimelines()
                        } else {
                            // Fallback on earlier versions
                        }
                    }else
                    {
                        flowerHandler().storeImage(image: image!, forKey: "FlowerImage", withStorageType: .userDefaults)
                        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(name, forKey: "FlowerName")
                        //更新Widget
                        if #available(iOS 14.0, *) {
                            WidgetCenter.shared.reloadAllTimelines()
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }
                self.nameOfFlower.text = name
            }
        }
    }
    
    var backgroundColor = UIColor.white
    
    override func viewWillAppear(_ animated: Bool) {
        
        //check Color
        if let color = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.colorForKey(key: "BackgroundColor") as? UIColor
        {
            backgroundColor = color
            screenView.backgroundColor = color
         //   frontStackView.backgroundColor = color
         //   hiddenQuoteView.backgroundColor = color
           // backgroundHideenView.backgroundColor =  color
            // quoteAndAuthorStackView.backgroundColor = color
            // quoteAndAuthorStackView.customize(backgroundColor: color, radiusSize: 20)
        }
        
        // loadNewQuotes()
        todayDateLabel.text = Date().getDateDayOnly
        twDayLabel.text = Date().getTWday
        dateLabel.text = Date().getLunarDate
        
        //checkIfBookmarked()
    }
    
    @IBAction func updateMoodTapped(_ sender: Any) {
        
        // Create a custom view controller
        let ratingVC = UpdateMood(nibName: "UpdateMoodViewController", bundle: nil)
            
        //    RatingViewController(nibName: "RatingViewController", bundle: nil)
        
        

        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        
        
        
    
        // Create second button
        let buttonTwo = DefaultButton(title: "儲存", height: 60) {
            
            self.moodButton.setBackgroundImage(UIImage(named: "noun_bookmark_809340"), for: .normal)
            
            self.moodButton.setTitle("", for: .normal)
            
            

        }
        
        buttonTwo.backgroundColor = .systemGray6
        buttonTwo.titleColor = .systemGray
     //   buttonTwo.titleLabel.
        
        
        
        popup.addButtons([buttonTwo])
        
        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        todayDateLabel.text = Date().getDateDayOnly
        twDayLabel.text = Date().getTWday
        dateLabel.text = Date().getLunarDate
        
        checkIfBookmarked()
        
        DispatchQueue.main.async {
            self.loadNewQuotes()
            
            

            
        }
        
        /* Comment for now --- 4/17/2021
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
                
                hiddenQuoteViewQuote.text = self.frontQuote.text
                hiddenQuoteViewAuthor.text = self.authorName.text
                hiddenQuoteViewFlower.text = self.nameOfFlower.text
                hiddenQuoteViewFlowerImage.setImage(ImageOfFlower.image!)
                
                Analytics.logEvent("home_vc_share_tapped", parameters: ["Quote": frontQuote.text as Any, "Author": authorName.text as Any])
                
                
                
             //   backgroundHideenView.isHidden = false
                
                
                if #available(iOS 14.0, *)
                {
                    // frontStackView.backgroundColor = .blue
                    buttonView.isHidden = true
                    Button_bookmark.isHidden = true
                    quoteAndAuthorStackView.backgroundColor = backgroundColor
                    let image = takeScreenshot(of: hiddenQuoteView)
                    VC.imageToShow = image
                    quoteAndAuthorStackView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.85)
                    buttonView.isHidden = false
                    Button_bookmark.isHidden = false
                }else
                {
                    stack_action_controller.isHidden = true
                    let image = screenView.takeScreenShot()
                    VC.imageToShow = image
                }
                
                
               // backgroundHideenView.isHidden = true
                stack_action_controller.isHidden = false
                //   VC.screenshotPreview.image = image
                
                
                
                //  VC.screenshotPreview.image = UIImage(named: "icon_notification")
            }
        }else if segue.identifier == "showTutorialSegue"
        {
            if let VC = segue.destination as? TutorialViewController
            {
                VC.navigateToHomeAfterDismiss = true
            }
        }else
        {
            
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
    /*
    @objc func actionButtonTapped() {
        takeScreenshot(of: backgroundHideenView)
    }*/
    
    
    
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


extension UIImageView {
    func flash(numberOfFlashes: Float) {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = numberOfFlashes
        layer.add(flash, forKey: nil)
    }
}

extension UIStackView {
    func customize(backgroundColor: UIColor = .clear, radiusSize: CGFloat = 0) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = backgroundColor
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        
        subView.layer.cornerRadius = radiusSize
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
    }
}

extension UIView {


    func fadeIn(duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
        self.alpha = 1.0
        }, completion: completion)  }

    func fadeOut(duration: TimeInterval = 0.3, delay: TimeInterval = 0.5, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
        self.alpha = 0.0
        }, completion: completion)
}

}
