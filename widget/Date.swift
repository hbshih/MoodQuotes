//
//  Date.swift
//  句句
//
//  Created by Ben on 2020/11/26.
//

import Foundation

struct Date_Manager
{
    func getWidgetDisplayDate() -> String
    {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        let date_today = dateFormatter.string(from: Date())
        return date_today
    }
}
