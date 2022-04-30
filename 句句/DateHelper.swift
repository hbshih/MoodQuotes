//
//  DateHelper.swift
//  句句
//
//  Created by Ben on 2020/11/25.
//

import Foundation




extension Date {

public var weekday: Int {
    return Calendar.current.component(.weekday, from: self)
}

public var hour: Int {
    get {
        return Calendar.current.component(.hour, from: self)
    }
    set {
        let allowedRange = Calendar.current.range(of: .hour, in: .day, for: self)!
        guard allowedRange.contains(newValue) else { return }

        let currentHour = Calendar.current.component(.hour, from: self)
        let hoursToAdd = newValue - currentHour
        if let date = Calendar.current.date(byAdding: .hour, value: hoursToAdd, to: self) {
            self = date
        }
    }
}

public var minute: Int {
    get {
        return Calendar.current.component(.minute, from: self)
    }
    set {
        let allowedRange = Calendar.current.range(of: .minute, in: .hour, for: self)!
        guard allowedRange.contains(newValue) else { return }

        let currentMinutes = Calendar.current.component(.minute, from: self)
        let minutesToAdd = newValue - currentMinutes
        if let date = Calendar.current.date(byAdding: .minute, value: minutesToAdd, to: self) {
            self = date
        }
    }
}

    public var getTodayDate: String
    {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyyy年MM月dd日"
        return formatter3.string(from: Date())
       // print(formatter3.string(from: today))
    }
    
    public var getFormattedDate: String
    {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyyy-MM-dd"
        return formatter3.string(from: Date())
       // print(formatter3.string(from: today))
    }
    
    public var getMonthDay: String
    {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "MM/dd"
        return formatter3.string(from: Date())
       // print(formatter3.string(from: today))
    }
    
    public var getDateDayOnly: String
    {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "dd"
        return formatter3.string(from: Date())
       // print(formatter3.string(from: today))
    }
    
    public var getDate: String
    {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyyy年MM月"
        return formatter3.string(from: Date())
       // print(formatter3.string(from: today))
    }
    
    public var getTWday: String
    {
        let formatter3 = DateFormatter()
       // let weekday = Calendar.current.component(.weekday, from: Date())
        formatter3.locale = Locale(identifier: "zh_Hant_TW")
        formatter3.dateFormat = "EEEE"
       // formatter3.weekdaySymbols
        return formatter3.string(from: Date())
       // print(formatter3.string(from: today))
    }

    public var getLunarDate: String
    {
        let formatter3 = DateFormatter()
       // let weekday = Calendar.current.component(.weekday, from: Date())
        formatter3.dateStyle = .long
        formatter3.timeStyle = .none
        formatter3.locale = Locale.init(identifier: "zh_Hant_TW")
        formatter3.calendar = Calendar.init(identifier: .chinese)
       // formatter3.dateFormat = "M月dd"
       // formatter3.weekdaySymbols
        return String((formatter3.string(from: Date())).suffix(4))
       // print(formatter3.string(from: today))
    }
    
}

