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
    
    public func anchor(leading: NSLayoutXAxisAnchor?, top: NSLayoutYAxisAnchor?,
                trailing: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?,
                padding: UIEdgeInsets = .zero, size: CGSize = .zero){
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != .zero {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != .zero {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
    }
    
    public func sizeAnchor(width: CGFloat, height: CGFloat, padding: UIEdgeInsets = .zero){
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    public func centerAnchor(centerX: NSLayoutXAxisAnchor?, centerY: NSLayoutYAxisAnchor?, xPadding: CGFloat, yPadding: CGFloat){
        
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX, constant: xPadding).isActive = true
        }
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY, constant: yPadding).isActive = true
        }
    }
    
}
