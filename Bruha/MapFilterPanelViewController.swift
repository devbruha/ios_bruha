//
//  MapFilterPanelViewController.swift
//  Bruha
//
//  Created by lye on 15/8/10.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

class MapFilterPanelViewController: UIViewController {
    
    var panelControllerContainer: ARSPContainerController!
    var swipeZoneHeight: CGFloat = 74
    var visibleZoneHeight: CGFloat = 74
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        panelControllerContainer.visibleZoneHeight = visibleZoneHeight
        panelControllerContainer.shouldOverlapMainViewController = true
        //println(panelControllerContainer.visibilityState)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.swipeZoneHeight = self.panelControllerContainer.swipableZoneHeight
        self.visibleZoneHeight = self.panelControllerContainer.visibleZoneHeight
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
