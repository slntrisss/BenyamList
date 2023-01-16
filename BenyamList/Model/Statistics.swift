//
//  Statistics.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 29.11.2022.
//

import Foundation

struct Statistics{
    var totalNumberOfTasks: Int {
        var count = 0
        if self.type == .overall{
            count = Database.shared.allTasks.count
        }
        else if self.type == .today{
            let allTasks = Database.shared.allTasks
            let calendar = Calendar.current
            for task in allTasks {
                if let deadline = task.deadline, calendar.isDateInToday(deadline){
                    count += 1
                }
            }
        }
        return count
    }
    var completedNumberOfTasks: Int
    let type: StatisticsType
    
    enum StatisticsType: String{
        case overall, today
    }
}
