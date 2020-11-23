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


class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var pickColorView: UIView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
          // cell.timePicker.
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "updateBackgroundTableViewCell") as! UpdateBackgroundColorTableViewCell
            let defaults = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!
            if let color = defaults.colorForKey(key: "BackgroundColor") as? UIColor
            {
                cell.backgrundColor.backgroundColor = color
            }
            print("reload color")
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "updateBackgroundTableViewCell") as! UpdateBackgroundColorTableViewCell
            
            let defaults = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!
            let color = defaults.colorForKey(key: "BackgroundColor") as! UIColor
            print("reload color")
            print(color)
            cell.backgrundColor.backgroundColor = color
            return cell
        }
    }
    
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
           // bulletinManager.show
            pickColorView.isHidden = false
            
            self.view.bringSubviewToFront(pickColorView)
        
   //         bulletinManager.showBulletin(in: self, animated: true, completion: nil)
            
            
            
        default:
            print("d")
        }
    }
    
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

    }
    
    @IBAction func colorPicked(_ sender: UIButton) {
        
        print(sender.backgroundColor)
        
        let color = sender.backgroundColor!
        
        
        
        
        
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setColor(color: color, forKey: "BackgroundColor")
        tableview.reloadData()
        pickColorView.isHidden = true
        
    }
    @IBOutlet weak var colorButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.backgroundColor = .clear
        
        self.tableview.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "notificationTableCell")
        self.tableview.register(UINib(nibName: "UpdateTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "updateTimeTableViewCell")
        self.tableview.register(UINib(nibName: "UpdateBackgroundColorTableViewCell", bundle: nil), forCellReuseIdentifier: "updateBackgroundTableViewCell")
        // Do any additional setup after loading the view.
          
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

