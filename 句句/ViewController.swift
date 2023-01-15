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
import Storyly
import Survicate

var global_quote: String = ""
var global_counter = 0

class ViewController: UIViewController, MessagingDelegate, StorylyDelegate {
    
    @IBOutlet weak var shareAndbookmarkStack: UIStackView!
    @IBOutlet weak var installWidgetInstructionView: UIView!
    @IBOutlet weak var moodButton: UIButton!
    @IBOutlet weak var twDayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var Button_bookmark: UIButton!
    @IBOutlet weak var frontQuote: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var screenView: UIView!
    @IBOutlet weak var trial_Button: UIView!
    @IBOutlet weak var flowerMeaning: UILabel!
    @IBOutlet weak var trialButton: UIButton!
    @IBOutlet weak var flowerMeaningPlaceholder: UILabel!
    @IBOutlet weak var onboardingTouchIcon: UIImageView!
    
    @IBOutlet weak var countdownButton: UIButton!
    @IBOutlet weak var blackwhiteFlowerSectionView: UIStackView!
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var coloredFlowerSectionView: UIStackView!
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    
    
    var bookmark_saved = false
    
    @IBAction func bookmark_tapped(_ sender: Any) {
        
        if bookmark_saved == false
        {
            bookmark_saved = true
            Button_bookmark.setTitle("已收藏", for: .normal)
            alertViewHandler().alert(title: "語錄已儲存", body: "", iconText: "📖")
            
            global_savedQuotes[global_savedQuotes.count] = [authorName.text!: frontQuote.text!]
            
            
            //save to database
            saveQuotes()
            
            Analytics.logEvent("Bookmarked_Quote", parameters: nil)
            //Button_bookmark.setBackgroundImage(UIImage(named: "icon_bookmarked"), for: .normal)
        }else
        {
            Analytics.logEvent("Unbookmarked_Quote", parameters: nil)
            bookmark_saved = false
            global_savedQuotes.removeValue(forKey: global_savedQuotes.count-1)
            
            if var quoteArray = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedQuoteArray") as? [String]
            {
                if quoteArray.last == frontQuote.text!
                {
                    quoteArray.removeLast()
                    UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.set(quoteArray, forKey: "savedQuoteArray")
                    
                    if var authorArray = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedAuthorArray") as? [String]
                    {
                        authorArray.removeLast()
                        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.set(authorArray, forKey: "savedAuthorArray")
                    }
                }
            }
            Button_bookmark.setTitle("收藏", for: .normal)
            // Button_bookmark.setBackgroundImage(UIImage(named: "icon_unBookmarked"), for: .normal)
            print(global_savedQuotes)
        }
    
    }
    
