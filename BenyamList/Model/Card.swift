//
//  Card.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 29.11.2022.
//

import Foundation

struct Card{
    let type: CardType
    var totalNumberOfTasks: Int
    var icon: String
    let iconBackgroundColor:String
    enum CardType: String{
        case all, today, scheduled, missed
    }
}
