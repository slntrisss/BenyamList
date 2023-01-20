//
//  Database.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 29.12.2022.
//

import Foundation

class Database{
    
    static let shared = Database()
    
    var statistics = [Statistics(type: .today),
                      Statistics(type: .overall)]
    
    var cards = [Card(type: .scheduled, icon: "calendar.badge.clock", iconBackgroundColor: "#FD8C3D"),
                 Card(type: .today, icon: "list.bullet.rectangle", iconBackgroundColor: "#2C65FD"),
                 Card(type: .all, icon: "tray.fill", iconBackgroundColor: "#808080"),
                 Card(type: .missed, icon: "calendar.badge.exclamationmark", iconBackgroundColor: "#FD2424")]
    
    var taskLists = [TaskList(category: Category(name: "Tasks", color: .magenta), tasks: [])]
    
    var allCategories:[Category] = [Category(name: "Tasks", color: .magenta)]
    
    var allTasks = [Task]()
    
    private init(){}
}
