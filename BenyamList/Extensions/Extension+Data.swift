//
//  Extension+Data.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 29.11.2022.
//

import Foundation

extension MainViewController{
    func initData(){
        initStatisticsData()
        initCardsData()
    }
    
    private func initStatisticsData(){
        statistics.append(Statistics(totalNumberOfTasks: 86, completedNumberOfTasks: 54, type: .today))
        statistics.append(Statistics(totalNumberOfTasks: 176, completedNumberOfTasks: 78, type: .overall))
    }
    private func initCardsData(){
        cards.append(Card(type: .scheduled, totalNumberOfTasks: 67, icon: "calendar.badge.clock", iconBackgroundColor: "#FD8C3D"))
        cards.append(Card(type: .today, totalNumberOfTasks: 43, icon: "list.bullet.rectangle", iconBackgroundColor: "#2C65FD"))
        cards.append(Card(type: .all, totalNumberOfTasks: 110, icon: "tray.fill", iconBackgroundColor: "#808080"))
        cards.append(Card(type: .missed, totalNumberOfTasks: 3, icon: "calendar.badge.exclamationmark", iconBackgroundColor: "#FD2424"))
    }
}
