//
//  Extension+UIColor.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 29.11.2022.
//

import Foundation
import UIKit
extension UIColor{
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func getColor(from color: CategoryColor) -> UIColor{
        switch(color){
        case .lightSalmon:
            return hexStringToUIColor(hex: "#FFA07A")
        case .red:
            return hexStringToUIColor(hex: "#FF0000")
        case .lightPink:
            return hexStringToUIColor(hex: "#FFB6C1")
        case .orange:
            return hexStringToUIColor(hex: "#FFA500")
        case .gold:
            return hexStringToUIColor(hex: "#FFD700")
        case .magenta:
            return hexStringToUIColor(hex: "#FF00FF")
        case .mediumSlateBlue:
            return hexStringToUIColor(hex: "#7B68EE")
        case .cyan:
            return hexStringToUIColor(hex: "#00FFFF")
        default:
            return hexStringToUIColor(hex: "#1E90FF")
        }
    }
    
    static func getStatusColor(from status: Status) -> UIColor{
        switch(status){
        case .completed:
            return hexStringToUIColor(hex: "#33AE02")
        case .overdue:
            return UIColor.systemBlue
        default:
            return UIColor.red
        }
    }
    
    static func getPriorityColor(from priority: Priority) -> UIColor{
        switch(priority){
        case .urgent:
            return UIColor.red
        case .medium:
            return hexStringToUIColor(hex: "#FFB339")
        default:
            return hexStringToUIColor(hex: "#CED700")
        }
    }
}
