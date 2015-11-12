//
//  MoreInfoPanelViewController.swift
//  Bruha
//
//  Created by lye on 15/11/4.
//  Copyright © 2015年 Bruha. All rights reserved.
//

import UIKit

class MoreInfoPanelViewController: UIViewController {
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var smallImage: UIImageView!
    
    
    var panelControllerContainer: ARSPContainerController!
    var swipeZoneHeight: CGFloat = 180
    var visibleZoneHeight: CGFloat = 180


    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPanel()
        labelDisplay()

        // Do any additional setup after loading the view.
    }
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
        if GlobalVariables.selectedDisplay == "Event"{
            let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
            for event in eventInfo{
                if event.eventID == GlobalVariables.eventSelected{
                    Name.text = event.eventName
                    Address.text = event.eventVenueAddress
                    Price.text = event.eventPrice
                    Date.text = event.eventStartDate
                }
            }
        }
        if GlobalVariables.selectedDisplay == "Venue"{
            let venueInfo = FetchData(context: managedObjectContext).fetchVenues()!
            for venue in venueInfo{
                if venue.venueID == GlobalVariables.eventSelected{
                    Name.text = venue.venueName
                    Address.text = venue.venueAddress
                    Price.text = "-"
                    Date.text = "-"
                }
            }

        }
        if GlobalVariables.selectedDisplay == "Organization"{
            let organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()
            for organization in organizationInfo!{
                if organization.organizationID == GlobalVariables.eventSelected{
                    Name.text = organization.organizationName
                    Address.text = organization.organizationAddress
                    Price.text = "-"
                    Date.text = "-"
                }
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.swipeZoneHeight = self.panelControllerContainer.swipableZoneHeight
        self.visibleZoneHeight = self.panelControllerContainer.visibleZoneHeight
        
    }
    //Logic of getting addicted
    @IBAction func getAddicted(sender: AnyObject) {
        //LoggedIn
        if GlobalVariables.loggedIn == true {
            let user = FetchData(context: managedObjectContext).fetchUserInfo()![0].userName
            //Event
            if GlobalVariables.selectedDisplay == "Event"{
                let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
                for event in eventInfo!{
                    if event.eventID == GlobalVariables.eventSelected{
                        let addEvent = AddictionEvent(eventId: event.eventID, userId: user)
                        SaveData(context: managedObjectContext).saveAddictionEvent(addEvent)
                        print("new getaddicted success!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                        let eventService = EventService()
                        eventService.addAddictedEvents(event.eventID){
                            (let addInfo) in
                            print(addInfo!)
                        }
                    }
                }
            }
            //Venue
            if GlobalVariables.selectedDisplay == "Venue"{
                let venueInfo = FetchData(context: managedObjectContext).fetchVenues()
                for venue in venueInfo!{
                    if venue.venueID == GlobalVariables.eventSelected{
                        let addVenue = AddictionVenue(venueId: venue.venueID, userId: user)
                        SaveData(context: managedObjectContext).saveAddictionVenue(addVenue)
                        print("new Venue getaddicted success!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                        let venueService = VenueService()
                        venueService.addAddictedVenues(venue.venueID){
                            (let addInfo) in
                            print(addInfo!)
                        }
                    }
                }
            }
            //Organization
            if GlobalVariables.selectedDisplay == "Organization"{
                let organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()
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
                    }
                }
            }
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
