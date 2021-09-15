//
//  Date+Month.swift
//  MOYO
//
//  Created by User on 12/12/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMM")
        return df.string(from: self)
    }
    
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = searchWeekdayIndex
        
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
}
    
    extension Date {
        func getWeekDaysInEnglish() -> [String] {
            var calendar = Calendar(identifier: .gregorian)
            calendar.locale = Locale(identifier: "en_US_POSIX")
            return calendar.weekdaySymbols
        }
        
        enum Weekday: String {
            case monday, tuesday, wednesday, thursday, friday, saturday, sunday
        }
        
        enum SearchDirection {
            case Next
            case Previous
            
            var calendarSearchDirection: Calendar.SearchDirection {
                switch self {
                case .Next:
                    return .forward
                case .Previous:
                    return .backward
                }
            }
        }
}
