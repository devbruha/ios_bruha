//
//  HorizontalLine.swift
//  Bruha
//
//  Created by lye on 15/10/30.
//  Copyright © 2015年 Bruha. All rights reserved.
//

import UIKit

@IBDesignable
class HorizontalLine: UIView {

    override func drawRect(rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 5.0)
        CGContextSetStrokeColorWithColor(context,
            UIColor.whiteColor().CGColor)
        let dashArray:[CGFloat] = [5,0,0,20]
        CGContextSetLineDash(context, 0, dashArray, 0)
        CGContextMoveToPoint(context, 340, 0)
        CGContextAddQuadCurveToPoint(context, 0, 0, 0, 0)
        CGContextStrokePath(context)
        
    }

}
