//
//  EyebrowView.swift
//  MacFaceTracker
//
//  Created by Markus Torpvret on 2016-04-25.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import UIKit

class EyebrowView: UIView {
    var leftBrow: [CGPoint]?
    var rightBrow: [CGPoint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func drawRect(rect: CGRect) {
        let browPattern = UIImage(named: "BrowPattern.png")
        let color = UIColor(patternImage: browPattern!)
        
        color.set()
        
        if let points = leftBrow {
            let path = CGPathCreateMutable()
            var startPoint: CGPoint?
            for (index, point) in points.enumerate() {
                if(index == 0) {
                    startPoint = point
                    CGPathMoveToPoint(path, nil, point.x, point.y);
                }
                else {
                    CGPathAddLineToPoint(path, nil, point.x, point.y);
                }
            }
            CGPathAddLineToPoint(path, nil, startPoint!.x, startPoint!.y)
            CGPathCloseSubpath(path)
            let x = UIBezierPath(CGPath: path)
            x.fill()
            
            let iPath = CGPathCreateMutable()
            if let points = rightBrow {
                for (index, point) in points.enumerate() {
                    if(index == 0) {
                        CGPathMoveToPoint(iPath, nil, point.x, point.y);
                    }
                    else {
                        CGPathAddLineToPoint(iPath, nil, point.x, point.y);
                    }
                }
            }
            CGPathCloseSubpath(iPath)
           // CGContextSetBlendMode(UIGraphicsGetCurrentContext(), CGBlendMode.Lighten)
            let y = UIBezierPath(CGPath: iPath)
            y.fill()
            
        }
    }
    
    func update(leftBrow leftBrow: [CGPoint], rightBrow: [CGPoint]) {
        self.leftBrow = leftBrow
        self.rightBrow = rightBrow
        self.setNeedsDisplay()
    }
}

