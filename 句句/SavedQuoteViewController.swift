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
                return array.count
            }
        }else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "quote-cell", for: indexPath) as! QuoteTableViewCell
        
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
        

        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        savedQuotes = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedQuoteArray") as? [String] ?? ["還沒有儲存任何語錄"]
        
        savedAuthor = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedAuthorArray") as? [String] ?? [""]
        
        print("quote count \(savedQuotes?.count ?? 1)")
        print("author count \(savedAuthor?.count ?? 1)")
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
