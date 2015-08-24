//
//  SplashView.swift
//  Bruha
//
//  Created by lye on 15/8/20.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

class SplashView: UIView {

    class func instanceFromNib1() -> UIView {
        return UINib(nibName: "SplashOne", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    class func instanceFromNib2() -> UIView {
        return UINib(nibName: "SplashTwo", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    class func instanceFromNib3() -> UIView {
        return UINib(nibName: "SplashThree", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    class func instanceFromNib4() -> UIView {
        return UINib(nibName: "SplashFour", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    class func instanceFromNib5() -> UIView {
        return UINib(nibName: "SplashFive", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
