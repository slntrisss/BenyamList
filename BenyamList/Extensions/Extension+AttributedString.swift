//
//  Extension+AttributedString.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 20.01.2023.
//

import Foundation

extension NSAttributedString{
    func withStrikeThrough(_ style: Int = 1) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttribute(.strikethroughStyle,
                                      value: style,
                                      range: NSRange(location: 0, length: string.count))
        return NSAttributedString(attributedString: attributedString)
    }
}
