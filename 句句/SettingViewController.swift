//
//  SettingViewController.swift
//  句句
//
//  Created by Ben on 2020/11/14.
//

import UIKit
import DateTimePicker
import BLTNBoard
//import CustomBulletins
import FirebaseAnalytics


class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var videoTutorialLabel: UIButton!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.item {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "notificationTableCell") as! NotificationTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "updateTimeTableViewCell") as! UpdateTimeTableViewCell
            if let notificationDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") as? Date
            {
                // Set Notification Date
                cell.timePicker.date = notificationDate
                cell.timePickeriOS13.date = notificationDate
                let date = Calendar.current.date(bySettingHour: notificationDate.hour, minute: notificationDate.minute, second: 0, of: Date())!
                cell.timePicker.setDate(date, animated: false)
                cell.timePickeriOS13.setDate(date, animated: false)
            }else
            {
                let date = Calendar.current.date(bySettingHour: 9, minute: 00, second: 0, of: Date())!
                cell.timePicker.setDate(date, animated: false)
                cell.timePickeriOS13.setDate(date, animated: false)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "updateBackgroundTableViewCell") as! UpdateBackgroundColorTableViewCell
            let defaults = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!
            if let color = defaults.colorForKey(key: "BackgroundColor")
            {
                cell.backgrundColor.backgroundColor = color
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "updateFontTableViewCell") as! UpdateFontTableViewCell
            
          //  cell.fontPicker.sho
            
            let defaults = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "checkBookmarkCell") as! SettingBookmarkTableViewCell
            
            return cell
        }
    }
    
    var isVideoOpen = false
    let jeremyGif = UIImage.gifImageWithName("ezgif-3-d2dbde6ebf9a")
    
    
    @IBAction func tutorialVideoTapped(_ sender: Any) {
        
          Analytics.logEvent("set_vc_how_to_install", parameters: nil)
        
        /*
        if !isVideoOpen
        {
            let imageView = UIImageView(image: jeremyGif)
            imageView.tag = 100
            imageView.frame = CGRect(x: view.frame.width/4, y: 50.0, width: self.view.frame.size.width/2, height: self.view.frame.size.height/2)
            view.addSubview(imageView)
            videoTutorialLabel.setTitle("X", for: .normal)
        isVideoOpen = true
        }else
        {
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }else{
            }
            isVideoOpen = false
            videoTutorialLabel.setTitle("影片教學", for: .normal)
        }
        */
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            print("0")
            //page.onDisplay()
        case 1:
            let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
            let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
            let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
            picker.isTimePickerOnly = true
            picker.timeInterval = DateTimePicker.MinuteInterval.thirty
            picker.show()
        print("3")
        case 2:
            print("2")
            bulletinManager.backgroundViewStyle = .none
            bulletinManager.backgroundColor = UIColor(red: 46/255, green: 58/255, blue: 67/255, alpha: 1.00)
        default:
            print("d")
        }
    }*/
    /*
    let page = BLTNPageItem(title: "STATS")
    
    let pag = BLTNActionItem()
    
    lazy var bulletinManager: BLTNItemManager = {
        page.image = UIImage(named: "milestoneIcon")

        page.appearance.titleFontSize = 18
        page.appearance.titleTextColor = .gray
        page.appearance.descriptionTextColor = .white
        
        page.appearance.actionButtonColor = .black
        page.actionButtonTitle = "Pat on the back ✋"
      //  page.
        
        page.appearance.actionButtonColor = .blue
        page.alternativeButtonTitle = "asdf"
        
        page.actionHandler = { (item: BLTNActionItem) in
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)

            self.bulletinManager.dismissBulletin()
        }

        let rootItem: BLTNItem = page

        return BLTNItemManager(rootItem: rootItem)
    }()
    
  /*  lazy var bulletinManager: BLTNItemManager = {
        let introPage = makeIntroPage()
        return BLTNItemManager(rootItem: introPage)
    }()*/
    
    
    func makeIntroPage() -> BLTNActionItem {

        let page = BLTNActionItem()
            
            //FeedbackPageBLTNItem(title: "Welcome to\nPetBoard")
      //  page.image = #imageLiteral(resourceName: "RoundedIcon")
        
        //page.imageAccessibilityLabel = "😻"
        //page.appearance = makeLightAppearance()

        //page.descriptionText = "Discover curated images of the best pets in the world."
        page.actionButtonTitle = "Configure"
        page.alternativeButtonTitle = "Privacy Policy"

        page.isDismissable = true
        page.shouldStartWithActivityIndicator = true
        
        

        page.presentationHandler = { item in

            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                item.manager?.hideActivityIndicator()
            }

        }

        page.actionHandler = { item in
            item.manager?.displayNextItem()
        }

    /*    page.alternativeHandler = { item in
            let privacyPolicyVC = SFSafariViewController(url: URL(string: "https://example.com")!)
            item.manager?.present(privacyPolicyVC, animated: true)
        }

        page.next = makeTextFieldPage()*/

        return page

    }*/
    
    /*
    @IBAction func colorPicked(_ sender: UIButton) {
        
        print(sender.backgroundColor)
        let color = sender.backgroundColor!
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setColor(color: color, forKey: "BackgroundColor")
        tableview.reloadData()
        pickColorView.isHidden = true
        
    }*/
    @IBOutlet weak var colorButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.backgroundColor = .clear
        
        self.tableview.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "notificationTableCell")
        self.tableview.register(UINib(nibName: "UpdateTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "updateTimeTableViewCell")
        self.tableview.register(UINib(nibName: "UpdateBackgroundColorTableViewCell", bundle: nil), forCellReuseIdentifier: "updateBackgroundTableViewCell")
        self.tableview.register(UINib(nibName: "UpdateFontTableViewCell", bundle: nil), forCellReuseIdentifier: "updateFontTableViewCell")
        // Do any additional setup after loading the view.
          
    }
}

extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL? = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL!) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
}
