//
//  DIYViewController.swift
//  FSCalendarSwiftExample
//
//  Created by dingwenchao on 06/11/2016.
//  Copyright © 2016 wenchao. All rights reserved.
//

import Foundation
import FSCalendar

class DIYExampleViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    //fileprivate weak var calendar: FSCalendar!
    fileprivate weak var eventLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    
    // MARK:- Life cycle
    
    override func loadView() {
        super.loadView()
        
        if let moodList = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.dictionary(forKey: "moodList")
        {
            if moodList.isEmpty || moodList.count < 1
            {
                // default
            }else
            {
                let converted = moodList.compactMapValues { $0 as? String }
                self.moodList = converted
            //    fillSelectionColors = moodList
            }
        }
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = false
        calendar.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.appearance.eventSelectionColor = UIColor.black
        calendar.appearance.borderSelectionColor = UIColor.red
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        calendar.today = nil // Hide the today circle
        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
        
        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
        calendar.addGestureRecognizer(scopeGesture)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "FSCalendar"
        let dates = [
            Date()
        ]
        dates.forEach { (date) in
            self.calendar.select(date, scrollToDate: false)
        }
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
    }
    
    // MARK:- FSCalendarDataSource
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        if self.gregorian.isDateInToday(date) {
            calendar.appearance.titleTodayColor = UIColor.black
            return "今"
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    // MARK:- FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
        self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.formatter.string(from: date))")
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        print("did deselect date \(self.formatter.string(from: date))")
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if self.gregorian.isDateInToday(date) {
            return [UIColor.orange]
        }
        return [appearance.eventDefaultColor]
    }
    
    // MARK: - Private functions
    
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    var moodList = ["2022-03-22": "happy", "2022-03-26": "sad"]
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! DIYCalendarCell)
        // Custom today circle
     //   diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        diyCell.superhappyImageView.isHidden = true
        diyCell.happyImageView.isHidden = true
        diyCell.neutralImageView.isHidden = true
        diyCell.sadImageView.isHidden = true
        diyCell.supersadImageView.isHidden = true
        
        let dateString = self.dateFormatter2.string(from: date)
        
            //    print(fillSelectionColors.keys)
      //  print(dateString)
        
        if moodList.keys.contains(dateString)
        {
            diyCell.titleLabel.text = ""
            cell.preferredTitleDefaultColor = UIColor(red: 96.5, green: 88.6, blue: 80.4, alpha: 1.0)
            
            diyCell.preferredTitleDefaultColor = UIColor(red: 96.5, green: 88.6, blue: 80.4, alpha: 1.0)
            
            switch moodList[dateString] {
            case "super-happy":
                diyCell.superhappyImageView.isHidden = false
                
                
             //   96.5, 88.6, 80.4
            case "happy":
                diyCell.happyImageView.isHidden = false
            case "neutral":
                diyCell.neutralImageView.isHidden = false
            case "sad":
                diyCell.sadImageView.isHidden = false
            case "super-sad":
                diyCell.supersadImageView.isHidden = false
            default:
                print("nothing")
            }
        //    print("found match")
        //    diyCell.circleImageView2.isHidden = false
        }
        
        // Configure selection layer
        /*
        if position == .current {
            
            var selectionType = SelectionType.none
            
            if calendar.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if calendar.selectedDates.contains(date) {
                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    }
                    else if calendar.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
            
        } else {
            diyCell.circleImageView.isHidden = true
            diyCell.selectionLayer.isHidden = true
        }*/
    }
    
}

