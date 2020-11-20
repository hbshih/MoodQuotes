//
//  UpdateBackgroundColorTableViewCell.swift
//  句句
//
//  Created by Ben on 2020/11/16.
//

import UIKit

class UpdateBackgroundColorTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    @IBOutlet weak var backgrundColor: UIButton!
    @IBAction func backgroundColor(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