    private func saveQuotes()
    {
        
        if var quoteArray = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedQuoteArray") as? [String], var authorArray = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedAuthorArray") as? [String]
        {
            // save quote
            quoteArray.append(frontQuote.text!)
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.set(quoteArray, forKey: "savedQuoteArray")
            authorArray.append(authorName.text!)
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.set(authorArray, forKey: "savedAuthorArray")
        }else
        {
            //create new user default
            var quoteArray = [String]()
            quoteArray.append(frontQuote.text!)
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.set(quoteArray, forKey: "savedQuoteArray")
            
            var authorArray = [String]()
            authorArray.append(authorName.text!)
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.set(authorArray, forKey: "savedAuthorArray")
        }
    }
    
    
    @objc func loadNewQuotes() {
        // comment out for testing purpose
        if SyncAppQuotes().checkIfUpdate() || self.frontQuote.text == "點開查看今日給你的話吧" || self.frontQuote.text == "今日沒有更新" || self.author == "休息一下" || self.authorName.text == "休息一下" || self.nameOfFlower.text == "我是種子"
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
                            
                            print("getting new flower")
                            // Update Local Data
                            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(self.quote, forKey: "Quote")
                            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(self.author, forKey: "Author")
                            self.frontQuote.text = self.quote
                            self.authorName.text = self.author
                            global_quote = frontQuote.text!
                            
                            // Update Flower
                            downloadFlowerImage()
                            
                            //更新Widget
                            if #available(iOS 14.0, *) {
                                WidgetCenter.shared.reloadAllTimelines()
                            } else {
                                // Fallback on earlier versions
                            }
                            checkIfBookmarked()
                            
                            
                        }
                    } else {
                        alertViewHandler().control(title: "無法更新語錄", body: "請確認手機是否連結到網路", iconText: "❗️")
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
            let FlowerMeaningString: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "FlowerMeaning") ?? "滿天星的花語是思念、青春、夢境、真心喜歡。"
            
            print("flower meaning \(FlowerMeaningString)")
            
            DispatchQueue.main.async { [self] in
                self.frontQuote.text = Q
                self.authorName.text = A
                self.ImageOfFlower.setImage(FlowerImage)
                self.imageOfColorFlower.setImage(FlowerImage)
                self.nameOfColorImage.text = FlowerName
                self.nameOfFlower.text = FlowerName
                self.flowerMeaning.text = FlowerMeaningString
                
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
    @IBOutlet weak var imageOfColorFlower: UIImageView!
    var defaultQuote = "正在載入中"
    var defaultAuthor = "正在載入中"
    var defaultFlowerImage = UIImage(named: "noun_seeds_184642")
    var defaultFlowerImageName = "正在載入中"
    
    /*
    @objc func flashImageActive(){
        UIView.animate(withDuration: 0.7) {
            self.onboardingTouchIcon.alpha = self.onboardingTouchIcon.alpha == 1.0 ? 0.0 : 1.0
        }
    }
    */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var randomString = ["一天只會有一句語錄，還要再等個幾小時才下個語錄喔！"]
        
        alertViewHandler().control(title: randomString[0], body: "", iconText: "🐽")
    }
    
    func checkIfBookmarked()
    {
        let array = Array(global_savedQuotes.values)
        
        if array.contains([authorName.text!:self.frontQuote.text!])
            {
                self.bookmark_saved = true
                Button_bookmark.setTitle("已收藏", for: .normal)
                //self.Button_bookmark.setBackgroundImage(UIImage(named: "icon_bookmarked"), for: .normal)
            }
        
        /*
        if let array = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedQuoteArray") as? [String]
        {
            if array.contains(self.frontQuote.text!)
            {
                self.bookmark_saved = true
                Button_bookmark.setTitle("已收藏", for: .normal)
                //self.Button_bookmark.setBackgroundImage(UIImage(named: "icon_bookmarked"), for: .normal)
            }else
            {
                print("quote today \(self.frontQuote.text)")
                print("quote array \(array)")
            }
        }*/
    }
    
    @objc func homepageRefresh()
    {
        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("view will appear called")
        
        loadNewQuotes()
        
        prepareView()
        
        // Get next update time
        getNextUpdateTime()
        
        
        //downloadFlowerImage()
        //UI
        var font = Display_Font(font_size: 20).getUIFont()
        frontQuote.font = font
        //nameOfFlower.font = font
        //nameOfColorImage.font = font
        font = Display_Font(font_size: 16).getUIFont()
        authorName.font = font
        twDayLabel.font = font
        font = Display_Font(font_size: 12).getUIFont()
        //flowerMeaning.font = font
       // todayDateLabel.text = Date().getDateDayOnly
        twDayLabel.text = Date().getMonthDay
        //dateLabel.text = Date().getTodayDate
    }
    
    func setupMoodButton()
    {
        // UI
        moodButtonHolderView.backgroundColor = UIColor(red: 254/255, green: 250/255, blue: 244/255, alpha: 1.0)
        moodButtonHolderView.layer.borderWidth = 1.0
        moodButtonHolderView.layer.borderColor = CGColor(red: 156/255, green: 158/255, blue: 185/255, alpha: 0.5)
        // UI
        moodButtonHolderView_text.backgroundColor = UIColor(red: 254/255, green: 250/255, blue: 244/255, alpha: 1.0)
        moodButtonHolderView_text.layer.borderWidth = 1.0
        moodButtonHolderView_text.layer.borderColor = CGColor(red: 156/255, green: 158/255, blue: 185/255, alpha: 0.5)
        
        // load moodList
        if var moodList = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.dictionary(forKey: "moodList")
        {
            if let today_mood = moodList[Date().getFormattedDate] as? String
            {
                moodButton.contentMode = .scaleAspectFit
                moodButton.imageView?.contentMode = .scaleAspectFit
                moodButton.setImage(UIImage(named: today_mood), for: .normal)
                self.moodButtonHolderView_text.isHidden = true
                self.moodButtonHolderView.isHidden = false
            }else
            {
                self.moodButtonHolderView_text.isHidden = false
                self.moodButtonHolderView.isHidden = true
            }
        }
    }
    
    @IBAction func countdownButtonTapped(_ sender: Any) {
        
        if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "NewUserAllSet_Ver 3.0") != nil
        {
            // existing users
            
            var randomString = ["再等個幾小時才有新語錄喔！"]
            
            alertViewHandler().control(title: randomString[0], body: "", iconText: "🐽")
            
        }else
        {
            print("touched")
          //  onboardingTouchIcon.isHidden = true
            if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "isNotificationOn") != nil
            {
                
            }else
            {
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(true, forKey: "NewUserAllSet_Ver 3.0")
                getNextUpdateTime()
                performSegue(withIdentifier: "notifiicationSegue", sender: nil)
                //performSegue(withIdentifier: "notificationSegue", sender: nil)
            }
            
        }
        
    }
    func trackAppOpenCount()
    {
        if let counter = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.integer(forKey: "open_app_count") as? Int
        {
            if counter != nil && counter >= 1
            {
                global_counter = counter
                //old user
                print("counter is \(counter)")
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set((counter + 1), forKey: "open_app_count")
                Analytics.logEvent("counter", parameters: ["counter": "\(counter)"])
                
                if counter > 10
                {
                    Analytics.logEvent("requested_review", parameters: nil)
                    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: scene)
                    }
                }
                
                // request trial
                if counter > 5 && !global_paid_user
                {
                    
                    trial_Button.isHidden = false
                }
                

            }else
            {
                //new user
                print("counter is nil")
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(1, forKey: "open_app_count")
            }
        }
    }
    
    func displayOnboardTips()
    {
        
        print ("onboarding status \(UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "NewUserAllSet_Ver 3.0"))")
        
        if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "NewUserAllSet_Ver 3.0") != nil && UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.bool(forKey: "widgetTutorialSeen") != nil
        {
            installWidgetInstructionView.isHidden = true
            shareAndbookmarkStack.isHidden = false
           // self.onboardingTouchIcon.alpha = 0.0
           // self.onboardingTouchIcon.isHidden = true
            // Existing User
            
            /*   if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "ShowNewUIUpdate_Ver6.0") != nil
             {
             
             }else
             {
             alertViewHandler().control(title: "歡迎使用全新介面", body: "新版介面除了讓介面更為簡潔，也增加了心情紀錄、更多字體和背景、以及付費版功能，讓你在欣賞語錄的當下可以獲得更多小知識。", iconText: "😎")
             UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(true, forKey: "ShowNewUIUpdate_Ver6.0")
             }*/
        } else
        {
            installWidgetInstructionView.isHidden = false
            shareAndbookmarkStack.isHidden = true
            // New User
          //  self.onboardingTouchIcon.alpha = 0.0
          //  Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(self.flashImageActive), userInfo: nil, repeats: true)
            
            //handle new user
            
          /*  let setInitialUpdateDate = Calendar.current.date(bySettingHour: 9, minute: 00, second: 0, of: Date())!
            let updateTime = Calendar.current.date(byAdding: .day, value: 1, to: setInitialUpdateDate)
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(updateTime, forKey: "updateTime")
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(updateTime, forKey: "updateTimeForWidget")
          //  print("Next update date \(pickeriOS14.date)")
            print("Next update date \(updateTime)")*/
        }
    }
    
    func appVersionUpdateHandler()
    {
        
        if appVersionNumberHandler().hasUpdatedSinceLastRun()
        {
            let defaults = UserDefaults.standard
            var array = defaults.array(forKey: "SavedIntArray")  as? [Double] ?? [Double]()
            print("version list \(array)")
        }
    }
    
    
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
        
        // Handle UI
        flowerMeaningPlaceholder.alpha = 0.0
        
        trackAppOpenCount()
        setupMoodButton()
        displayOnboardTips()
        appVersionUpdateHandler()
        
        let trialWords = ["獲得彩色植物", "試用其他字體", "查看植物花語","更多背景顏色","試用植語錄完整版"]
        // get random elements
        let randomTrialName = trialWords.randomElement()!
        // print random elements
        
        trialButton.setTitle(randomTrialName, for: .normal)
        
        
        if global_paid_user
        {
            imageOfColorFlower.setImage(defaultFlowerImage!)
            nameOfColorImage.text = defaultFlowerImageName
            coloredFlowerSectionView.isHidden = false
            blackwhiteFlowerSectionView.isHidden = true
        }else
        {
            ImageOfFlower.setImage(defaultFlowerImage!)
            nameOfFlower.text = defaultFlowerImageName
            coloredFlowerSectionView.isHidden = true
            blackwhiteFlowerSectionView.isHidden = false
        }
        
        
        frontQuote.text = defaultQuote
        authorName.text = defaultAuthor
        
        
        /*
         if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "isNotificationOn") != nil
         {
         onboardingTouchIcon.image = UIImage(named: "icon_touch_tutorial")
         }
         */
        
        //If Screenshot get to share screen
       // NotificationCenter.default.addObserver(self, selector: #selector(screenshotTaken), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    
    @IBAction func installWidgetHintTapped(_ sender: Any) {
        
        installWidgetInstructionView.isHidden = true
        shareAndbookmarkStack.isHidden = false
        
        if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "isNotificationOn") != nil && UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.bool(forKey: "isNotificationOn") == true
        {
            
        }else
        {
            countdownButton.setTitle("語錄更新時，傳送通知給我", for: .normal)
        }
        
    }
    func getNextUpdateTime()
    {
        if let notificationDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") as? Date
        {
            
            let diffComponents = Calendar.current.dateComponents([.hour], from: Date() , to: notificationDate)
            var hours = diffComponents.hour
            
            if hours == 0
            {
                hours = 23
            }
            
            if UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "NewUserAllSet_Ver 3.0") != nil
            {
                countdownButton.setTitle("距離下次更新還有 \(hours ?? 23) 小時", for: .normal)
            }else
            {
                if (!installWidgetInstructionView.isHidden)
                {
                    countdownButton.setTitle("距離下次更新還有 \(hours ?? 23) 小時", for: .normal)
                }else
                {
                    countdownButton.setTitle("\(hours ?? 23) 小時後語錄會更新，需要通知你嗎？", for: .normal)
                }
            }
            
            
        }
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
    @IBOutlet weak var nameOfColorImage: UILabel!
    var author: String = "— 斌"
    
    func downloadFlowerImage()
    {
        if global_paid_user
        {
            coloredflowerHandler().getFlowerImageURL { (name, image_url, meaning) in
                DispatchQueue.main.async { [self] in
                    
                    // Get a reference to the storage service using the default Firebase App
                    let storage = Storage.storage()
                    
                    // Create a storage reference from our storage service
                    let storageRef = storage.reference()
                    
                    print("get url \(image_url)")
                    // Reference to an image file in Firebase Storage
                    let reference = storageRef.child("/colored_flowers/\(image_url).png")
                    
                    // Placeholder image
                    let placeholderImage = UIImage(named: "placeholder.jpg")
                    
                    
                    // Load the image using SDWebImage
                    self.imageOfColorFlower.sd_setImage(with: reference, placeholderImage: placeholderImage) { (image, error, cache, ref) in
                        if error != nil
                        {
                            print("unable to load new image \(error)")
                            flowerHandler().storeImage(image: UIImage(named: "Vernonia amygdalina")!, forKey: "FlowerImage", withStorageType: .userDefaults)
                            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set("三色菫", forKey: "FlowerName")
                            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set("沉思，快樂，請思念我，白日夢，思慕，快樂，讓我們交往。", forKey: "FlowerMeaning")
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
                            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(meaning, forKey: "FlowerMeaning")
                            //更新Widget
                            if #available(iOS 14.0, *) {
                                WidgetCenter.shared.reloadAllTimelines()
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                    //self.nameOfFlower.text = name
                    self.nameOfColorImage.text = name
                    self.flowerMeaning.text = meaning
                }
            }
        }else
        {
            
            flowerHandler().getFlowerImageURL { (name, image_url) in
                DispatchQueue.main.async { [self] in
                    
                    // Get a reference to the storage service using the default Firebase App
                    let storage = Storage.storage()
                    
                    // Create a storage reference from our storage service
                    let storageRef = storage.reference()
                    
                    print("get url \(image_url)")
                    // Reference to an image file in Firebase Storage
                    let reference = storageRef.child("/flowers/\(image_url).png")
                    
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
                            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set("升級完整版才看得見花語", forKey: "FlowerMeaning")
                            //更新Widget
                            if #available(iOS 14.0, *) {
                                WidgetCenter.shared.reloadAllTimelines()
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                    self.nameOfFlower.text = name
                    //  self.nameOfColorImage.text = name
                    self.flowerMeaning.isHidden = true
                }
            }
        }
    }
    
    var backgroundColor = UIColor.white
    
    //load view
    func prepareView()
    {
        
        print("status of pay \(global_paid_user)")
        // Get Background Color
        if let color = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.colorForKey(key: "BackgroundColor") as? UIColor
        {
            backgroundColor = color
            screenView.backgroundColor = color
        }
        
        // Check if user is a paid user
        if !global_paid_user
        {
            coloredFlowerSectionView.isHidden = true
            blackwhiteFlowerSectionView.isHidden = false
            flowerMeaning.isHidden = true
        }else
        {
            coloredFlowerSectionView.isHidden = false
            blackwhiteFlowerSectionView.isHidden = true
            //trial_Button.isHidden = true
            trial_Button.alpha = 0.0
            flowerMeaning.isHidden = false
        }
    }
    
    
    @IBOutlet weak var moodButtonHolderView_text: UIView!
    @IBOutlet weak var moodButtonHolderView: UIView!
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
            
            if ratingVC.mood != "default"
            {
                
                if var moodList = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.dictionary(forKey: "moodList")
                {
                    if moodList.count >= 7 && !global_paid_user
                    {
                        alertViewHandler().control(title: "升級完整版繼續紀錄心情", body: "免費版目前只能紀錄七天的心情，若想要繼續紀錄請升級完整版", iconText: "🎁")
                    }else
                    {
                        self.moodButtonHolderView_text.isHidden = true
                        self.moodButtonHolderView.isHidden = false
                        
                        let mood = ratingVC.mood
                        self.moodButton.imageView?.contentMode = .scaleAspectFit
                        self.moodButton.setImage(UIImage(named: mood), for: .normal)
                        // self.moodButton.layer.wid
                        self.moodButton.setTitle("", for: .normal)
                        self.moodButtonHolderView.frame.size.width = 40
                        let array = [Date().getFormattedDate:mood]
                        if moodList.isEmpty || moodList.count < 1
                        {
                            // default
                            // UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.set(array, forKey: "moodList")
                        }else
                        {
                            moodList[Date().getFormattedDate] = mood
                            Analytics.logEvent("Daily_mood", parameters: ["mood": mood])
                            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.set(moodList, forKey: "moodList")
                        }
                    }
                }else
                {
                    self.moodButtonHolderView_text.isHidden = true
                    self.moodButtonHolderView.isHidden = false
                    
                    let mood = ratingVC.mood
                    self.moodButton.imageView?.contentMode = .scaleAspectFit
                    self.moodButton.setImage(UIImage(named: mood), for: .normal)
                    // self.moodButton.layer.wid
                    self.moodButton.setTitle("", for: .normal)
                    self.moodButtonHolderView.frame.size.width = 40
                    let array = [Date().getFormattedDate:mood]
                    UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.set(array, forKey: "moodList")
                }
            }
        }
        
        buttonTwo.backgroundColor = .systemGray6
        buttonTwo.titleColor = .systemGray
        popup.addButtons([buttonTwo])
        
        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        SurvicateSdk.shared.invokeEvent(name: "userPressedPurchase")
        
        checkIfBookmarked()
        
        //show advertisement
        if global_counter > 6 && !global_paid_user
        {
            performSegue(withIdentifier: "showAdSegue", sender: nil)
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
    @IBAction func shareTapped(_ sender: Any) {
        performSegue(withIdentifier: "shareSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shareSegue"
        {
            if let VC = segue.destination as? ShareViewController
            {
                
                VC.quoteToShow = self.frontQuote.text
                print("pass quote to VC \(VC.quoteToShow)")
                VC.authorToShow = self.authorName.text
                
                /*
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
                 
                 
                 */
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


extension UIImage {
    
    func aspectFitImage(inRect rect: CGRect) -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        let aspectWidth = rect.width / width
        let aspectHeight = rect.height / height
        let scaleFactor = aspectWidth > aspectHeight ? rect.size.height / height : rect.size.width / width
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width * scaleFactor, height: height * scaleFactor), false, 0.0)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: width * scaleFactor, height: height * scaleFactor))
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
