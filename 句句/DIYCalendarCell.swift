//
//  DIYCalendarCell.swift
//  FSCalendarSwiftExample
//
//  Created by dingwenchao on 06/11/2016.
//  Copyright © 2016 wenchao. All rights reserved.
//

import Foundation

import FSCalendar

import UIKit

enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}


class DIYCalendarCell: FSCalendarCell {
    
    weak var superhappyImageView: UIImageView!
    weak var happyImageView: UIImageView!
    weak var neutralImageView: UIImageView!
    weak var sadImageView: UIImageView!
    weak var supersadImageView: UIImageView!
    
    weak var selectionLayer: CAShapeLayer!
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let superhappyImageView = UIImageView(image: UIImage(named: "super-happy")!)
        let happyImageView = UIImageView(image: UIImage(named: "happy")!)
        let neutralImageView = UIImageView(image: UIImage(named: "neutral")!)
        let sadImageView = UIImageView(image: UIImage(named: "sad")!)
        let supersadImageView = UIImageView(image: UIImage(named: "super-sad")!)
       // let circleImageView2 = UIImageView(image: UIImage(named: "noun_bookmark_4007674")!)
        
        superhappyImageView.contentMode = UIView.ContentMode.scaleAspectFit
        happyImageView.contentMode = UIView.ContentMode.scaleAspectFit
        neutralImageView.contentMode = UIView.ContentMode.scaleAspectFit
        sadImageView.contentMode = UIView.ContentMode.scaleAspectFit
        supersadImageView.contentMode = UIView.ContentMode.scaleAspectFit

        self.contentView.insertSubview(superhappyImageView, at: 0)
        self.contentView.insertSubview(happyImageView, at: 0)
        self.contentView.insertSubview(neutralImageView, at: 0)
        self.contentView.insertSubview(sadImageView, at: 0)
        self.contentView.insertSubview(supersadImageView, at: 0)
        
        self.superhappyImageView = superhappyImageView
        self.happyImageView = happyImageView
        self.neutralImageView = neutralImageView
        self.sadImageView = sadImageView
        self.supersadImageView = supersadImageView
        
       /* let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.black.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer */
        
        self.shapeLayer.isHidden = true
        
        /*
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.12)
        self.backgroundView = view;
        */
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.superhappyImageView.frame = self.contentView.bounds
        self.happyImageView.frame = self.contentView.bounds
        self.neutralImageView.frame = self.contentView.bounds
        self.sadImageView.frame = self.contentView.bounds
        self.supersadImageView.frame = self.contentView.bounds
        
        /*
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = self.contentView.bounds
        
        if selectionType == .middle {
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
        }
        else if selectionType == .leftBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .rightBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .single {
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        }*/
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
          // self.appearance.todayColor = UIColor.lightGray
           // self.appearance.titleTodayColor = UIColor.lightGray
            //self.preferredTitleDefaultColor = UIColor.blue
            //self.title
        }
    }
    
}
