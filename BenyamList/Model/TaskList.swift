//
//  TaskList.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 29.11.2022.
//

import Foundation

struct TaskList {
    var category: Category
    var tasks: [Task]
    
    var tasksNeedToBeCompleted: Int {
        var count = 0
        for task in tasks {
            if task.status == .overdue {
                count += 1
            }
        }
        return count
    }
}
