//
//  EyeView.swift
//  MacFaceTracker
//
//  Created by Markus Torpvret on 2016-04-30.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import UIKit

class EyeView: UIView {
    var leftEye: [CGPoint]?
    var rightEye: [CGPoint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func drawRect(rect: CGRect) {
        let color = UIColor.blackColor()
        color.set()
        
        if let points = leftEye {
            drawEye(points)
        }
        if let points2 = rightEye {
            drawEye(points2)
        }
    }

    func drawEye(points: [CGPoint]) {
        let path = CGPathCreateMutable()
        for (index, point) in points.enumerate() {
            if(index == 0) {
                CGPathMoveToPoint(path, nil, point.x, point.y);
            }
            else {
                CGPathAddLineToPoint(path, nil, point.x, point.y);
            }
        }
        CGPathCloseSubpath(path)
        let x = UIBezierPath(CGPath: path)
        x.lineWidth = 2
        x.stroke()
        
        
    }

    func update(leftEye leftEye: [CGPoint], rightEye: [CGPoint]) {
        self.leftEye = leftEye
        self.rightEye = rightEye
        self.setNeedsDisplay()
    }
}

