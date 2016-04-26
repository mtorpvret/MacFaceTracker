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
    var brows: EyebrowView?
    var face: FaceView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        face = FaceView(frame: self.view.bounds)
        view.addSubview(face!)
        mouth = MouthView(frame: self.view.bounds)
        view.addSubview(mouth!)
        brows = EyebrowView(frame: self.view.bounds)
        view.addSubview(brows!)
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
            brows!.hidden = false
            brows!.update(leftBrow: points.leftBrow, rightBrow: points.rightBrow)
            face!.hidden = false
            face!.update(points)
        }
        else {
            self.hideAllOverlayViews()
        }
    }
    
    func hideAllOverlayViews() {
        mouth!.hidden = true
        brows!.hidden = true
        face!.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
