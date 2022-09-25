//
//  SavedQuoteViewController.swift
//  句句
//
//  Created by Ben on 2021/7/12.
//

import UIKit

class SavedQuoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var savedQuotes: [String]?
    var savedAuthor: [String]?
    
    @IBOutlet weak var dismissTapped: UIButton!
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return global_savedQuotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "quote-cell", for: indexPath) as! QuoteTableViewCell
        
        let quotes_and_author = global_savedQuotes[indexPath.row]
        cell.authorLabel.text = quotes_and_author!.keys.first
        cell.quoteLabel.text = quotes_and_author!.values.first

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
