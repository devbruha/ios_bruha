//
//  EventFilterPanelViewController.swift
//  Bruha
//
//  Created by lye on 15/7/31.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

class ExploreListPanelViewController: UIViewController {

    @IBOutlet weak var eventSelectedB: UIButton!
    @IBOutlet weak var venueSelectedB: UIButton!
    @IBOutlet weak var artistSelectedB: UIButton!
    @IBOutlet weak var organizationSelectedB: UIButton!
    
    var panelControllerContainer: ARSPContainerController!
    var swipeZoneHeight: CGFloat = 74
    var visibleZoneHeight: CGFloat = 74
    
    func eventTapped(){
        
        GlobalVariables.selectedDisplay = "Event"
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
    }
    
    func venueTapped(){

        GlobalVariables.selectedDisplay = "Venue"
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
    }
    
    func artistTapped(){
        
        GlobalVariables.selectedDisplay = "Artist"
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
    }
    
    func organizationTapped(){
        
        GlobalVariables.selectedDisplay = "Organization"
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        panelControllerContainer.visibleZoneHeight = visibleZoneHeight
        panelControllerContainer.shouldOverlapMainViewController = true
        //println(panelControllerContainer.visibilityState)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationSent", name: "itemDisplayChange", object: nil)
        
        var eventTgr = UITapGestureRecognizer(target: self, action: ("eventTapped"))
        eventSelectedB.addGestureRecognizer(eventTgr)

        var venueTgr = UITapGestureRecognizer(target: self, action: ("venueTapped"))
        venueSelectedB.addGestureRecognizer(venueTgr)
        
        var artistTgr = UITapGestureRecognizer(target: self, action: ("artistTapped"))
        artistSelectedB.addGestureRecognizer(artistTgr)
        
        var organizationTgr = UITapGestureRecognizer(target: self, action: ("organizationTapped"))
        organizationSelectedB.addGestureRecognizer(organizationTgr)
    
        
    }
    
    func updateNotificationSent(){
        
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
