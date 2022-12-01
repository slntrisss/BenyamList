//
//  Extension+UIView.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 30.11.2022.
//

import Foundation
import UIKit
extension UIView{
    public var width: CGFloat{
        return self.frame.size.width
    }
    
    public var height: CGFloat{
        return self.frame.size.height
    }
    
    public var top: CGFloat{
        return self.frame.origin.y
    }
    
    public var bottom: CGFloat{
        return self.frame.size.height + self.frame.origin.y
    }
    
    public var left:CGFloat{
        return self.frame.origin.x
    }
    
    public var right: CGFloat{
        return self.frame.size.width + self.frame.origin.x
    }
    
    func anchor(leading: NSLayoutXAxisAnchor?, top: NSLayoutYAxisAnchor?,
                trailing: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?,
                padding: UIEdgeInsets = .zero, size: CGSize = .zero){
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: padding.right).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
    }
    
    func sizeAnchor(width: CGFloat, height: CGFloat){
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
