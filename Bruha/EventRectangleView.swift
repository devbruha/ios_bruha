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
        var path = UIBezierPath(rect: rect)
        UIColor.blueColor().colorWithAlphaComponent(0.5).setFill()
        path.fill()
        
        var dynamicLabel: UILabel = UILabel()
        dynamicLabel.frame = CGRectMake(5, 15, 280, 20)
        dynamicLabel.backgroundColor = UIColor.clearColor()
        dynamicLabel.textColor = UIColor.whiteColor()
        dynamicLabel.textAlignment = NSTextAlignment.Left
        dynamicLabel.text = "Color Run"
        self.addSubview(dynamicLabel)
        
        var priceLabel: UILabel = UILabel()
        priceLabel.frame = CGRectMake(250, 15, 80, 20)
        priceLabel.backgroundColor = UIColor.clearColor()
        priceLabel.textColor = UIColor.whiteColor()
        priceLabel.textAlignment = NSTextAlignment.Center
        priceLabel.text = "$69.99"
        priceLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        self.addSubview(priceLabel)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [1.0, 135.0/255, 0.0, 1.0]
        let color = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(context, color)
        CGContextMoveToPoint(context, 5, 35)
        CGContextAddLineToPoint(context, 355, 35)
        CGContextStrokePath(context)
        
        var locationLabel: UILabel = UILabel()
        locationLabel.frame = CGRectMake(5, 40, 350, 20)
        locationLabel.backgroundColor = UIColor.clearColor()
        locationLabel.textColor = UIColor.whiteColor()
        locationLabel.textAlignment = NSTextAlignment.Left
        locationLabel.text = "McMaster Innovation Park"
        locationLabel.font = locationLabel.font.fontWithSize(15)
        self.addSubview(locationLabel)
        
        var address1Label: UILabel = UILabel()
        address1Label.frame = CGRectMake(5, 70, 350, 20)
        address1Label.backgroundColor = UIColor.clearColor()
        address1Label.textColor = UIColor.whiteColor()
        address1Label.textAlignment = NSTextAlignment.Left
        address1Label.text = "#49 Ahewkjfd,Longwood Road North"
        address1Label.font = address1Label.font.fontWithSize(14)
        self.addSubview(address1Label)
        
        var address2Label: UILabel = UILabel()
        address2Label.frame = CGRectMake(5, 90, 350, 20)
        address2Label.backgroundColor = UIColor.clearColor()
        address2Label.textColor = UIColor.whiteColor()
        address2Label.textAlignment = NSTextAlignment.Left
        address2Label.text = "Hamilton, ON, L9D 3J0"
        address2Label.font = locationLabel.font.fontWithSize(14)
        self.addSubview(address2Label)
        
        var startDateLabel: UILabel = UILabel()
        startDateLabel.frame = CGRectMake(5, 120, 350, 20)
        startDateLabel.backgroundColor = UIColor.clearColor()
        startDateLabel.textColor = UIColor.whiteColor()
        startDateLabel.textAlignment = NSTextAlignment.Left
        startDateLabel.text = "Saturday, June 29th, 2015 at 6:00 PM-"
        startDateLabel.font = locationLabel.font.fontWithSize(14)
        self.addSubview(startDateLabel)
        
        var endDateLabel: UILabel = UILabel()
        endDateLabel.frame = CGRectMake(5, 140, 350, 20)
        endDateLabel.backgroundColor = UIColor.clearColor()
        endDateLabel.textColor = UIColor.whiteColor()
        endDateLabel.textAlignment = NSTextAlignment.Left
        endDateLabel.text = "Friday, July 6th, 2015 at 4:00 PM"
        endDateLabel.font = locationLabel.font.fontWithSize(14)
        self.addSubview(endDateLabel)
        
        
    }
    


}
