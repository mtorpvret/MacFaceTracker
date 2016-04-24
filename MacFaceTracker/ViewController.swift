//
//  ViewController.swift
//  MacFaceTracker
//
//  Created by Markus Torpvret on 2016-04-13.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import UIKit
import FaceTracker

class ViewController: UIViewController, FaceTrackerViewControllerDelegate {

    weak var faceTrackerViewController: FaceTrackerViewController?
    
    var mouth: MouthView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mouth = MouthView(frame: self.view.bounds)
        view.addSubview(mouth!)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "faceTrackerEmbed" {
            faceTrackerViewController = segue.destinationViewController as? FaceTrackerViewController
            faceTrackerViewController!.delegate = self
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        faceTrackerViewController?.startTracking { () -> Void in
            
        }
    }

    func faceTrackerDidUpdate(points: FacePoints?) {
        if let points = points {
            mouth!.hidden = false
            mouth!.update(innerMouth: points.innerMouth, outerMouth: points.outerMouth)
        }
        else {
            self.hideAllOverlayViews()
        }
    }
    
//    func oldfaceTrackerDidUpdate(points: FacePoints?) {
//        if let points = points {
//            for (index, point) in points.leftEye.enumerate() {
//                self.updateViewForFeature("leftEye", index: index, point: point, bgColor: UIColor.blueColor())
//            }
//            for (index, point) in points.rightEye.enumerate() {
//                self.updateViewForFeature("rightEye", index: index, point: point, bgColor: UIColor.blueColor())
//            }
//            for (index, point) in points.leftBrow.enumerate() {
//                self.updateViewForFeature("leftBrow", index: index, point: point, bgColor: UIColor.whiteColor())
//            }
//            for (index, point) in points.rightBrow.enumerate() {
//                self.updateViewForFeature("rightBrow", index: index, point: point, bgColor: UIColor.whiteColor())
//            }
//            for (index, point) in points.nose.enumerate() {
//                self.updateViewForFeature("nose", index: index, point: point, bgColor: UIColor.blueColor())
//            }
//            for (index, point) in points.innerMouth.enumerate() {
//                self.updateViewForFeature("innerMouth", index: index, point: point, bgColor: UIColor.blueColor())
//            }
//            for (index, point) in points.outerMouth.enumerate() {
//                self.updateViewForFeature("outerMouth", index: index, point: point, bgColor: UIColor.blueColor())
//            }
//        }
//        else {
//            self.hideAllOverlayViews()
//        }
//    }
//   
//    func updateViewForFeature(feature: String, index: Int, point: CGPoint, bgColor: UIColor) {
//        let frame = CGRect(x: point.x-2, y: point.y-2, width: 4.0, height: 4.0)
//        if self.overlayViews[feature] == nil {
//            self.overlayViews[feature] = [UIView]()
//        }
//        if index < self.overlayViews[feature]!.count {
//            self.overlayViews[feature]![index].frame = frame
//            self.overlayViews[feature]![index].hidden = false
//            self.overlayViews[feature]![index].backgroundColor = bgColor
//        }
//        else {
//            let newView = UIView(frame: frame)
//            newView.backgroundColor = bgColor
//            newView.hidden = false
//            self.view.addSubview(newView)
//            self.overlayViews[feature]! += [newView]
//        }
//    }
    
    func hideAllOverlayViews() {
        mouth!.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

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
            var path = CGPathCreateMutable()
//            let context = UIGraphicsGetCurrentContext()
//            CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
//            CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
            
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
            let x = UIBezierPath(CGPath: path)
            x.stroke()
            x.fill()
            
            var iPath = CGPathCreateMutable()
            if let points = innerMouth {
                for (index, point) in points.enumerate() {
                    if(index == 0) {
                        //               startPoint = point
                        CGPathMoveToPoint(iPath, nil, point.x, point.y);
                    }
                    else {
                        CGPathAddLineToPoint(iPath, nil, point.x, point.y);
                    }
                }
            }
   //         CGPathAddLineToPoint(iPath, nil, startPoint!.x, startPoint!.y)
            CGPathCloseSubpath(iPath)
            let y = UIBezierPath(CGPath: iPath)
            let color2 = UIColor.blackColor()
            color2.set()
            y.stroke()
            y.fill()
            
            
            
//            CGContextStrokePath(context);
        }
    }
    
    func update(innerMouth innerMouth: [CGPoint], outerMouth: [CGPoint]) {
        self.innerMouth = innerMouth
        self.outerMouth = outerMouth
        self.setNeedsDisplay()
    }
}

