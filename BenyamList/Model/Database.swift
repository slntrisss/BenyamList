//
//  Database.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 29.12.2022.
//

import Foundation

class Database{
    
    static let shared = Database()
    
    var statistics = [Statistics(totalNumberOfTasks: 86, completedNumberOfTasks: 54, type: .today),
                      Statistics(totalNumberOfTasks: 176, completedNumberOfTasks: 78, type: .overall)]
    
    var cards = [Card(type: .scheduled, totalNumberOfTasks: 67, icon: "calendar.badge.clock", iconBackgroundColor: "#FD8C3D"),
                 Card(type: .today, totalNumberOfTasks: 43, icon: "list.bullet.rectangle", iconBackgroundColor: "#2C65FD"),
                 Card(type: .all, totalNumberOfTasks: 110, icon: "tray.fill", iconBackgroundColor: "#808080"),
                 Card(type: .missed, totalNumberOfTasks: 3, icon: "calendar.badge.exclamationmark", iconBackgroundColor: "#FD2424")]
    
    var taskLists = [TaskList(category: Category(name: "Work", color: .dodgerBlue),
                              tasks: [Task(title: "Leetcode", creatationDate: Date.now, category: Category(name: "Work", color: .dodgerBlue), priority: .low),
                                      Task(title: "Swift", creatationDate: Date.now, category: Category(name: "Work", color: .dodgerBlue), priority: .urgent)
                                     ]),
                     TaskList(category: Category(name: "Workout", color: .mediumSlateBlue),
                              tasks: [Task(title: "Jumping rope", creatationDate: Date.now, category: Category(name: "Work", color: .dodgerBlue), priority: .urgent)])]
    
    lazy var allCategories = [Category(name: "All", color: .gold),
                              Category(name: "Work", color: .dodgerBlue),
                              Category(name: "Travel", color: .cyan),
                              Category(name: "Workout", color: .mediumSlateBlue),
                              Category(name: "Movies", color: .magenta)]
    
    var allTasks = [Task(title: "Leetcode", creatationDate: Date.now, category: Category(name: "Work", color: .dodgerBlue), priority: .low),
                    Task(title: "Swift", creatationDate: Date.now, category: Category(name: "Work", color: .dodgerBlue), priority: .urgent),
                    Task(title: "Travel", creatationDate: Date.now, category: Category(name: "Travel", color: .cyan), priority: .medium),
                    Task(title: "Jumping rope", creatationDate: Date.now, category: Category(name: "Work", color: .dodgerBlue), priority: .urgent)]
    
    private init(){}
}
