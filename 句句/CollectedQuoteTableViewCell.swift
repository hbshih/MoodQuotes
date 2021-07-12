//
//  CollectedQuoteTableViewCell.swift
//  句句
//
//  Created by Ben on 2021/7/12.
//

import UIKit

class CollectedQuoteTableViewCell: UITableViewCell {

    @IBOutlet weak var quote: UILabel!
    @IBOutlet weak var author: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
