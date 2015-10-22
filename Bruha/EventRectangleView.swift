//
//  RectangleView.swift
//  Bruha
//
//  Created by lye on 15/7/27.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

@IBDesignable
class EventRectangleView: UIView {

    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        UIColor.blueColor().colorWithAlphaComponent(0.5).setFill()
        path.fill()
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [1.0, 135.0/255, 0.0, 1.0]
        let color = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(context, color)
        CGContextMoveToPoint(context, 5, 35)
        CGContextAddLineToPoint(context, 355, 35)
        CGContextStrokePath(context)
        
    }
    
}
