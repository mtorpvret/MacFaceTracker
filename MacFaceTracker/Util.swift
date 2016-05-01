//
//  Util.swift
//  MacFaceTracker
//
//  Created by Markus Torpvret on 2016-05-01.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import CoreImage

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
