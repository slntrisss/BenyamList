//
//  UILabelPadding.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 07.12.2022.
//

import Foundation
import UIKit
class UILabelPadding: UILabel{
    
    let padding = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
}
