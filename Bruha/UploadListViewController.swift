//
//  UploadListViewController.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-10-14.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import UIKit
import CoreData

class UploadListViewController: UIViewController, SWTableViewCellDelegate, ARSPDragDelegate, ARSPVisibilityStateDelegate{
    
    @IBOutlet weak var uploadTableView: UITableView!
    @IBOutlet weak var bruhaButton: UIButton!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    var panelControllerContainer: ARSPContainerController!
    
    func configureView(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        uploadTableView.rowHeight = screenHeight * 0.5
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        self.panelControllerContainer.dragDelegate = self
        self.panelControllerContainer.visibilityStateDelegate = self
        self.uploadTableView!.allowsMultipleSelection = false
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
        //customStatusBar()
        
        uploadTableView.backgroundColor = UIColor.blackColor()
        uploadTableView.separatorColor = UIColor.blackColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationUpload", name: "itemDisplayChangeUpload", object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        uploadTableView.reloadData()
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
        switch (GlobalVariables.uploadDisplay){
        case "Event":
            let userEventInfo = FetchData(context: managedObjectContext).fetchUserEvents()
            //print("this is THE USER EVEVEVENTTTSSSSS", userEventInfo)
            return (userEventInfo?.count)!
        case "Venue":
            let userVenueInfo = FetchData(context: managedObjectContext).fetchUserVenues()
            return (userVenueInfo?.count)!
        case "Artist":
            let artistInfo = FetchData(context: managedObjectContext).fetchArtists()
            return (artistInfo?.count)!
        case "Organization":
            let organizationInfo = FetchData(context: managedObjectContext).fetchUserOrganizations()
            return (organizationInfo?.count)!
        default:
            let venueInfo = FetchData(context: managedObjectContext).fetchUserVenues()
            return (venueInfo?.count)!
        }
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if GlobalVariables.uploadDisplay == "Event"{
            if let animatedCell = cell as? EventTableViewCell {
                animatedCell.animate()
            }
            
        }
        if GlobalVariables.uploadDisplay == "Venue"{
            if let animatedCell = cell as? VenueTableViewCell {
                animatedCell.animate()
            }
            
        }
        if GlobalVariables.uploadDisplay == "Organization"{
            if let animatedCell = cell as? OrganizationTableViewCell {
                animatedCell.animate()
            }
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let posterInfo = FetchData(context: managedObjectContext).fetchPosterImages()
        
        switch (GlobalVariables.uploadDisplay){
        case "Event":
            var cell : EventTableViewCell! = tableView.dequeueReusableCellWithIdentifier("eventTableViewCell") as! EventTableViewCell!
            
            if(cell == nil){
                
                cell = NSBundle.mainBundle().loadNibNamed("EventTableViewCell", owner: self, options: nil)[0] as! EventTableViewCell;
            }
            
            let eventInfo = FetchData(context: managedObjectContext).fetchUserEvents()
            let event = eventInfo![indexPath.row]
            
            //println("Begin of code")
            cell.ExploreImage.contentMode = UIViewContentMode.ScaleToFill
            if let images = posterInfo {
                for img in images {
                    if img.ID == event.eventID {
                        if img.Image?.length > 800 {
                            cell.ExploreImage.image = UIImage(data: img.Image!)
                        } else {
                            cell.ExploreImage.backgroundColor = UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1)
                        }
                    }
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
            
            cell.circTitle.text = event.eventName
            cell.circDate.text = event.eventStartDate
            //cell.circPrice.text = "$\(event.eventPrice!)"
            cell.circHiddenID.text = event.eventID
            
            cell.rectTitle.text = event.eventName
            //cell.rectPrice.text = "$\(event.eventPrice!)"
            
            if let price = Float(event.eventPrice!) {
                if price == 0.0 {cell.circPrice.text = "Free!"; cell.rectPrice.text = "Free!"}
                else {cell.circPrice.text = "$\(price)"; cell.rectPrice.text = "$\(price)"}
            } else {cell.circPrice.text = "No Price"; cell.rectPrice.text = "No Price"}
            
            
            if event.eventVenueName == "" {
                cell.venueName.text = "nil"
            }else{cell.venueName.text = event.eventVenueName}
            
            cell.venueAddress.text = "\(event.eventVenueAddress.componentsSeparatedByString(", ")[0])\n\(event.eventVenueCity)"
            
            cell.startTime.text = "\(convertRectTimeFormat("\(event.eventStartDate) \(event.eventStartTime)")) -"
            cell.endTime.text = convertRectTimeFormat("\(event.eventEndDate) \(event.eventEndTime)")
            //cell.startDate.text = event.eventStartDate
            //cell.startTime.text = "\(event.eventStartTime) -"
            //cell.endDate.text = event.eventEndDate
            //cell.endTime.text = event.eventEndTime
            
            cell.rectCategory.contentMode = UIViewContentMode.ScaleAspectFill
            cell.rectCategory.image = UIImage(named: event.primaryCategory)
            cell.rectCategoryName.text = event.primaryCategory
            
            cell.circAddicted.contentMode = UIViewContentMode.ScaleAspectFit
            cell.circAddicted.image = UIImage(named: "MyUploads_Sm")
            cell.circCategory.contentMode = UIViewContentMode.ScaleAspectFit
            cell.circCategory.image = UIImage(named: event.primaryCategory)
            
            cell.rectCategory.contentMode = UIViewContentMode.ScaleAspectFill
            cell.rectCategory.image = UIImage(named: event.primaryCategory)
            cell.rectCategoryName.text = event.primaryCategory
            // Configure the cell...

            
            let temp: NSMutableArray = NSMutableArray()
            temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),title: "Delete")
            cell.leftUtilityButtons = temp as [AnyObject]
            
            
            let temp2: NSMutableArray = NSMutableArray()
            //temp2.sw_addUtilityButtonWithColor(UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1), title: "Buy Tickets")
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1), title: "Map")
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1), title: "More Info")
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
            
            
            let venueInfo = FetchData(context: managedObjectContext).fetchUserVenues()
            let venue = venueInfo![indexPath.row]
            
            cell.venueImage.contentMode = UIViewContentMode.ScaleToFill
            if let images = posterInfo {
                for img in images {
                    if img.ID == venue.venueID {
                        if img.Image?.length > 800 {
                            cell.venueImage.image = UIImage(data: img.Image!)
                        } else {
                            cell.venueImage.backgroundColor = UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1)
                        }
                    }
                }
            }
            
            cell.venueName.text = venue.venueName
            cell.venueDescription.text = venue.venueName
            cell.venueAddress.text = "\(venue.venueAddress.componentsSeparatedByString(", ")[0])"
            cell.circVenueName.text = venue.venueName
            cell.circHiddenID.text = venue.venueID
            
            cell.circAddicted.contentMode = UIViewContentMode.ScaleAspectFit
            cell.circAddicted.image = UIImage(named: "MyUploads_Sm")
            cell.circCategory.contentMode = UIViewContentMode.ScaleAspectFit
            cell.circCategory.image = UIImage(named: venue.primaryCategory)
            
            cell.rectCategory.contentMode = UIViewContentMode.ScaleAspectFill
            cell.rectCategory.image = UIImage(named: venue.primaryCategory)
            cell.rectCategoryName.text = venue.primaryCategory
            
            
            let temp: NSMutableArray = NSMutableArray()
            temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),title: "Delete")
            cell.leftUtilityButtons = temp as [AnyObject]
            
            
            let temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1), title: "Map")
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1), title: "More Info")
            cell.rightUtilityButtons = nil
            cell.rightUtilityButtons = temp2 as [AnyObject]
            
            cell.delegate = self
            cell.selectionStyle = .None
            
            return cell as VenueTableViewCell
            
