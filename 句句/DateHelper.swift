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
}
