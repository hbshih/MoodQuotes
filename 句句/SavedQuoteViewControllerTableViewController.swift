//
//  SavedQuoteViewControllerTableViewController.swift
//  句句
//
//  Created by Ben on 2021/7/12.
//

import UIKit
import FirebaseAnalytics

class SavedQuoteViewControllerTableViewController: UITableViewController {
    
    var savedQuotes: [String]?
    var savedAuthor: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedQuotes = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedQuoteArray") as? [String] ?? ["還沒有儲存任何語錄"]
        
        savedAuthor = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedAuthorArray") as? [String] ?? [""]
        
        print("quote count \(savedQuotes?.count ?? 1)")
        print("author count \(savedAuthor?.count ?? 1)")
        
        self.tableView.register(CollectedQuoteTableViewCell.self, forCellReuseIdentifier: "savedQuoteCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        Analytics.logEvent("saved_quotes_opened", parameters: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if let array = savedQuotes as? [String]
        {
            if array.contains("還沒有儲存任何語錄")
            {
                return 1
            }else if array.count == 0
            {
                return 1
            }else
            {
                return array.count - 1
            }
        }else
        {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "savedQuoteCell")
        
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        
        if let array = savedQuotes as? [String]
        {
            if array.contains("還沒有儲存任何語錄") || array.count == 0
            {
                cell.textLabel!.text = "還沒有儲存任何語錄"
                cell.detailTextLabel!.text = ""
            }else
            {
                cell.textLabel!.text = array[indexPath.item]
                cell.detailTextLabel!.text = array[indexPath.item]
            }
        }else
        {
            cell.textLabel!.text = "還沒有儲存任何語錄"
            cell.detailTextLabel!.text = ""
        }
        

            
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
