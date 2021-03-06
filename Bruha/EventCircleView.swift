//
//  CircleView.swift
//  Bruha
//
//  Created by lye on 15/7/27.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

@IBDesignable
class EventCircleView: UIView {

    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(ovalInRect: rect)
        UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 0.75).setFill()
        //UIColor.blueColor().colorWithAlphaComponent(0.65).setFill()
        path.fill()
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [1.0, 135.0/255, 0.0, 1.0]
        let color = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(context, color)
        CGContextMoveToPoint(context, 22, 80)
        CGContextAddLineToPoint(context, 135, 80)
        CGContextStrokePath(context)
        
        let ln2 = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        let colorSpace2 = CGColorSpaceCreateDeviceRGB()
        let components2: [CGFloat] = [1.0, 135.0/255, 0.0, 1.0]
        let color2 = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(ln2, color)
        CGContextMoveToPoint(ln2, 53, 104)
        CGContextAddLineToPoint(ln2, 107, 104)
        CGContextStrokePath(ln2)
        
    }


}
