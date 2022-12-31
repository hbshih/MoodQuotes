//
//  SavedQuoteViewController.swift
//  句句
//
//  Created by Ben on 2021/7/12.
//

import UIKit
import Instabug

class SavedQuoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var savedQuotes: [String]?
    var savedAuthor: [String]?
    
    @IBOutlet weak var dismissTapped: UIButton!
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        Instabug.logUserEvent(withName: "SavedQuotesViewController_tableview_numberofrow")
        
        if global_savedQuotes.isEmpty
        {
            return 1
        }else
        {
            return global_savedQuotes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        Instabug.logUserEvent(withName: "SavedQuotesViewController_cellforrowat")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "quote-cell", for: indexPath) as! QuoteTableViewCell
        
        
        print ("check count \(global_savedQuotes.count)")
        
        if global_savedQuotes.isEmpty
        {
            Instabug.logUserEvent(withName: "SavedQuotesViewController_emptyquotes")
            cell.authorLabel.text = "尚未儲存任何語錄"
            cell.quoteLabel.text = "尚未儲存任何語錄"
        }else
        {
            Instabug.logUserEvent(withName: "SavedQuotesViewController_loadingquotes")
            if let quotes_and_author = global_savedQuotes[indexPath.row]
            {
                cell.authorLabel.text = quotes_and_author.keys.first
                
                if quotes_and_author.values.first == ""
                {
                    cell.quoteLabel.isHidden = true
                }else
                {
                    cell.quoteLabel.text = quotes_and_author.values.first
                }
            }else
            {
                cell.authorLabel.text = "出現錯誤"
                cell.quoteLabel.text = "出現錯誤"
            }
        }

        /*
        cell.quoteLabel.text = [String] global_savedQuotes.keys[indexPath.row]
        cell.authorLabel.text =
        
        if let array = savedQuotes as? [String]
        {
            if array.contains("還沒有儲存任何語錄") || array.count == 0
            {
                cell.quoteLabel.text = "還沒有儲存任何語錄"
                cell.authorLabel.text = ""
            }else
            {
                cell.quoteLabel.text = savedQuotes![indexPath.item]
                cell.authorLabel.text = savedAuthor![indexPath.item]
            }
        }else
        {
            cell.textLabel!.text = "還沒有儲存任何語錄"
            cell.detailTextLabel!.text = ""
        }
        
*/
        return cell
    }
    
    var sharableQuote = ""
    var sharableAuthor = ""
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = tableView.cellForRow(at: indexPath) as! QuoteTableViewCell
        sharableQuote = currentCell.quoteLabel!.text!
        sharableAuthor = currentCell.authorLabel!.text!
        
        performSegue(withIdentifier: "shareSegue", sender: nil)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Instabug.logUserEvent(withName: "SavedQuotesViewController_Viewdidload")
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
        
        Instabug.logUserEvent(withName: "SavedQuotesViewController_Prepareforsegue")
        
        if segue.identifier == "shareSegue"
        {
            if let VC = segue.destination as? ShareViewController
            {
                
                VC.quoteToShow = sharableQuote
                VC.authorToShow = sharableAuthor
                
            }
        }
    }

}
