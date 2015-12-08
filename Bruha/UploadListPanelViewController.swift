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
    @IBOutlet weak var eventButtonIcon: UIImageView!
    @IBOutlet weak var discoverableSelectedB: UIButton!
    @IBOutlet weak var organizationSelectedB: UIButton!
    @IBOutlet weak var organizationButtonIcon: UIImageView!
    @IBOutlet weak var venueSelectedB: UIButton!
    @IBOutlet weak var venueButtonIcon: UIImageView!
    
    
    
    var panelControllerContainer: ARSPContainerController!
    var visibleZoneHeight: CGFloat = 74
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPanel()
        setupEVO()
        
        let eventTgr = UITapGestureRecognizer(target: self, action: ("eventTapped"))
        eventSelectedB.addGestureRecognizer(eventTgr)
        
        let venueTgr = UITapGestureRecognizer(target: self, action: ("venueTapped"))
        venueSelectedB.addGestureRecognizer(venueTgr)
        
        let discoverableTgr = UITapGestureRecognizer(target: self, action: ("discoverableTapped"))
        discoverableSelectedB.addGestureRecognizer(discoverableTgr)
        
        let organizationTgr = UITapGestureRecognizer(target: self, action: ("organizationTapped"))
        organizationSelectedB.addGestureRecognizer(organizationTgr)
        
        eventTapped()
    }
    
    func setupPanel(){
        
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        panelControllerContainer.visibleZoneHeight = visibleZoneHeight
        panelControllerContainer.shouldOverlapMainViewController = true
        panelControllerContainer.maxPanelHeight = visibleZoneHeight
        panelControllerContainer.draggingEnabled = false
        
    }
    
    func setupEVO() {
        
        eventButtonIcon.contentMode = UIViewContentMode.ScaleAspectFit
        eventButtonIcon.image = UIImage(named: "Events_White")
        eventSelectedB.setTitle("Event", forState: UIControlState.Normal)
        eventSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        eventSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        eventSelectedB.layer.borderWidth = CGFloat(1.5)
        //eventSelectedB.titleEdgeInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        
        venueButtonIcon.contentMode = UIViewContentMode.ScaleAspectFit
        venueButtonIcon.image = UIImage(named: "Venue_White")
        venueSelectedB.setTitle("Venue", forState: UIControlState.Normal)
        venueSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        venueSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        venueSelectedB.layer.borderWidth = CGFloat(1.5)
        
        organizationButtonIcon.contentMode = UIViewContentMode.ScaleAspectFit
        organizationButtonIcon.image = UIImage(named: "Organization_White")
        organizationSelectedB.setTitle("Organization", forState: UIControlState.Normal)
        organizationSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        organizationSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        organizationSelectedB.layer.borderWidth = CGFloat(1.5)
        
    }
    
    func updateEVO() {
        
        switch(GlobalVariables.uploadDisplay){
            
        case "Event":
            
            eventButtonIcon.image = UIImage(named: "Events_Orange")
            eventSelectedB.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            eventSelectedB.layer.borderColor = UIColor.orangeColor().CGColor
            
            venueButtonIcon.image = UIImage(named: "Venue_White")
            venueSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            venueSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
            
            organizationButtonIcon.image = UIImage(named: "Organization_White")
            organizationSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            organizationSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
            
        case "Venue":
            
            eventButtonIcon.image = UIImage(named: "Events_White")
            eventSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            eventSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
            
            venueButtonIcon.image = UIImage(named: "Venue_Orange")
            venueSelectedB.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            venueSelectedB.layer.borderColor = UIColor.orangeColor().CGColor
            
            organizationButtonIcon.image = UIImage(named: "Organization_White")
            organizationSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            organizationSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
            
        case "Organization":
            
            eventButtonIcon.image = UIImage(named: "Events_White")
            eventSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            eventSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
            
            venueButtonIcon.image = UIImage(named: "Venue_White")
            venueSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            venueSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
            
            organizationButtonIcon.image = UIImage(named: "Organization_Orange")
            organizationSelectedB.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            organizationSelectedB.layer.borderColor = UIColor.orangeColor().CGColor
            
        default:
            
            eventButtonIcon.image = UIImage(named: "Events_White")
            eventSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            eventSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
            
            venueButtonIcon.image = UIImage(named: "Venue_White")
            venueSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            venueSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
            
            organizationButtonIcon.image = UIImage(named: "Organization_White")
            organizationSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            organizationSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // -------------------------------Onclick Logic-------------------------------
    func eventTapped(){
        
        GlobalVariables.uploadDisplay = "Event"
        updateEVO()
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeUpload", object: self)
        
    }
    
    func venueTapped(){
        
        GlobalVariables.uploadDisplay = "Venue"
        updateEVO()
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeUpload", object: self)
    }
    
    func discoverableTapped(){
        
        GlobalVariables.uploadDisplay = "Discoverable"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeUpload", object: self)
    }
    
    func organizationTapped(){
        
        GlobalVariables.uploadDisplay = "Organization"
        updateEVO()
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeUpload", object: self)
    }

}









