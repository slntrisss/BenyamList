//
//  Card.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 29.11.2022.
//

import Foundation

struct Card{
    let type: CardType
    var totalNumberOfTasks: Int {
        var count = 0
        let database = Database.shared
        switch self.type{
        case .today:
            for task in database.allTasks{
                if let deadline = task.deadline, Calendar.current.isDateInToday(deadline){
                    count += 1
                }
            }
        case .missed:
            for task in database.allTasks{
                if task.status == .completed{
                    count += 1
                }
            }
        case .scheduled:
            for task in database.allTasks{
                if task.deadline != nil{
                    count += 1
                }
            }
        default:
            count += database.allTasks.count
        }
        return count
    }
    var icon: String
    let iconBackgroundColor:String
    enum CardType: String{
        case all, today, scheduled, missed
    }
}
