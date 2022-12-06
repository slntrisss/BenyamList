//
//  WeekDays.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 01.12.2022.
//

import Foundation

struct WeekDays{
    let daysOfTheWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var weekDate: [Date]
    
    
    static func getData() -> WeekDays {
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = 2
        let today = calendar.startOfDay(for: Date())
        var weekDate = [Date]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    weekDate.append(day)
                }
            }
        }
        
        return WeekDays(weekDate: weekDate)
    }
}
