//
//  FaceView.swift
//  MacFaceTracker
//
//  Created by Markus Torpvret on 2016-04-25.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//
// Calculations below only works as intended when there is no face rotation, otherwise compensation is needed.
// Should use trigonometry, but too lazy so far.
//
// Face height
//  upper part = (max y of brows - min y of eye) / (1 - 0.618)
//  lower part = (min y of nose - middle y of mouth) / (1-0.618) * 1.618 - half eye height
//
// Face width
//  width = (max x of nose - min x of nose) / (1-0.618) * 1.618
//

import UIKit
import FaceTracker

class FaceView: UIView {
    var facePoints: FacePoints?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func drawRect(rect: CGRect) {
        guard let leftEye = facePoints?.leftEye else { return }
        guard let rightEye = facePoints?.rightEye else { return }
        guard let nose = facePoints?.nose else { return }
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetAlpha(context, 0.4)
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextSetLineWidth(context, 10)
        
        let leftEyeMinX = getMinX(leftEye)
        let centerX = leftEyeMinX + (getMaxX(rightEye) - leftEyeMinX) / 2
        let faceWidth = calcFaceWidth()
        let x =  centerX - faceWidth / 2
        let centerY = (getMaxY(leftEye) + getMaxY(nose)) / 2
        let faceHeight = calcFaceHeight()
        let y = centerY - faceHeight / 2
        CGContextAddEllipseInRect(context, CGRect(x: x, y: y, width: faceWidth, height: faceHeight))
        CGContextDrawPath(context, .Fill)
        
        transform = CGAffineTransformIdentity
        setAnchorPoint(CGPointMake(0.5, 0.5))
        
        let angle = calcAngleFrom(leftEye[0], to: rightEye[5])
        transform = CGAffineTransformMakeRotation(angle)
    }
    
    func calcFaceHeight() -> CGFloat {
        let u = (getMaxY(facePoints!.leftEye) - getMinY(facePoints!.leftBrow)) / 0.382
        let l = ((getMinY(facePoints!.innerMouth) + getMaxY(facePoints!.innerMouth) / 2) - getMaxY(facePoints!.nose)) / 0.618 -
        (getMinY(facePoints!.leftEye) + getMaxY(facePoints!.leftEye)) / 4
        return u+l
    }
    
    func calcFaceWidth() -> CGFloat {
        return (getMaxX(facePoints!.nose) - getMinX(facePoints!.nose)) / 0.309
    }
    
    func update(facePoints: FacePoints) {
        self.facePoints = facePoints
        self.setNeedsDisplay()
    }
}

