//
//  CAGradientLayer.swift
//  Bruha
//
//  Created by Ryan O'Neill on 2015-09-25.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    func gradientColor() -> CAGradientLayer {
        let bottomColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
        let topColor = UIColor(red: 0/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1)
        
        let gradientColor: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColor
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
    func profileColor() -> CAGradientLayer{
        let bottomColor = UIColor(red: 73/255.0, green: 80/255.0, blue: 85/255.0, alpha: 1)
        let topColor = UIColor(red: 13/255.0, green: 13/255.0, blue: 13/255.0, alpha: 1)
        
        let gradientColor: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColor
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
    
}