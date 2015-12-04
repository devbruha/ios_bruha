//
//  AddictionListViewController.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-10-02.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import UIKit
import CoreData

class AddictionListViewController: UIViewController, SWTableViewCellDelegate, ARSPDragDelegate, ARSPVisibilityStateDelegate{

    @IBOutlet weak var addictionTableView: UITableView!
    @IBOutlet weak var bruhaButton: UIButton!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    var panelControllerContainer: ARSPContainerController!
    
    func configureView(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        addictionTableView.rowHeight = screenHeight * 0.5
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        self.panelControllerContainer.dragDelegate = self
        self.panelControllerContainer.visibilityStateDelegate = self
        self.addictionTableView!.allowsMultipleSelection = false
    }
    
    func customTopButtons() {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        bruhaButton.setBackgroundImage(UIImage(named: "Bruha_White"), forState: UIControlState.Normal)
        let heightContraints = NSLayoutConstraint(item: bruhaButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.height/15.5)
        heightContraints.priority = UILayoutPriorityDefaultHigh
        
        let widthContraints = NSLayoutConstraint(item: bruhaButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.width/9)
        widthContraints.priority = UILayoutPriorityDefaultHigh
        
        bruhaButton.addConstraints([heightContraints, widthContraints])
    }
    
    func customStatusBar() {
        let barView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        barView.backgroundColor = UIColor.grayColor()
        
        self.view.addSubview(barView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        customTopButtons()
        customStatusBar()
        
        addictionTableView.backgroundColor = UIColor.blackColor()
        addictionTableView.separatorColor = UIColor.blackColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationAddiction", name: "itemDisplayChangeAddiction", object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        //println("This is global variable on clicking \(GlobalVariables.selectedDisplay)")
        switch (GlobalVariables.addictedDisplay){
        case "Event":
            let addictedEventInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
            return (addictedEventInfo?.count)!
        case "Venue":
            let addictedVenueInfo = FetchData(context: managedObjectContext).fetchAddictionsVenue()
            return (addictedVenueInfo?.count)!
        case "Artist":
            let artistInfo = FetchData(context: managedObjectContext).fetchArtists()
            return (artistInfo?.count)!
        case "Organization":
            let organizationInfo = FetchData(context: managedObjectContext).fetchAddictionsOrganization()
            return (organizationInfo?.count)!
        default:
            let venueInfo = FetchData(context: managedObjectContext).fetchAddictionsVenue()
            return (venueInfo?.count)!
        }
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let posterInfo = FetchData(context: managedObjectContext).fetchPosterImages()
        
        switch (GlobalVariables.addictedDisplay){
        case "Event":
            var cell : EventTableViewCell! = tableView.dequeueReusableCellWithIdentifier("eventTableViewCell") as! EventTableViewCell!
            
            if(cell == nil){
                
                cell = NSBundle.mainBundle().loadNibNamed("EventTableViewCell", owner: self, options: nil)[0] as! EventTableViewCell;
            }

            let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
            let addictedEventInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
            for event in eventInfo!{
                
                //download only addicted poster image
                if event.eventID == addictedEventInfo![indexPath.row].eventID  {
                    //println("Begin of code")
                    cell.ExploreImage.contentMode = UIViewContentMode.ScaleToFill
                    if let images = posterInfo {
                        for img in images {
                            if img.ID == event.eventID {
                                if img.Image?.length > 800 {
                                    cell.ExploreImage.image = UIImage(data: img.Image!)
                                } else {
                                    cell.ExploreImage.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
                                }
                            }
                        }
                    }
//                    if let checkedUrl = NSURL(string:event.posterUrl) {
//                        //println("Started downloading \"\(checkedUrl.lastPathComponent!.stringByDeletingPathExtension)\".")
//                        getDataFromUrl(checkedUrl) { data in
//                            dispatch_async(dispatch_get_main_queue()) {
//                                //println("Finished downloading \"\(checkedUrl.lastPathComponent!.stringByDeletingPathExtension)\".")
//                                cell.ExploreImage.image = UIImage(data: data!)
//                            }
//                    
//                        }
//                
//                    }
                    
                    cell.circTitle.text = event.eventName
                    cell.circDate.text = event.eventStartDate
                    cell.circPrice.text = "$\(event.eventPrice!)"
                    cell.circHiddenID.text = event.eventID
                    
                    cell.rectTitle.text = event.eventDescription
                    cell.rectPrice.text = "$\(event.eventPrice!)"
                    cell.venueName.text = event.eventVenueName
                    cell.venueAddress.text = event.eventVenueAddress
                    cell.startDate.text = event.eventStartDate
                    cell.startTime.text = "\(event.eventStartTime) -"
                    cell.endDate.text = event.eventEndDate
                    cell.endTime.text = event.eventEndTime
                    // Configure the cell...
                    
                }
                
            }
            
            //println("End of code. The image will continue downloading in the background and it will be loaded when it ends.")
            //Synchronously:
            /*if let url = NSURL(string: event.url) {
            if let data = NSData(contentsOfURL: url){
            cell.ExploreImage.contentMode = UIViewContentMode.ScaleToFill
            cell.ExploreImage.image = UIImage(data: data)
            }
            }*/
            
            
            let temp: NSMutableArray = NSMutableArray()
            temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Addicted!")
            cell.leftUtilityButtons = temp as [AnyObject]
            
            
            let temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor.purpleColor(), title: "Buy Tickets")
            temp2.sw_addUtilityButtonWithColor(UIColor.grayColor(), title: "Map")
            temp2.sw_addUtilityButtonWithColor(UIColor.orangeColor(), title: "More Info")
            cell.rightUtilityButtons = nil
            cell.rightUtilityButtons = temp2 as [AnyObject]
            
            cell.delegate = self
            cell.selectionStyle = .None
            
            return cell as EventTableViewCell
        
        case "Venue":
            
            var cell : VenueTableViewCell! = tableView.dequeueReusableCellWithIdentifier("venueTableViewCell") as! VenueTableViewCell!
            
            if(cell == nil)
            {
                cell = NSBundle.mainBundle().loadNibNamed("VenueTableViewCell", owner: self, options: nil)[0] as! VenueTableViewCell;
            }
            
            
            let venueInfo = FetchData(context: managedObjectContext).fetchVenues()
            let addictedVenueInfo = FetchData(context: managedObjectContext).fetchAddictionsVenue()
            
            for venue in venueInfo! {
                if venue.venueID == addictedVenueInfo![indexPath.row].venueID  {
                    //println("Begin of code")
                    cell.venueImage.contentMode = UIViewContentMode.ScaleToFill
                    if let images = posterInfo {
                        for img in images {
                            if img.ID == venue.venueID {
                                if img.Image?.length > 800 {
                                    cell.venueImage.image = UIImage(data: img.Image!)
                                } else {
                                    cell.venueImage.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
                                }
                            }
                        }
                    }
                    
                    cell.venueName.text = venue.venueName
                    cell.venueDescription.text = venue.venueDescription
                    cell.venueAddress.text = venue.venueAddress
                    cell.circVenueName.text = venue.venueName
                    cell.circHiddenID.text = venue.venueID
                }
            
            }
            //let strCarName = item[indexPath.row] as String
            //cell.venueImage.image = UIImage(named: strCarName)
            
            
            let temp: NSMutableArray = NSMutableArray()
            temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Addicted!")
            cell.leftUtilityButtons = temp as [AnyObject]
            
            
            let temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor.grayColor(), title: "Map")
            temp2.sw_addUtilityButtonWithColor(UIColor.orangeColor(), title: "More Info")
            cell.rightUtilityButtons = nil
            cell.rightUtilityButtons = temp2 as [AnyObject]
            
            cell.delegate = self
            cell.selectionStyle = .None
            
            return cell as VenueTableViewCell
            
        case "Organization":
            
            var cell : OrganizationTableViewCell! = tableView.dequeueReusableCellWithIdentifier("organizationTableViewCell") as! OrganizationTableViewCell!
            
            if(cell == nil)
            {
                cell = NSBundle.mainBundle().loadNibNamed("OrganizationTableViewCell", owner: self, options: nil)[0] as! OrganizationTableViewCell;
            }
            
            let organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()
            let addictedOrganizationInfo = FetchData(context: managedObjectContext).fetchAddictionsOrganization()
            
            for organization in organizationInfo! {
                if organization.organizationID == addictedOrganizationInfo![indexPath.row].organizationID  {
                    //println("Begin of code")
                    cell.organizationImage.contentMode = UIViewContentMode.ScaleToFill
                    if let images = posterInfo {
                        for img in images {
                            if img.ID == organization.organizationID {
                                if img.Image?.length > 800 {
                                    cell.organizationImage.image = UIImage(data: img.Image!)
                                } else {
                                    cell.organizationImage.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
                                }
                            }
                        }
                    }
                    
                    cell.organizationName.text = organization.organizationName
                    cell.organizationDescription.text = organization.organizationDescription
                    cell.address.text = organization.organizationAddress
                    cell.circOrgName.text = organization.organizationName
                    cell.circHiddenID.text = organization.organizationID
                }
                
            }
            
            
            let temp: NSMutableArray = NSMutableArray()
            temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Addicted!")
            cell.leftUtilityButtons = temp as [AnyObject]
            
            
            let temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor.grayColor(), title: "Map")
            temp2.sw_addUtilityButtonWithColor(UIColor.orangeColor(), title: "More Info")
            cell.rightUtilityButtons = nil
            cell.rightUtilityButtons = temp2 as [AnyObject]
            
