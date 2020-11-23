//
//  UpdateBackgroundColorTableViewCell.swift
//  句句
//
//  Created by Ben on 2020/11/16.
//

import UIKit
import PopupDialog

class UpdateBackgroundColorTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    @IBOutlet weak var backgrundColor: UIButton!
    @IBAction func backgroundColor(_ sender: Any) {
        
        // Create a custom view controller
        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)

        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
    
        // Create second button
        let buttonTwo = DefaultButton(title: "儲存", height: 60) {
       //     self.label.text = "You rated \(ratingVC.cosmosStarRating.rating) stars"
        }

        // Add buttons to dialog
        popup.addButtons([buttonTwo])

        // Present dialog
        
        //self.window.viewcon
        
        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
        
     //   self.window?.rootViewController?.present(popup, animated: true, completion: nil)
   //     present(popup, animated: true, completion: nil)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UIApplication {
    class func topViewController(viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(viewController: nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(viewController: selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(viewController: presented)
        }
        return viewController
    }
}
