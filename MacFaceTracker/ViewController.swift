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
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!

    @IBOutlet weak var faceTrackerContainerView: UIView!
    weak var faceTrackerViewController: FaceTrackerViewController?
    
    var mouth: MouthView?
    var brows: EyebrowView?
    var face: FaceView?
    var eyes: EyeView?
    var nose: NoseView?
    var hair: HairView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        face = FaceView(frame: self.view.bounds)
        self.view.insertSubview(face!, aboveSubview: faceTrackerContainerView)
        mouth = MouthView(frame: self.view.bounds)
        self.view.insertSubview(mouth!, aboveSubview: face!)
        brows = EyebrowView(frame: self.view.bounds)
        self.view.insertSubview(brows!, aboveSubview: face!)
        eyes = EyeView(frame: self.view.bounds)
        self.view.insertSubview(eyes!, aboveSubview: face!)
        nose = NoseView(frame: self.view.bounds)
        self.view.insertSubview(nose!, aboveSubview: face!)
        hair = HairView(frame: self.view.bounds)
        self.view.insertSubview(hair!, aboveSubview: brows!)
        print("bounds: \(self.view.bounds)")
    }

    @IBAction func optionsButtonPressed(sender: UIButton) {
        print("Options button pressed")
    }
    
    @IBAction func shareButtonPressed(sender: UIButton) {
        print("snapshot")
        hair!.hidden = true
        makeSnapshot()
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
            displayAllOverlayViews()
            face!.update(points)
            mouth!.update(innerMouth: points.innerMouth, outerMouth: points.outerMouth)
            brows!.update(leftBrow: points.leftBrow, rightBrow: points.rightBrow)
            eyes!.update(leftEye: points.leftEye, rightEye: points.rightEye)
            nose!.update(points.nose)
            hair!.update(leftEye: points.leftEye, rightEye: points.rightEye)
        }
        else {
            self.hideAllOverlayViews()
        }
    }

    func displayAllOverlayViews() {
        mouth!.hidden = false
        brows!.hidden = false
        face!.hidden = false
        eyes!.hidden = false
        nose!.hidden = false
        hair!.hidden = false
    }
    
    func hideAllOverlayViews() {
        mouth!.hidden = true
        brows!.hidden = true
        face!.hidden = true
        eyes!.hidden = true
        nose!.hidden = true
        hair!.hidden = true
    }
    
    func hideButtons() {
        optionsButton.hidden = true
        shareButton.hidden = true
    }
    
    func showButtons() {
        optionsButton.hidden = false
        shareButton.hidden = false
    }

    func makeSnapshot() {
        hideButtons()
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
        showButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
