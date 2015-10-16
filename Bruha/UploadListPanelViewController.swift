//
//  UploadListPanelViewController.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-10-14.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import UIKit


class UploadListPanelViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var eventSelectedB: UIButton!
    @IBOutlet weak var artistSelectedB: UIButton!
    @IBOutlet weak var organizationSelectedB: UIButton!
    @IBOutlet weak var venueSelectedB: UIButton!
    
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
        
        GlobalVariables.uploadDisplay = "Event"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeUpload", object: self)
        
    }
    
    func venueTapped(){
        
        GlobalVariables.uploadDisplay = "Venue"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeUpload", object: self)
    }
    
    func artistTapped(){
        
        GlobalVariables.uploadDisplay = "Artist"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeUpload", object: self)
    }
    
    func organizationTapped(){
        
        GlobalVariables.uploadDisplay = "Organization"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeUpload", object: self)
    }

}









