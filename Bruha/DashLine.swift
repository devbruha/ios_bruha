//
//  DashLine.swift
//  Bruha
//
//  Created by lye on 15/7/29.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

@IBDesignable
class DashLine: UIView {

    override func drawRect(rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 8.0)
        CGContextSetStrokeColorWithColor(context,
            UIColor.blackColor().CGColor)
        let dashArray:[CGFloat] = [5,0,0,20]
        CGContextSetLineDash(context, 0, dashArray, 4)
        CGContextMoveToPoint(context, 340, 0)
        CGContextAddQuadCurveToPoint(context, 0, 0, 0, 0)
        CGContextStrokePath(context)
        
    }

}
