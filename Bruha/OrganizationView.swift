//
//  OrganizationView.swift
//  Bruha
//
//  Created by lye on 15/8/14.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

class OrganizationView: UIView {

    var m_subcellNew: Array<UITableViewCell> = []
    var names:[String] = ["Band","Concert","Buidling","McMaster","University","Toronto","Markham","hahahaha"] //this is where you load data from database
    
    let rec = UITapGestureRecognizer()
    
    var yStart:Int = 0
    
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    var view: UIView = UIView(frame: CGRectMake(0, 0, 100, 100))
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        //m_table.dequeueReusableCellWithIdentifier("subCell")
        
        var i = 0
        
        for name in names{
            m_subcellNew.append(UITableViewCell())
            m_subcellNew[i].layer.borderWidth = 0.8
            m_subcellNew[i].layer.borderColor = UIColor.whiteColor().CGColor
            //m_subcellNew[i].backgroundColor = UIColor.blackColor()
            //  m_subcellNew[i].drawRect(CGRect(x: 80, y: yStart,width: 100, height: 80))
            //m_subcellNew[i].frame = CGRect(x: 0, y: yStart, width: Int(self.bounds.width), height: 30)
            m_subcellNew[i].frame = CGRect(x: 0, y: yStart, width: 304, height: 30)
            yStart += 30
            m_subcellNew[i].textLabel?.textColor = UIColor.whiteColor()
            m_subcellNew[i].textLabel?.text = name
            view.addSubview(m_subcellNew[i])
            i++
        }
        addSubview(view)
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "VenueView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

}
