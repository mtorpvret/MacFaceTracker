//
//  FaceView.swift
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
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
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
        setAnchorPoint(CGPointMake(0.5, 0.5), forView: self)
        
        let angle = atan2(rightEye[5].y - leftEye[0].y, rightEye[5].x - leftEye[0].x)
        transform = CGAffineTransformMakeRotation(angle)
    }
    
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
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

