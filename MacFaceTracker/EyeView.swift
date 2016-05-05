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
        guard let leftEye = leftEye else { return }
        guard let rightEye = rightEye else { return }
        
        let color = UIColor.blackColor()
        color.set()
        
        drawEye(leftEye)
        drawEye(rightEye)
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
 
        let eyeWidth = sqrt(pow(points[0].x - points[5].x, 2) + pow(points[0].y - points[5].y, 2))
        let eyeCenter = CGPointMake((points[0].x + points[5].x) / 2, (points[0].y + points[5].y) / 2)
        let irisWidth = eyeWidth*0.4
        
        // Draw Iris
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.blueColor().CGColor)
        CGContextAddEllipseInRect(context, CGRect(x: eyeCenter.x - irisWidth/2, y: eyeCenter.y - irisWidth/2, width: irisWidth, height: irisWidth))
        CGContextDrawPath(context, .Fill)

        // Draw pupil
        let pupilWidth = irisWidth * 0.4
        CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextAddEllipseInRect(context, CGRect(x: eyeCenter.x - pupilWidth/2, y: eyeCenter.y - pupilWidth/2, width: pupilWidth, height: pupilWidth))
        CGContextDrawPath(context, .Fill)
        
    }

    func update(leftEye leftEye: [CGPoint], rightEye: [CGPoint]) {
        self.leftEye = leftEye
        self.rightEye = rightEye
        self.setNeedsDisplay()
    }
}

