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
    
    let browPattern: UIImage?
    
    override init(frame: CGRect) {
        browPattern = UIImage(named: "BrowPattern.png")
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        browPattern = UIImage(named: "BrowPattern.png")
        super.init(coder: aDecoder)
    }

    override func drawRect(rect: CGRect) {
        guard let leftBrow = leftBrow else { return }
        guard let rightBrow = rightBrow else { return }
        
        drawBrow(leftBrow)
        drawBrow(rightBrow)
        }
    

    func drawBrow(points: [CGPoint]) {
        var color = UIColor.brownColor()
        if let browPattern = browPattern {
            color = UIColor(patternImage: browPattern)
        }
        
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
        let context = UIGraphicsGetCurrentContext()
        CGContextAddPath(context, path)
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextDrawPath(context, .Fill)
    }
    
    func update(leftBrow leftBrow: [CGPoint], rightBrow: [CGPoint]) {
        self.leftBrow = leftBrow
        self.rightBrow = rightBrow
        self.setNeedsDisplay()
    }
}

