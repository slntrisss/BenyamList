//
//  Statistics.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 29.11.2022.
//

import Foundation

struct Statistics{
    var totalNumberOfTasks: Int
    var completedNumberOfTasks: Int
    let type: StatisticsType
    
    enum StatisticsType: String{
        case overall, today
    }
}
