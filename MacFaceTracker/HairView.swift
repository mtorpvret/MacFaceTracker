//
//  HairView.swift
//  MacFaceTracker
//
//  Created by Markus Torpvret on 2016-05-01.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import UIKit

class HairView: UIView {
    var leftEye: [CGPoint]?
    var rightEye: [CGPoint]?
    let hairView = UIImageView()
    
    override init(frame: CGRect) {
        hairView.image = UIImage(named: "ClownHair.png")
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        addSubview(hairView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func drawRect(rect: CGRect) {
        guard let leftEye = leftEye else { return }
        guard let rightEye = rightEye else { return }
        
        // Compute the hair frame
        let eyeCornerDist = sqrt(pow(leftEye[0].x - rightEye[5].x, 2) + pow(leftEye[0].y - rightEye[5].y, 2))
        let eyeToEyeCenter = CGPointMake((leftEye[0].x + rightEye[5].x) / 2, (leftEye[0].y + rightEye[5].y) / 2)
        
        let hairWidth = 2.85 * eyeCornerDist
        let hairHeight = (hairView.image!.size.height / hairView.image!.size.width) * hairWidth
        
        hairView.transform = CGAffineTransformIdentity
        hairView.frame = CGRectMake(eyeToEyeCenter.x - hairWidth / 2, eyeToEyeCenter.y - 0.8 * hairHeight, hairWidth, hairHeight)
        hairView.hidden = false
        
        hairView.setAnchorPoint(CGPointMake(0.5, 0.9))
        
        let angle = atan2(rightEye[5].y - leftEye[0].y, rightEye[5].x - leftEye[0].x)
        hairView.transform = CGAffineTransformMakeRotation(angle)
    }

    func update(leftEye leftEye: [CGPoint], rightEye: [CGPoint]) {
        self.leftEye = leftEye
        self.rightEye = rightEye
        self.setNeedsDisplay()
    }
}


