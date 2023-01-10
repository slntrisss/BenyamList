//
//  Task.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 29.11.2022.
//

import Foundation

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var details: String?
    var deadline: Date?
    var creatationDate = Date.now
    var status:Status = .overdue
    var category = Category(name: "All", color: .dodgerBlue)
    var priority: Priority = .defualt
}
