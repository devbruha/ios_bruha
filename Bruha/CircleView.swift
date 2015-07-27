//
//  CircleView.swift
//  Bruha
//
//  Created by lye on 15/7/27.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIView {

    override func drawRect(rect: CGRect) {
        var path = UIBezierPath(ovalInRect: rect)
        UIColor.blueColor().colorWithAlphaComponent(0.65).setFill()
        path.fill()
        
        var carName = ["Lamborghini", "Drift", "Ferrari", "Hyundai","Mercedes Benz","Mitsubishi","Nissan","Volkswagen"]
        
        
        var dynamicLabel: UILabel = UILabel()
        dynamicLabel.frame = CGRectMake(5, 28, 150, 20)
        dynamicLabel.backgroundColor = UIColor.clearColor()
        dynamicLabel.textColor = UIColor.whiteColor()
        dynamicLabel.textAlignment = NSTextAlignment.Center
        /*for i in carName{
        dynamicLabel.text = i
        }*/
        dynamicLabel.text = "Color Run"
        self.addSubview(dynamicLabel)
        
        var dataLabel: UILabel = UILabel()
        dataLabel.frame = CGRectMake(5, 50, 150, 25)
        dataLabel.backgroundColor = UIColor.clearColor()
        dataLabel.textColor = UIColor.whiteColor()
        dataLabel.textAlignment = NSTextAlignment.Center
        dataLabel.text = "June 30th, 2015"
        dataLabel.font = dataLabel.font.fontWithSize(20)
        self.addSubview(dataLabel)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [1.0, 135.0/255, 0.0, 1.0]
        let color = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(context, color)
        CGContextMoveToPoint(context, 8, 75)
        CGContextAddLineToPoint(context, 150, 75)
        CGContextStrokePath(context)
        
        var priceLabel: UILabel = UILabel()
        priceLabel.frame = CGRectMake(5, 82, 150, 25)
        priceLabel.backgroundColor = UIColor.clearColor()
        priceLabel.textColor = UIColor.whiteColor()
        priceLabel.textAlignment = NSTextAlignment.Center
        priceLabel.text = "$69.99"
        priceLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        self.addSubview(priceLabel)
        
        let ln2 = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        let colorSpace2 = CGColorSpaceCreateDeviceRGB()
        let components2: [CGFloat] = [1.0, 135.0/255, 0.0, 1.0]
        let color2 = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(ln2, color)
        CGContextMoveToPoint(ln2, 50, 108)
        CGContextAddLineToPoint(ln2, 110, 108)
        CGContextStrokePath(ln2)
        
        var distanceLabel: UILabel = UILabel()
        distanceLabel.frame = CGRectMake(5, 112, 150, 15)
        distanceLabel.backgroundColor = UIColor.clearColor()
        distanceLabel.textColor = UIColor.whiteColor()
        distanceLabel.textAlignment = NSTextAlignment.Center
        distanceLabel.text = "9.69km"
        distanceLabel.font = distanceLabel.font.fontWithSize(9)
        self.addSubview(distanceLabel)
    }


}
