//
//  UIExtensions.swift
//  WordGame
//
//  Created by Vincent Fan on 5/5/2020.
//  Copyright © 2020 Vincent Fan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func blockStyle() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 1
    }
}

extension UIButton {
    
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let startValue = NSValue(cgPoint: CGPoint(x: center.x-3, y: center.y))
        let endValue = NSValue(cgPoint: CGPoint(x: center.x+3, y: center.y))
        
        shake.fromValue = startValue
        shake.toValue = endValue
        layer.add(shake, forKey: nil)
    }
}

extension UIColor {
    static let PastelRed = UIColor(red: 255/255, green: 107/255, blue: 107/255, alpha: 1)
}