            cell.delegate = self
            cell.selectionStyle = .None
            
            return cell as OrganizationTableViewCell
            
        default:
            
            var cell : VenueTableViewCell! = tableView.dequeueReusableCellWithIdentifier("venueTableViewCell") as! VenueTableViewCell!
            
            if(cell == nil)
            {
                cell = NSBundle.mainBundle().loadNibNamed("VenueTableViewCell", owner: self, options: nil)[0] as! VenueTableViewCell;
            }
            
            return cell as VenueTableViewCell
        }
        
    
    
    }
    
    //Swipe Cells Actions
    func swipeableTableViewCell( cell : SWTableViewCell!,didTriggerLeftUtilityButtonWithIndex index:NSInteger){
        switch(index){
        case 0:
            //let user = FetchData(context: managedObjectContext).fetchUserInfo()![0].userName
            //println("the user is \(user)")
            //When Event is selected
            if (GlobalVariables.addictedDisplay == "Event") {
                let cellIndexPath = self.addictionTableView.indexPathForCell(cell)
                let selectedCell = self.addictionTableView.cellForRowAtIndexPath(cellIndexPath!) as! EventTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                
                let addictedEventInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
                for addicted in addictedEventInfo!{
                    if addicted.eventID == GlobalVariables.eventSelected {
                        
                        let alertController = UIAlertController(title: "Are you no longer addicted?", message:nil, preferredStyle: .Alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                        let unlikeAction = UIAlertAction(title: "I'm Over It", style: .Default) { (_) -> Void in
                            
                            //Unlike
                            DeleteData(context: self.managedObjectContext).deleteAddictionsEvent(addicted.eventID, deleteUser: GlobalVariables.username)
                            print("Removed from addiction(event) \(addicted.eventID), user \(GlobalVariables.username)")
                            print("REMOVED")
                            
                            let eventService = EventService()
                            eventService.removeAddictedEvents(addicted.eventID) {
                                (let removeInfo ) in
                                print(removeInfo!)
                            }
                            
                            /*
                            //Remove Cell
                            var cellToDelete: AnyObject = cellIndexPath as! AnyObject
                            self.addictionTableView.deleteRowsAtIndexPaths([cellToDelete], withRowAnimation: UITableViewRowAnimation.Fade)
                            */
                            
                            self.addictionTableView.reloadData()
                        }
                        alertController.addAction(unlikeAction)
                        alertController.addAction(cancelAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
            
            //When Venue is selected
            if (GlobalVariables.addictedDisplay == "Venue") {
                let cellIndexPath = self.addictionTableView.indexPathForCell(cell)
                let selectedCell = self.addictionTableView.cellForRowAtIndexPath(cellIndexPath!) as! VenueTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                
                let addictedVenueInfo = FetchData(context: managedObjectContext).fetchAddictionsVenue()
                for addicted in addictedVenueInfo!{
                    if addicted.venueID == GlobalVariables.eventSelected {
                        
                        let alertController = UIAlertController(title: "Are you no longer addicted?", message:nil, preferredStyle: .Alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                        let unlikeAction = UIAlertAction(title: "I'm Over It", style: .Default) { (_) -> Void in
                            
                            //Unlike
                            DeleteData(context: self.managedObjectContext).deleteAddictionsVenue(addicted.venueID, deleteUser: GlobalVariables.username)
                            print("Removed from addiction(venue) \(addicted.venueID), user \(GlobalVariables.username)")
                            print("REMOVED")
                            
                            let venueService = VenueService()
                            venueService.removeAddictedVenues(addicted.venueID) {
                                (let addInfo ) in
                                print(addInfo!)
                            }
                            
                            self.addictionTableView.reloadData()
                        }
                        alertController.addAction(unlikeAction)
                        alertController.addAction(cancelAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
            
            //When Organization is selected
            if (GlobalVariables.addictedDisplay == "Organization") {
                let cellIndexPath = self.addictionTableView.indexPathForCell(cell)
                let selectedCell = self.addictionTableView.cellForRowAtIndexPath(cellIndexPath!) as! OrganizationTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                
                let addictedOrganizationInfo = FetchData(context: managedObjectContext).fetchAddictionsOrganization()
                for addicted in addictedOrganizationInfo!{
                    if addicted.organizationID == GlobalVariables.eventSelected {
                        
                        let alertController = UIAlertController(title: "Are you no longer addicted?", message:nil, preferredStyle: .Alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                        let unlikeAction = UIAlertAction(title: "I'm Over It", style: .Default) { (_) -> Void in
                            
                            //Unlike
                            DeleteData(context: self.managedObjectContext).deleteAddictionsOrgainzation(addicted.organizationID, deleteUser: GlobalVariables.username)
                            print("Removed from addiction(organization) \(addicted.organizationID), user \(GlobalVariables.username)")
                            print("REMOVED")
                            
                            let organizationService = OrganizationService()
                            
                            organizationService.removeAddictedOrganizations(addicted.organizationID) {
                                (let removeInfo ) in
                                print(removeInfo!)
                            }
                            
                            self.addictionTableView.reloadData()
                        }
                        alertController.addAction(unlikeAction)
                        alertController.addAction(cancelAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
            
            break
        default:
            break
        }
    }
    
    func swipeableTableViewCell( cell : SWTableViewCell!,didTriggerRightUtilityButtonWithIndex index:NSInteger){
        
        switch(index){
        case 0:
            if GlobalVariables.addictedDisplay == "Event" {
                //event ticket
                print("event ticket")
            }
            else if GlobalVariables.addictedDisplay == "Venue" || GlobalVariables.addictedDisplay == "Organization" {
                //venue and organization map
                print("venue and org map")
            }
            break
        case 1:
            if GlobalVariables.addictedDisplay == "Event" {
                //event map
                print("event map")
            }
            else if GlobalVariables.addictedDisplay == "Venue" || GlobalVariables.addictedDisplay == "Organization" {
                //venue and organizaiton more info
                print("venue and org more info")
            }
            break
        case 2:
            //Event More info
            print("event more info")
            break
        default:
            break
        }
        
    }
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell : SWTableViewCell ) -> Bool {
        return true
    }
    
    //Circ and Rect View changing
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        
        if GlobalVariables.addictedDisplay == "Event"{
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! EventTableViewCell;
            currentCell.tappedView();
            tableView.deselectRowAtIndexPath(indexPath!, animated: false)
            
        }
        if GlobalVariables.addictedDisplay == "Venue"{
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! VenueTableViewCell;
            currentCell.tappedView();
            tableView.deselectRowAtIndexPath(indexPath!, animated: false)
            
        }
        if GlobalVariables.addictedDisplay == "Artist"{
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! ArtistTableViewCell;
            currentCell.tappedView();
            tableView.deselectRowAtIndexPath(indexPath!, animated: false)
            
        }
        if GlobalVariables.addictedDisplay == "Organization"{
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! OrganizationTableViewCell;
            currentCell.tappedView();
            tableView.deselectRowAtIndexPath(indexPath!, animated: false)
            
        }
    }
    
    func panelControllerChangedVisibilityState(state:ARSPVisibilityState) {
        //TODO
        if(panelControllerContainer.shouldOverlapMainViewController){
            if (state.rawValue == ARSPVisibilityStateMaximized.rawValue) {
                self.panelControllerContainer.panelViewController.view.alpha = 1
            }else{
                self.panelControllerContainer.panelViewController.view.alpha = 1
            }
        }else{
            self.panelControllerContainer.panelViewController.view.alpha = 1
        }
    }

    func panelControllerWasDragged(panelControllerVisibility : CGFloat) {
        
    }
    
    func updateNotificationAddiction(){
        
        self.addictionTableView.reloadData()
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
