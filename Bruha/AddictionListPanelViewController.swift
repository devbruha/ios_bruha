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
    @IBOutlet weak var eventButtonIcon: UIImageView!
    @IBOutlet weak var venueSelectedB: UIButton!
    @IBOutlet weak var venueButtonIcon: UIImageView!
    @IBOutlet weak var discoverableSelectedB: UIButton!
    @IBOutlet weak var discoverableButtonIcon: UIImageView!
    @IBOutlet weak var organizationSelectedB: UIButton!
    @IBOutlet weak var organizationButtonIcon: UIImageView!
    
    
    var panelControllerContainer: ARSPContainerController!
    var visibleZoneHeight: CGFloat = 59
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPanel()
        setupEVOD()
        
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
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        panelControllerContainer.visibleZoneHeight = visibleZoneHeight
        panelControllerContainer.shouldOverlapMainViewController = true
        panelControllerContainer.maxPanelHeight = screenHeight*0.66
        panelControllerContainer.draggingEnabled = false
        
    }
    
    func setupEVOD() {
        
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
        
        discoverableButtonIcon.contentMode = UIViewContentMode.ScaleAspectFit
        discoverableButtonIcon.image = UIImage(named: "Bruha_White")
        discoverableSelectedB.setTitle("Discoverable", forState: UIControlState.Normal)
        discoverableSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        discoverableSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        discoverableSelectedB.layer.borderWidth = CGFloat(1.5)
        
    }
    
    func updateEVOD() {
        
        eventButtonIcon.image = UIImage(named: "Events_White")
        eventSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        eventSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        
        venueButtonIcon.image = UIImage(named: "Venue_White")
        venueSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        venueSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        
        organizationButtonIcon.image = UIImage(named: "Organization_White")
        organizationSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        organizationSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        
        discoverableButtonIcon.image = UIImage(named: "Bruha_White")
        discoverableSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        discoverableSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        
        switch(GlobalVariables.addictedDisplay){
            
        case "Event":
            
            eventButtonIcon.image = UIImage(named: "Events_Orange")
            eventSelectedB.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            eventSelectedB.layer.borderColor = UIColor.orangeColor().CGColor
            
        case "Venue":
            
            venueButtonIcon.image = UIImage(named: "Venue_Orange")
            venueSelectedB.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            venueSelectedB.layer.borderColor = UIColor.orangeColor().CGColor
            
        case "Organization":
            
            organizationButtonIcon.image = UIImage(named: "Organization_Orange")
            organizationSelectedB.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            organizationSelectedB.layer.borderColor = UIColor.orangeColor().CGColor
            
        case "Discoverable":
            
            discoverableButtonIcon.image = UIImage(named: "Venue_Orange")
            discoverableSelectedB.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            discoverableSelectedB.layer.borderColor = UIColor.orangeColor().CGColor
            
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
            
            discoverableButtonIcon.image = UIImage(named: "Bruha_White")
            discoverableSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            discoverableSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // -------------------------------Onclick Logic-------------------------------
    func eventTapped(){
        
        GlobalVariables.addictedDisplay = "Event"
        updateEVOD()
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeAddiction", object: self)
        
    }
    
    func venueTapped(){
        
        GlobalVariables.addictedDisplay = "Venue"
        updateEVOD()
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeAddiction", object: self)
    }
    
    func discoverableTapped(){
        
        //GlobalVariables.addictedDisplay = "Discoverable"
        updateEVOD()
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeAddiction", object: self)
        let alert = UIAlertView(title: "Discoverable Coming Soon!!!", message: nil, delegate: nil, cancelButtonTitle: nil)
        alert.show()
        let delay = 1.5 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissWithClickedButtonIndex(-1, animated: true)
        })
    }
    
    func organizationTapped(){
        
        GlobalVariables.addictedDisplay = "Organization"
        updateEVOD()
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeAddiction", object: self)
    }


}
