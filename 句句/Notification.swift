import UIKit
import Foundation

struct CustomNotification {

static func everyOtherDay(wtihStartDate startDate: Date) -> [Int]? {

    //
    let currentDate = Date()
    // get initial week day from start date to compare dates
    let weekDay = startDate.weekday

    // Then we need to get week of years for both dates
    let cal = Calendar.current

    guard let weekA = cal.dateComponents([.weekOfYear], from: startDate).weekOfYear else { return nil}

    guard let weekB = cal.dateComponents([.weekOfYear], from: currentDate).weekOfYear else {return nil}

    // create two arrays for week days

    let weekOne = [1,3,5,7]
    let weekTwo = [2,4,6]

    // then we create a module to check if we are in week one or week two

    let currentWeek = (weekA - weekB) % 2

    if currentWeek == 0 {
        //week 1
        return weekOne.contains(weekDay) ? weekOne : weekTwo
    } else {
        // week 2
        return weekOne.contains(weekDay) ? weekTwo : weekOne
    }
}
}
