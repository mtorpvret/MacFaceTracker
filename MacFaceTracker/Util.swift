//
//  Util.swift
//  MacFaceTracker
//
//  Created by Markus Torpvret on 2016-05-01.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import CoreImage

func getMaxY(points: [CGPoint]) -> CGFloat {
    return points.reduce(0, combine: { (y:CGFloat, p: CGPoint) -> CGFloat in y > p.y ? y : p.y })
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

func getPointForMaxY(points: [CGPoint]) -> CGPoint {
    return points.reduce(CGPoint(x:0, y:0), combine: { (pMax:CGPoint, p: CGPoint) -> CGPoint in pMax.y > p.y ? pMax : p })
}

func getPointForMinY(points: [CGPoint]) -> CGPoint {
    return points.reduce(CGPoint(x:10000, y:10000), combine: { (pMin:CGPoint, p: CGPoint) -> CGPoint in pMin.y < p.y ? pMin : p })
}

func getPointForMaxX(points: [CGPoint]) -> CGPoint {
    return points.reduce(CGPoint(x: 0, y: 0), combine: { (pMax:CGPoint, p: CGPoint) -> CGPoint in pMax.x > p.x ? pMax : p })
}

func getPointForMinX(points: [CGPoint]) -> CGPoint {
    return points.reduce(CGPoint(x: 10000,y: 10000), combine: { (pMin:CGPoint, p: CGPoint) -> CGPoint in pMin.x < p.x ? pMin : p })
}

func calcAngleFrom(p1: CGPoint, to p2: CGPoint) -> CGFloat {
    return atan2(p2.y - p1.y, p2.x - p1.x)
}

func distanceFrom(p1: CGPoint, to p2: CGPoint) -> CGFloat {
    return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2))
}