//        case "Artist":

            
        case "Organization":
            
            var cell : OrganizationTableViewCell! = tableView.dequeueReusableCellWithIdentifier("organizationTableViewCell") as! OrganizationTableViewCell!
            
            if(cell == nil)
            {
                cell = NSBundle.mainBundle().loadNibNamed("OrganizationTableViewCell", owner: self, options: nil)[0] as! OrganizationTableViewCell;
            }
            
            let organizationInfo = FetchData(context: managedObjectContext).fetchUserOrganizations()
            let organization = organizationInfo![indexPath.row]
            
            cell.organizationImage.contentMode = UIViewContentMode.ScaleToFill
            if let images = posterInfo {
                for img in images {
                    if img.ID == organization.organizationID {
                        if img.Image?.length > 800 {
                            cell.organizationImage.image = UIImage(data: img.Image!)
                        } else {
                            cell.organizationImage.backgroundColor = UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1)
                        }
                    }
                }
            }
            
            cell.organizationName.text = organization.organizationName
            cell.organizationDescription.text = organization.organizationName
            cell.address.text = "\(organization.organizationAddress.componentsSeparatedByString(", ")[0])"
            cell.circOrgName.text = organization.organizationName
            cell.circHiddenID.text = organization.organizationID
            
            cell.circAddicted.contentMode = UIViewContentMode.ScaleAspectFit
            cell.circAddicted.image = UIImage(named: "MyUploads_Sm")
            cell.circCategory.contentMode = UIViewContentMode.ScaleAspectFit
            cell.circCategory.image = UIImage(named: organization.primaryCategory)
            
            cell.rectCategory.contentMode = UIViewContentMode.ScaleAspectFill
            cell.rectCategory.image = UIImage(named: organization.primaryCategory)
            cell.rectCategoryName.text = organization.primaryCategory
            
            let temp: NSMutableArray = NSMutableArray()
            temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),title: "Delete")
            cell.leftUtilityButtons = temp as [AnyObject]
            
            
            let temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1), title: "Map")
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1), title: "More Info")
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
            if (GlobalVariables.uploadDisplay == "Event") {
                var cellIndexPath = self.uploadTableView.indexPathForCell(cell)
                var selectedCell = self.uploadTableView.cellForRowAtIndexPath(cellIndexPath!) as! EventTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                
                let userEventInfo = FetchData(context: managedObjectContext).fetchUserEvents()
                for userEvent in userEventInfo!{
                    if userEvent.eventID == GlobalVariables.eventSelected {
                        
                        //Unlike
                        DeleteData(context: managedObjectContext).deleteUserEvent(userEvent.eventID)
                        print("Removed from upload(event) \(userEvent.eventID)")
                        print("REMOVED")
                        
                        let eventService = EventService()
                        eventService.removeUserEvents(userEvent.eventID) {
                            (let removeInfo ) in
                            print(removeInfo!)
                        }
                        
                        uploadTableView.reloadData()
                    }
                }
            }
                
            else if (GlobalVariables.uploadDisplay == "Venue") {
                var cellIndexPath = self.uploadTableView.indexPathForCell(cell)
                var selectedCell = self.uploadTableView.cellForRowAtIndexPath(cellIndexPath!) as! VenueTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                
                let userVenueInfo = FetchData(context: managedObjectContext).fetchUserVenues()
                for userVenue in userVenueInfo!{
                    if userVenue.venueID == GlobalVariables.eventSelected {
                        
                        //Unlike
                        DeleteData(context: managedObjectContext).deleteUserVenue(userVenue.venueID)
                        print("Removed from upload(venue) \(userVenue.venueID)")
                        print("REMOVED")
                        
                        let venueService = VenueService()
                        venueService.removeUserVenues(userVenue.venueID) {
                            (let removeInfo ) in
                            print(removeInfo!)
                        }
                        
                        uploadTableView.reloadData()
                    }
                }
            }
                
            else if (GlobalVariables.uploadDisplay == "Organization") {
                var cellIndexPath = self.uploadTableView.indexPathForCell(cell)
                var selectedCell = self.uploadTableView.cellForRowAtIndexPath(cellIndexPath!) as! OrganizationTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                
                let userOrganizationInfo = FetchData(context: managedObjectContext).fetchUserOrganizations()
                for userOrganization in userOrganizationInfo!{
                    if userOrganization.organizationID == GlobalVariables.eventSelected {
                        
                        //Unlike
                        DeleteData(context: managedObjectContext).deleteUserOrganization(userOrganization.organizationID)
                        print("Removed from upload(organization) \(userOrganization.organizationID)")
                        print("REMOVED")
                        
                        let organizationService = OrganizationService()
                        organizationService.removeUserOrganizations(userOrganization.organizationID) {
                            (let removeInfo ) in
                            print(removeInfo!)
                        }
                        
                        uploadTableView.reloadData()
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
            
            if GlobalVariables.uploadDisplay == "Event" {
                let cellIndexPath = self.uploadTableView.indexPathForCell(cell)
                let selectedCell = self.uploadTableView.cellForRowAtIndexPath(cellIndexPath!) as! EventTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                self.performSegueWithIdentifier("ShowOnMap", sender: self)
            }
            else if GlobalVariables.uploadDisplay == "Venue" {
                let cellIndexPath = self.uploadTableView.indexPathForCell(cell)
                let selectedCell = self.uploadTableView.cellForRowAtIndexPath(cellIndexPath!) as! VenueTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                self.performSegueWithIdentifier("ShowOnMap", sender: self)
            }
            else if GlobalVariables.uploadDisplay == "Organization" {
                let cellIndexPath = self.uploadTableView.indexPathForCell(cell)
                let selectedCell = self.uploadTableView.cellForRowAtIndexPath(cellIndexPath!) as! OrganizationTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                self.performSegueWithIdentifier("ShowOnMap", sender: self)
            }
            
            
        case 1:
            
            if GlobalVariables.uploadDisplay == "Event" {
                let cellIndexPath = self.uploadTableView.indexPathForCell(cell)
                let selectedCell = self.uploadTableView.cellForRowAtIndexPath(cellIndexPath!) as! EventTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                self.performSegueWithIdentifier("MoreInfore", sender: self)
            }
            else if GlobalVariables.uploadDisplay == "Venue" {
                let cellIndexPath = self.uploadTableView.indexPathForCell(cell)
                let selectedCell = self.uploadTableView.cellForRowAtIndexPath(cellIndexPath!) as! VenueTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                self.performSegueWithIdentifier("MoreInfore", sender: self)
            }
            else if GlobalVariables.uploadDisplay == "Organization" {
                let cellIndexPath = self.uploadTableView.indexPathForCell(cell)
                let selectedCell = self.uploadTableView.cellForRowAtIndexPath(cellIndexPath!) as! OrganizationTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                self.performSegueWithIdentifier("MoreInfore", sender: self)
            }
            
            
            
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
        
        if GlobalVariables.uploadDisplay == "Event"{
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! EventTableViewCell;
            currentCell.tappedView();
            tableView.deselectRowAtIndexPath(indexPath!, animated: false)
            
        }
        if GlobalVariables.uploadDisplay == "Venue"{
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! VenueTableViewCell;
            currentCell.tappedView();
            tableView.deselectRowAtIndexPath(indexPath!, animated: false)
            
        }
        if GlobalVariables.uploadDisplay == "Artist"{
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! ArtistTableViewCell;
            currentCell.tappedView();
            tableView.deselectRowAtIndexPath(indexPath!, animated: false)
            
        }
        if GlobalVariables.uploadDisplay == "Organization"{
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
    
    func updateNotificationUpload(){
        
        self.uploadTableView.reloadData()
    }
    
    func convertCircTimeFormat(date: String) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        if let ndate = dateFormatter.dateFromString(date) {
            
            dateFormatter.dateFormat = "MMM dd, yyyy"
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            let timeStamp = dateFormatter.stringFromDate(ndate)
            return timeStamp
        }
        else {return "nil or error times"}
    }
    
    func convertRectTimeFormat(date: String) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        if let ndate = dateFormatter.dateFromString(date) {
            
            dateFormatter.dateFormat = "EEEE, MMMM dd 'at' h:mma"
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            let timeStamp = dateFormatter.stringFromDate(ndate)
            return timeStamp
        }
        else {return "nil,error times"}
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



