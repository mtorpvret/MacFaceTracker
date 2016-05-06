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
        
        drawEye(leftEye)
        drawEye(rightEye)
    }

    func drawEye(points: [CGPoint]) {
//        let eyeWidth = sqrt(pow(points[0].x - points[5].x, 2) + pow(points[0].y - points[5].y, 2))
        let eyeHeight = sqrt(pow(points[2].x - points[8].x, 2) + pow(points[2].y - points[8].y, 2))
        let eyeCenter = CGPointMake((points[0].x + points[5].x) / 2, (points[0].y + points[5].y) / 2)
        let irisWidth = eyeHeight //eyeWidth*0.4
        
        // Draw Iris
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.blueColor().CGColor)
        let iPath = CGPathCreateMutable()
        CGPathAddArc(iPath, nil, eyeCenter.x, eyeCenter.y, irisWidth/2, calcAngle(eyeCenter, p2: points[3]), calcAngle(eyeCenter, p2: points[7]), true)
        CGPathAddArc(iPath, nil, eyeCenter.x, eyeCenter.y, irisWidth/2, calcAngle(eyeCenter, p2: points[8]), calcAngle(eyeCenter, p2: points[2]), true)
        CGPathCloseSubpath(iPath)
        CGContextAddPath(context, iPath)
        CGContextDrawPath(context, .Fill)
        
        // Draw pupil
        let pupilWidth = irisWidth * 0.4
        CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextAddEllipseInRect(context, CGRect(x: eyeCenter.x - pupilWidth/2, y: eyeCenter.y - pupilWidth/2, width: pupilWidth, height: pupilWidth))
        CGContextDrawPath(context, .Fill)

        // Draw eye outline
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
        CGContextAddPath(context, path)
        CGContextSetLineWidth(context, 2.0)
        CGContextDrawPath(context, .Stroke)
    }
    
    func update(leftEye leftEye: [CGPoint], rightEye: [CGPoint]) {
        self.leftEye = leftEye
        self.rightEye = rightEye
        self.setNeedsDisplay()
    }
}

