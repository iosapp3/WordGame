//
//  SelectionLine.swift
//  WordGame
//
//  Created by Vincent Fan on 3/5/2020.
//  Copyright © 2020 Vincent Fan. All rights reserved.
//

import Foundation
import UIKit

class SelectionLineView: UIView {
    var (x0,y0) : (Int, Int) = (0, 0)
    var selectionLine: CAShapeLayer = CAShapeLayer()
    var startLocation: CGPoint = .zero
    var correctLines: [CAShapeLayer] = []
    var (cols, rows): (Int, Int) = (12, 12)
    var size: CGSize {
        return CGSize(width: bounds.width/CGFloat(cols), height: bounds.height/CGFloat(rows))
    }
    
    private func isValidLine(x: Int, y:Int) -> Bool {
        let vertical = x0 == x
        let horizontal = y0 == y
        let diagonal = abs(x0-x) == abs(y0-y)
        return vertical || horizontal || diagonal
    }
    
    private func toCGPoint(x: Int, y:Int) -> CGPoint {
        return CGPoint(x: CGFloat(Double(x)+0.5) * size.width, y: CGFloat(Double(y)+0.5) * size.height)
    }
    
    private func drawLine(startPoint: CGPoint, endPoint: CGPoint, color: CGColor) {
//        let lineDrawing = CAShapeLayer()
        let line = UIBezierPath()
        line.move(to: startPoint)
        line.addLine(to: endPoint)
        selectionLine.lineCap = .round
        selectionLine.opacity = 0.5
        selectionLine.strokeColor = color
        selectionLine.lineWidth = 25
        selectionLine.path = line.cgPath
//        selectionLine = lineDrawing
        self.layer.addSublayer(selectionLine)
    }
    
    public func beginSelectionLine(x: Int, y: Int) {
        x0 = x
        y0 = y
        startLocation = toCGPoint(x: x, y: y)
        drawLine(startPoint: startLocation, endPoint: startLocation, color: UIColor.yellow.cgColor)
    }
    
    public func continueSelectionLine(x: Int, y: Int) -> Bool {
        let endLocation = toCGPoint(x: x, y: y)
        if isValidLine(x: x, y: y) {
            drawLine(startPoint: startLocation, endPoint: endLocation, color: UIColor.yellow.cgColor)
            return true
        } else {
            return false
        }
    }
    
    public func finishSelectionLine() {
        selectionLine.removeFromSuperlayer()
        selectionLine = CAShapeLayer()
    }
    
    
    public func correctSelectionLine() {
        let answer = lineCopy(target: selectionLine)
        answer.strokeColor = UIColor.PastelRed.cgColor
        self.layer.addSublayer(answer)
        correctLines.append(answer)
        setNeedsLayout()
    }
    
    public func clearAllLines() {
        for line in correctLines {
            line.removeFromSuperlayer()
        }
        correctLines = []
    }
    
    func lineCopy(target: CAShapeLayer) -> CAShapeLayer {
        let copy = CAShapeLayer()
        copy.lineCap = target.lineCap
        copy.opacity = target.opacity
        copy.strokeColor = target.strokeColor
        copy.lineWidth = target.lineWidth
        copy.path = target.path
        return copy
    }
}
