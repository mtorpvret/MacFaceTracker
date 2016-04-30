//
//  RotatingFaceView.swift
//  MacFaceTracker
//
//  Created by Markus Torpvret on 2016-04-25.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//
// Ansiktets höjd
//  överdel = (högsta y på ögonbryn - lägsta y på öga) / (1 - 0.618)
//  underdel = (lägsta y på näsa - mitten av munnen) / (1-0.618) * 1.618 - halva ögonhöjden
//
// Ansiktets bredd
//  bredden = (högsta x på näsa - lägsta x på näsa) / (1-0.618) * 1.618
//

import UIKit
import FaceTracker

class RotatingFaceView: UIView {
    var facePoints: FacePoints?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func drawRect(rect: CGRect) {
        guard let facePoints = facePoints else { return }
        let context = UIGraphicsGetCurrentContext()
        CGContextSetAlpha(context, 0.4)
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetLineWidth(context, 10)
        
        let leftEye = getMinX(facePoints.leftEye)
        let centerX = leftEye + (getMaxX(facePoints.rightEye) - leftEye) / 2
        let faceWidth = calcFaceWidth()
        let x =  centerX - faceWidth / 2
        let centerY = (getMaxY(facePoints.leftEye) + getMaxY(facePoints.nose)) / 2
        let faceHeight = calcFaceHeight()
        let y = centerY - faceHeight / 2
        CGContextSaveGState(context)
        // calculate angle to rotate
        let deltaY = getMaxY(facePoints.rightEye) - getMaxY(facePoints.leftEye)
        let deltaX = getMinX(facePoints.rightEye) - getMinX(facePoints.leftEye)
        //angleInDegrees = arctan(deltaY / deltaX) * 180 / PI
        let angle: CGFloat = atan(deltaY/deltaX)
        CGContextRotateCTM(context, angle)
        // calculate rotated x & y
        let rotatedCenterX = (centerY*cos(angle) - centerX*sin(angle))
        let rotationDeltaX = rotatedCenterX - centerX
        let rotatedCenterY = (centerY*sin(angle) + centerX*cos(angle))
        let rotationDeltaY = rotatedCenterY - centerY
       // print("rotating \(angle*180/3.14159) degrees: (\(x), \(y)) -> (\(rotatedX), \(rotatedY))")
        CGContextAddEllipseInRect(context, CGRect(x: x-rotationDeltaX, y: y+rotationDeltaY, width: faceWidth, height: faceHeight))
        CGContextDrawPath(context, .Fill)//Stroke)
    
        CGContextAddRect(context, CGRect(x: rotatedCenterX, y: rotatedCenterY, width: faceWidth/2, height: faceHeight/2))
        CGContextDrawPath(context, .Stroke)
        CGContextRestoreGState(context)
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
    
    func getMaxY(points: [CGPoint]) -> CGFloat {
        let max = points.reduce(0, combine: { (y:CGFloat, p: CGPoint) -> CGFloat in y > p.y ? y : p.y })
        return max
    }

    func getMinY(points: [CGPoint]) -> CGFloat {
        return points.reduce(10000, combine: { (y:CGFloat, p: CGPoint) -> CGFloat in y < p.y ? y : p.y })
    }

    func getMaxX(points: [CGPoint]) -> CGFloat {
        return points.reduce(0, combine: { (x:CGFloat, p: CGPoint) -> CGFloat in x > p.x ? x : p.x })
    }
    
    func getMinX(points: [CGPoint]) -> CGFloat {
        return points.reduce(10000, combine: { (x:CGFloat, p: CGPoint) -> CGFloat in x < p.x ? x : p.x })
    }

    func update(facePoints: FacePoints) {
        self.facePoints = facePoints
        self.setNeedsDisplay()
    }
}

