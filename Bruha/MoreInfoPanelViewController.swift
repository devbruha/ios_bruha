//
//  MoreInfoPanelViewController.swift
//  Bruha
//
//  Created by lye on 15/11/4.
//  Copyright © 2015年 Bruha. All rights reserved.
//

import UIKit

class MoreInfoPanelViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var smallImage: UIImageView!
    @IBOutlet var getAddictedButton: UIButton!
    @IBOutlet var getAddictedLabel: UILabel!
    @IBOutlet var webDescriptionContent: UIWebView!
    
    
    var panelControllerContainer: ARSPContainerController!
    var swipeZoneHeight: CGFloat = 180
    var visibleZoneHeight: CGFloat = 180


    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func setupPanel(){
        
        let screenSize:CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        panelControllerContainer.visibleZoneHeight = visibleZoneHeight
        panelControllerContainer.shouldOverlapMainViewController = true
        panelControllerContainer.maxPanelHeight = screenHeight
        panelControllerContainer.draggingEnabled = true
        
    }
    func labelDisplay(){
        webDescriptionContent.opaque = false
        webDescriptionContent.backgroundColor = UIColor.grayColor()
        
        if GlobalVariables.selectedDisplay == "Event"{
            let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
            let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
            for event in eventInfo{
                if event.eventID == GlobalVariables.eventSelected{
                    Name.text = event.eventName
                    Address.text = event.eventVenueAddress
                    Price.text = event.eventPrice
                    Date.text = event.eventStartDate
                    smallImage.image = UIImage(named: event.primaryCategory)
                    webDescriptionContent.loadHTMLString("<font color=\"black\">\(event.eventDescription)</font>", baseURL: nil)
                }
                if event.eventID == GlobalVariables.eventSelected && addictionInfo!.contains({$0.eventID == GlobalVariables.eventSelected}) {

                    getAddictedButton.backgroundColor = UIColor.orangeColor()
                    getAddictedLabel.text = "You are addicted"
                }
            }
            
        }
        if GlobalVariables.selectedDisplay == "Venue"{
            let venueInfo = FetchData(context: managedObjectContext).fetchVenues()!
            let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsVenue()
            for venue in venueInfo{
                if venue.venueID == GlobalVariables.eventSelected{
                    Name.text = venue.venueName
                    Address.text = venue.venueAddress
                    Price.text = "-"
                    Date.text = "-"
                    smallImage.image = UIImage(named: venue.primaryCategory)
                    webDescriptionContent.loadHTMLString("<font color=\"black\">\(venue.venueDescription)</font>", baseURL: nil)
                }
                if venue.venueID == GlobalVariables.eventSelected && addictionInfo!.contains({$0.venueID == GlobalVariables.eventSelected}) {
                    
                    getAddictedButton.backgroundColor = UIColor.orangeColor()
                    getAddictedLabel.text = "You are addicted"
                }
            }

        }
        if GlobalVariables.selectedDisplay == "Organization"{
            let organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()
            let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsOrganization()
            for organization in organizationInfo!{
                if organization.organizationID == GlobalVariables.eventSelected{
                    Name.text = organization.organizationName
                    Address.text = organization.organizationAddress
                    Price.text = "-"
                    Date.text = "-"
                    smallImage.image = UIImage(named: organization.primaryCategory)
                    webDescriptionContent.loadHTMLString("<font color=\"black\">\(organization.organizationDescription)</font>", baseURL: nil)
                }
                if organization.organizationID == GlobalVariables.eventSelected && addictionInfo!.contains({$0.organizationID == GlobalVariables.eventSelected}) {
                    
                    getAddictedButton.backgroundColor = UIColor.orangeColor()
                    getAddictedLabel.text = "You are addicted"
                }
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPanel()
        labelDisplay()
        webDescriptionContent.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.swipeZoneHeight = self.panelControllerContainer.swipableZoneHeight
        self.visibleZoneHeight = self.panelControllerContainer.visibleZoneHeight
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Logic of getting addicted
    @IBAction func getAddicted(sender: AnyObject) {
        //LoggedIn
        if GlobalVariables.loggedIn == true {
            let user = FetchData(context: managedObjectContext).fetchUserInfo()![0].userName
            //Event
            if GlobalVariables.selectedDisplay == "Event"{
                let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
                let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
                for event in eventInfo!{
                    if event.eventID == GlobalVariables.eventSelected && !addictionInfo!.contains({$0.eventID == GlobalVariables.eventSelected}) {
                        let addEvent = AddictionEvent(eventId: event.eventID, userId: user)
                        SaveData(context: managedObjectContext).saveAddictionEvent(addEvent)
                        print("new getaddicted success!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                        let eventService = EventService()
                        eventService.addAddictedEvents(event.eventID){
                            (let addInfo) in
                            print(addInfo!)
                        }
                        
                        getAddictedButton.backgroundColor = UIColor.orangeColor()
                        getAddictedLabel.text = "You are addicted"
                        
                    } else if event.eventID == GlobalVariables.eventSelected && addictionInfo!.contains({$0.eventID == GlobalVariables.eventSelected}) {
                        
                        let alertController = UIAlertController(title: "Are you no longer addicted?", message:nil, preferredStyle: .Alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                        let unlikeAction = UIAlertAction(title: "I'm Over It", style: .Default) { (_) -> Void in
                
                            DeleteData(context: self.managedObjectContext).deleteAddictionsEvent(event.eventID, deleteUser: user)
                            print("Removed from addiction(event) \(event.eventID)")
                            print("REMOVED")
                            
                            let eventService = EventService()
                            eventService.removeAddictedEvents(event.eventID) {
                                (let removeInfo ) in
                                print(removeInfo!)
                            }
                            
                            self.getAddictedButton.backgroundColor = UIColor.cyanColor()
                            self.getAddictedLabel.text = "Get addicted"
                            
                        }
                        alertController.addAction(unlikeAction)
                        alertController.addAction(cancelAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
//                        let alert = UIAlertView(title: "You are addicted", message: nil, delegate: nil, cancelButtonTitle: nil)
//                        alert.show()
//                        let delay = 1.0 * Double(NSEC_PER_SEC)
//                        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//                        dispatch_after(time, dispatch_get_main_queue(), {
//                            alert.dismissWithClickedButtonIndex(-1, animated: true)
//                        })
                    }
                }
            }
            //Venue
            if GlobalVariables.selectedDisplay == "Venue"{
                let venueInfo = FetchData(context: managedObjectContext).fetchVenues()
                let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsVenue()
                for venue in venueInfo!{
                    if venue.venueID == GlobalVariables.eventSelected && !addictionInfo!.contains({$0.venueID == GlobalVariables.eventSelected}) {
                        let addVenue = AddictionVenue(venueId: venue.venueID, userId: user)
                        SaveData(context: managedObjectContext).saveAddictionVenue(addVenue)
                        print("new Venue getaddicted success!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                        let venueService = VenueService()
                        venueService.addAddictedVenues(venue.venueID){
                            (let addInfo) in
                            print(addInfo!)
                        }
                        
                        getAddictedButton.backgroundColor = UIColor.orangeColor()
                        getAddictedLabel.text = "You are addicted"
                        
                    } else if venue.venueID == GlobalVariables.eventSelected && addictionInfo!.contains({$0.venueID == GlobalVariables.eventSelected}) {
                        
                        let alertController = UIAlertController(title: "Are you no longer addicted?", message:nil, preferredStyle: .Alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                        let unlikeAction = UIAlertAction(title: "I'm Over It", style: .Default) { (_) -> Void in
                            
                            DeleteData(context: self.managedObjectContext).deleteAddictionsVenue(venue.venueID, deleteUser: user)
                            print("Removed from addiction(venue) \(venue.venueID)")
                            print("REMOVED")
                            
                            let venueService = VenueService()
                            venueService.removeAddictedVenues(venue.venueID) {
                                (let removeInfo ) in
                                print(removeInfo!)
                            }
                            
                            self.getAddictedButton.backgroundColor = UIColor.cyanColor()
                            self.getAddictedLabel.text = "Get addicted"
                            
                        }
                        alertController.addAction(unlikeAction)
                        alertController.addAction(cancelAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
            //Organization
            if GlobalVariables.selectedDisplay == "Organization"{
                let organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()
                let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsOrganization()
                for organization in organizationInfo!{
                    if organization.organizationID == GlobalVariables.eventSelected{
                        let addOrganization = AddictionOrganization(organizationId: organization.organizationID, userId: user)
                        SaveData(context: managedObjectContext).saveAddictionOrganization(addOrganization)
                        print("new ORG getaddicted success!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                        let organizationService = OrganizationService()
                        organizationService.addAddictedOrganizations(organization.organizationID){
                            (let addInfo) in
                            print(addInfo!)
                        }
                        
                        getAddictedButton.backgroundColor = UIColor.orangeColor()
                        getAddictedLabel.text = "You are addicted"
                        
                    } else if organization.organizationID == GlobalVariables.eventSelected && addictionInfo!.contains({$0.organizationID == GlobalVariables.eventSelected}) {
                        
                        let alertController = UIAlertController(title: "Are you no longer addicted?", message:nil, preferredStyle: .Alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                        let unlikeAction = UIAlertAction(title: "I'm Over It", style: .Default) { (_) -> Void in
                            
                            DeleteData(context: self.managedObjectContext).deleteAddictionsOrgainzation(organization.organizationID, deleteUser: user)
                            print("Removed from addiction(event) \(organization.organizationID)")
                            print("REMOVED")
                            
                            let organizationService = OrganizationService()
                            
                            organizationService.removeAddictedOrganizations(organization.organizationID) {
                                (let removeInfo ) in
                                print(removeInfo!)
                            }
                            
                            self.getAddictedButton.backgroundColor = UIColor.cyanColor()
                            self.getAddictedLabel.text = "Get addicted"
                            
                        }
                        alertController.addAction(unlikeAction)
                        alertController.addAction(cancelAction)
                    }
                }
            }
        }
        else { //user not logged in
            
            let alert = UIAlertView(title: "Please log in for this!!!", message: nil, delegate: nil, cancelButtonTitle: nil)
            alert.show()
            let delay = 1.0 * Double(NSEC_PER_SEC)
            var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                alert.dismissWithClickedButtonIndex(-1, animated: true)
            })
        }
    }

    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .LinkClicked:
            // Open links in Safari
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        default:
            // Handle other navigation types...
            return true
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
