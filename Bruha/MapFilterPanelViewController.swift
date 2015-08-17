//
//  MapFilterPanelViewController.swift
//  Bruha
//
//  Created by lye on 15/8/10.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

class MapFilterPanelViewController: UIViewController {
    
    @IBOutlet weak var eventSelectedB: UIButton!
    @IBOutlet weak var venueSelectedB: UIButton!
    @IBOutlet weak var artistSelectedB: UIButton!
    @IBOutlet weak var organizationSelectedB: UIButton!
    @IBOutlet weak var eventCategories: UILabel!
    @IBOutlet weak var venueCategories: UILabel!
    @IBOutlet weak var artistCategories: UILabel!
    @IBOutlet weak var organizationCategories: UILabel!
    
    var panelControllerContainer: ARSPContainerController!
    var swipeZoneHeight: CGFloat = 74
    var visibleZoneHeight: CGFloat = 74
    
    func eventTapped(){
        
        eventCategories.alpha = 1
        venueCategories.alpha = 0
        artistCategories.alpha = 0
        organizationCategories.alpha = 0
        
        GlobalVariables.selectedDisplay = "Event"
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
        
    }
    
    func venueTapped(){
        
        eventCategories.alpha = 0
        venueCategories.alpha = 1
        artistCategories.alpha = 0
        organizationCategories.alpha = 0
        
        GlobalVariables.selectedDisplay = "Venue"
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
    }
    
    func artistTapped(){
        
        eventCategories.alpha = 0
        venueCategories.alpha = 0
        artistCategories.alpha = 1
        organizationCategories.alpha = 0
        
        GlobalVariables.selectedDisplay = "Artist"
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
    }
    
    func organizationTapped(){
        
        eventCategories.alpha = 0
        venueCategories.alpha = 0
        artistCategories.alpha = 0
        organizationCategories.alpha = 1
        
        GlobalVariables.selectedDisplay = "Organization"
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        panelControllerContainer.visibleZoneHeight = visibleZoneHeight
        panelControllerContainer.shouldOverlapMainViewController = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationSent", name: "itemDisplayChange", object: nil)
        
        var eventTgr = UITapGestureRecognizer(target: self, action: ("eventTapped"))
        eventSelectedB.addGestureRecognizer(eventTgr)
        
        var venueTgr = UITapGestureRecognizer(target: self, action: ("venueTapped"))
        venueSelectedB.addGestureRecognizer(venueTgr)
        
        var artistTgr = UITapGestureRecognizer(target: self, action: ("artistTapped"))
        artistSelectedB.addGestureRecognizer(artistTgr)
        
        var organizationTgr = UITapGestureRecognizer(target: self, action: ("organizationTapped"))
        organizationSelectedB.addGestureRecognizer(organizationTgr)

        //println(panelControllerContainer.visibilityState)
        
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
