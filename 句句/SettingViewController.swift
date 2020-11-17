//
//  SettingViewController.swift
//  句句
//
//  Created by Ben on 2020/11/14.
//

import UIKit
import DateTimePicker
import BLTNBoard

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableview: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.item {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "notificationTableCell") as! NotificationTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "updateTimeTableViewCell") as! UpdateTimeTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "updateBackgroundTableViewCell") as! UpdateBackgroundColorTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "updateBackgroundTableViewCell") as! UpdateBackgroundColorTableViewCell
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
        default:
            print("d")
        }
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
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
