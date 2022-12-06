//
//  Extension+Date.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 02.12.2022.
//

import Foundation

extension Date{
    
    func getDayOfTheMonth() -> String {
        let day = Calendar.current.dateComponents([.day], from: self).day!
        if day < 10 {
            return "0\(day)"
        }
        return "\(day)"
    }
}
