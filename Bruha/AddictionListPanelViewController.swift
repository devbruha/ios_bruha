//
//  AddictionListPanelViewController.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-10-05.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import UIKit


class AddictionListPanelViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var eventSelectedB: UIButton!
    @IBOutlet weak var venueSelectedB: UIButton!
    @IBOutlet weak var discoverableSelectedB: UIButton!
    @IBOutlet weak var organizationSelectedB: UIButton!
    
    
    var panelControllerContainer: ARSPContainerController!
    var visibleZoneHeight: CGFloat = 74
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPanel()
        
        let eventTgr = UITapGestureRecognizer(target: self, action: ("eventTapped"))
        eventSelectedB.addGestureRecognizer(eventTgr)
        
        let venueTgr = UITapGestureRecognizer(target: self, action: ("venueTapped"))
        venueSelectedB.addGestureRecognizer(venueTgr)
        
        let discoverableTgr = UITapGestureRecognizer(target: self, action: ("discoverableTapped"))
        discoverableSelectedB.addGestureRecognizer(discoverableTgr)
        
        let organizationTgr = UITapGestureRecognizer(target: self, action: ("organizationTapped"))
        organizationSelectedB.addGestureRecognizer(organizationTgr)
    }
    
    func setupPanel(){
        
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        panelControllerContainer.visibleZoneHeight = visibleZoneHeight
        panelControllerContainer.shouldOverlapMainViewController = true
        panelControllerContainer.maxPanelHeight = visibleZoneHeight
        panelControllerContainer.draggingEnabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // -------------------------------Onclick Logic-------------------------------
    func eventTapped(){
        
        GlobalVariables.addictedDisplay = "Event"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeAddiction", object: self)
        
    }
    
    func venueTapped(){
        
        GlobalVariables.addictedDisplay = "Venue"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeAddiction", object: self)
    }
    
    func discoverableTapped(){
        
        GlobalVariables.addictedDisplay = ""
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeAddiction", object: self)
    }
    
    func organizationTapped(){
        
        GlobalVariables.addictedDisplay = "Organization"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeAddiction", object: self)
    }


}
