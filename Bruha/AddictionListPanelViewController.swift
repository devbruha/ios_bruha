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
    @IBOutlet weak var artistSelectedB: UIButton!
    @IBOutlet weak var organizationSelectedB: UIButton!
    
    
    var panelControllerContainer: ARSPContainerController!
    var visibleZoneHeight: CGFloat = 74
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPanel()
        
        var eventTgr = UITapGestureRecognizer(target: self, action: ("eventTapped"))
        eventSelectedB.addGestureRecognizer(eventTgr)
        
        var venueTgr = UITapGestureRecognizer(target: self, action: ("venueTapped"))
        venueSelectedB.addGestureRecognizer(venueTgr)
        
        var artistTgr = UITapGestureRecognizer(target: self, action: ("artistTapped"))
        artistSelectedB.addGestureRecognizer(artistTgr)
        
        var organizationTgr = UITapGestureRecognizer(target: self, action: ("organizationTapped"))
        organizationSelectedB.addGestureRecognizer(organizationTgr)
    }
    
    func setupPanel(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
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
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
        
    }
    
    func venueTapped(){
        
        GlobalVariables.addictedDisplay = "Venue"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
    }
    
    func artistTapped(){
        
        GlobalVariables.addictedDisplay = "Artist"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
    }
    
    func organizationTapped(){
        
        GlobalVariables.addictedDisplay = "Organization"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
    }


}
