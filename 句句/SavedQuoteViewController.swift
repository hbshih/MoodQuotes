//
//  SavedQuoteViewController.swift
//  句句
//
//  Created by Ben on 2021/7/12.
//

import UIKit

class SavedQuoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dismissTapped: UIButton!
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedQuoteArray") as? [String]
        {
            if array.count == 0
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
        
            if let quote = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedQuoteArray") as? [String]
            {
                if quote.count > 0
                {
                    let author = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.array(forKey: "savedAuthorArray") as? [String]
                    cell.quoteLabel.text = quote[indexPath.item]
                    cell.authorLabel.text = author![indexPath.item]
                }else
                {
                    cell.quoteLabel.text = "還沒有儲存任何語錄"
                }

            }else
            {
                cell.quoteLabel.text = "還沒有儲存任何語錄"
            }
            
        

        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
