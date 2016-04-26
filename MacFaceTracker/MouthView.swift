//
//  MouthView.swift
//  MacFaceTracker
//
//  Created by Markus Torpvret on 2016-04-25.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import UIKit

class MouthView: UIView {
    var innerMouth: [CGPoint]?
    var outerMouth: [CGPoint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func drawRect(rect: CGRect) {
        let color:UIColor = UIColor.redColor()
        
        color.set()
        
        if let points = outerMouth {
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
            x.fill()
            
            let iPath = CGPathCreateMutable()
            if let points = innerMouth {
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
            let y = UIBezierPath(CGPath: iPath)
            let color2 = UIColor.blackColor()
            color2.set()
            y.fill()
            
        }
    }
    
    func update(innerMouth innerMouth: [CGPoint], outerMouth: [CGPoint]) {
        self.innerMouth = innerMouth
        self.outerMouth = outerMouth
        self.setNeedsDisplay()
    }
}

