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
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    var panelControllerContainer: ARSPContainerController!
    
    func configureView(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        addictionTableView.rowHeight = screenHeight * 0.33
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        self.panelControllerContainer.dragDelegate = self
        self.panelControllerContainer.visibilityStateDelegate = self
        self.addictionTableView!.allowsMultipleSelection = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotification", name: "itemDisplayChange", object: nil)
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
        switch (GlobalVariables.selectedDisplay){
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
            let organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()
            return (organizationInfo?.count)!
        default:
            let venueInfo = FetchData(context: managedObjectContext).fetchVenues()
            return (venueInfo?.count)!
        }
        
    }

    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch (GlobalVariables.selectedDisplay){
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
                    if let checkedUrl = NSURL(string:event.posterUrl) {
                        //println("Started downloading \"\(checkedUrl.lastPathComponent!.stringByDeletingPathExtension)\".")
                        getDataFromUrl(checkedUrl) { data in
                            dispatch_async(dispatch_get_main_queue()) {
                                //println("Finished downloading \"\(checkedUrl.lastPathComponent!.stringByDeletingPathExtension)\".")
                                cell.ExploreImage.image = UIImage(data: data!)
                            }
                    
                        }
                
                    }
                    
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
            
            
            var temp: NSMutableArray = NSMutableArray()
            temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Unlike")
            cell.leftUtilityButtons = temp as [AnyObject]
            
            
            var temp2: NSMutableArray = NSMutableArray()
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
                    if let checkedUrl = NSURL(string:venue.posterUrl) {
                        //println("Started downloading \"\(checkedUrl.lastPathComponent!.stringByDeletingPathExtension)\".")
                        getDataFromUrl(checkedUrl) { data in
                            dispatch_async(dispatch_get_main_queue()) {
                                //println("Finished downloading \"\(checkedUrl.lastPathComponent!.stringByDeletingPathExtension)\".")
                                cell.venueImage.image = UIImage(data: data!)
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
            
            
            var temp: NSMutableArray = NSMutableArray()
            temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Unlike")
            cell.leftUtilityButtons = temp as [AnyObject]
            
            
            var temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor.grayColor(), title: "Map")
            temp2.sw_addUtilityButtonWithColor(UIColor.orangeColor(), title: "More Info")
            cell.rightUtilityButtons = nil
            cell.rightUtilityButtons = temp2 as [AnyObject]
            
            cell.delegate = self
            cell.selectionStyle = .None
            
            return cell as VenueTableViewCell
            
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
            let user = FetchData(context: managedObjectContext).fetchUserInfo()![0].userName
            
            //When Event is selected
            if (GlobalVariables.selectedDisplay == "Event") {
                var cellIndexPath = self.addictionTableView.indexPathForCell(cell)
                var selectedCell = self.addictionTableView.cellForRowAtIndexPath(cellIndexPath!) as! EventTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                
                let addictedEventInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
                for addicted in addictedEventInfo!{
                    if addicted.eventID == GlobalVariables.eventSelected {
                        
                        //Unlike
                        DeleteData(context: managedObjectContext).deleteAddictionsEvent(addicted.eventID, deleteUser: user)
                        println("Removed from addiction(event) \(addicted.eventID)")
                        println("REMOVED")
                        
                        //Remove Cell
                        var cellToDelete: AnyObject = cellIndexPath as! AnyObject
                        self.addictionTableView.deleteRowsAtIndexPaths([cellToDelete], withRowAnimation: UITableViewRowAnimation.Fade)
                        
                    }
                }
            }
            
            //When Venue is selected
            if (GlobalVariables.selectedDisplay == "Venue") {
                var cellIndexPath = self.addictionTableView.indexPathForCell(cell)
                var selectedCell = self.addictionTableView.cellForRowAtIndexPath(cellIndexPath!) as! VenueTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                
                let addictedVenueInfo = FetchData(context: managedObjectContext).fetchAddictionsVenue()
                for addicted in addictedVenueInfo!{
                    if addicted.venueID == GlobalVariables.eventSelected {
                        
                        //Unlike
                        DeleteData(context: managedObjectContext).deleteAddictionsVenue(addicted.venueID, deleteUser: user)
                        println("Removed from addiction(venue) \(addicted.venueID)")
                        println("REMOVED")
                        
                        //Remove Cell
                        var cellToDelete: AnyObject = cellIndexPath as! AnyObject
                        self.addictionTableView.deleteRowsAtIndexPaths([cellToDelete], withRowAnimation: UITableViewRowAnimation.Fade)
                        
                    }
                }
            }
            
            //When Organization is selected
            if (GlobalVariables.selectedDisplay == "Organization") {
                var cellIndexPath = self.addictionTableView.indexPathForCell(cell)
                var selectedCell = self.addictionTableView.cellForRowAtIndexPath(cellIndexPath!) as! OrganizationTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                
                let addictedOrganizationInfo = FetchData(context: managedObjectContext).fetchAddictionsOrganization()
                for addicted in addictedOrganizationInfo!{
                    if addicted.organizationID == GlobalVariables.eventSelected {
                        
                        //Unlike
                        DeleteData(context: managedObjectContext).deleteAddictionsOrgainzation(addicted.organizationID, deleteUser: user)
                        println("Removed from addiction(organization) \(addicted.organizationID)")
                        println("REMOVED")
                        
                        //Remove Cell
                        var cellToDelete: AnyObject = cellIndexPath as! AnyObject
                        self.addictionTableView.deleteRowsAtIndexPaths([cellToDelete], withRowAnimation: UITableViewRowAnimation.Fade)
                        
                    }
                }
            }
            
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
        
        let indexPath = tableView.indexPathForSelectedRow();
        
        if GlobalVariables.selectedDisplay == "Event"{
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! EventTableViewCell;
            currentCell.tappedView();
            tableView.deselectRowAtIndexPath(indexPath!, animated: false)
            
        }
        if GlobalVariables.selectedDisplay == "Venue"{
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! VenueTableViewCell;
            currentCell.tappedView();
            tableView.deselectRowAtIndexPath(indexPath!, animated: false)
            
        }
        if GlobalVariables.selectedDisplay == "Artist"{
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! ArtistTableViewCell;
            currentCell.tappedView();
            tableView.deselectRowAtIndexPath(indexPath!, animated: false)
            
        }
        if GlobalVariables.selectedDisplay == "Organization"{
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! OrganizationTableViewCell;
            currentCell.tappedView();
            tableView.deselectRowAtIndexPath(indexPath!, animated: false)
            
        }
    }
    
    func panelControllerChangedVisibilityState(state:ARSPVisibilityState) {
        //TODO
        if(panelControllerContainer.shouldOverlapMainViewController){
            if (state.value == ARSPVisibilityStateMaximized.value) {
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
    
    func updateNotification(){
        
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
