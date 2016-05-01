//
//  NoseView.swift
//  MacFaceTracker
//
//  Created by Markus Torpvret on 2016-05-01.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import UIKit
import FaceTracker

class NoseView: UIView {
    var nose: [CGPoint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func drawRect(rect: CGRect) {
        guard let nose = nose else { return }
        let noseMinX = getMinX(nose)
        let noseMaxX = getMaxX(nose)
        let noseSize = (noseMaxX - noseMinX) * 1.1
        let centerY = getMinY(nose)
        let noseMinY = centerY - noseSize / 2
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
        CGContextAddEllipseInRect(context, CGRect(x: noseMinX, y: noseMinY, width: noseSize, height: noseSize))
        CGContextDrawPath(context, .Fill)
    }
        
    func update(nose: [CGPoint]) {
        self.nose = nose
        self.setNeedsDisplay()
    }
}

