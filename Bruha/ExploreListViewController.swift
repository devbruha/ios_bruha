//
//  ExploreViewController.swift
//  Bruha
//
//  Created by lye on 15/7/27.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit
import CoreData

class ExploreListViewController: UIViewController, SWTableViewCellDelegate,ARSPDragDelegate, ARSPVisibilityStateDelegate {
    
    @IBOutlet weak var exploreTableView: UITableView!
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var panelControllerContainer: ARSPContainerController!
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    
    func configureView(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        exploreTableView.rowHeight = screenHeight * 0.33
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        self.panelControllerContainer.dragDelegate = self
        self.panelControllerContainer.visibilityStateDelegate = self
        self.exploreTableView!.allowsMultipleSelection = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotification", name: "itemDisplayChange", object: nil)
        
        GlobalVariables.displayedEvents = FetchData(context: managedObjectContext).fetchEvents()!
        GlobalVariables.displayedVenues = FetchData(context: managedObjectContext).fetchVenues()!
        GlobalVariables.displayedArtists = FetchData(context: managedObjectContext).fetchArtists()!
        GlobalVariables.displayedOrganizations = FetchData(context: managedObjectContext).fetchOrganizations()!
        
        var f = FetchData(context: managedObjectContext).fetchEventCategories()
        
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
            let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
            
            return (eventInfo?.count)!
        case "Venue":
            let venueInfo = FetchData(context: managedObjectContext).fetchVenues()
            return (venueInfo?.count)!
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
            var event = eventInfo![indexPath.row]
            
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
            
            
            var temp: NSMutableArray = NSMutableArray()
            var like = 0
            let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
            for addict in addictionInfo! {
                if addict.eventID == eventInfo![indexPath.row].eventID {
                    like = 1
                }
            }
            
            if like == 0 {
                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Like")
            } else if like == 1 {
                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Unlike")
            }
            
            cell.leftUtilityButtons = temp as [AnyObject]
    
            //println(cell.leftUtilityButtons[0].titleLabel!!.text!)
            

            var temp2: NSMutableArray = NSMutableArray()
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
            let venue = venueInfo![indexPath.row]
            
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
            
            
            //let strCarName = item[indexPath.row] as String
            //cell.venueImage.image = UIImage(named: strCarName)
            cell.venueName.text = venue.venueName
            cell.venueDescription.text = venue.venueDescription
            cell.venueAddress.text = venue.venueAddress
            cell.circVenueName.text = venue.venueName
            cell.circHiddenID.text = venue.venueID
            
            
            var temp: NSMutableArray = NSMutableArray()
            var like = 0
            let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsVenue()
            for addict in addictionInfo! {
                if addict.venueID == venueInfo![indexPath.row].venueID {
                    like = 1
                }
            }
            
            if like == 0 {
                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Like")
            } else if like == 1 {
                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Unlike")
            }
            
            cell.leftUtilityButtons = temp as [AnyObject]
            
            
            var temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor.grayColor(), title: "Map")
            temp2.sw_addUtilityButtonWithColor(UIColor.orangeColor(), title: "More Info")
            cell.rightUtilityButtons = nil
            cell.rightUtilityButtons = temp2 as [AnyObject]
            
            cell.delegate = self
            cell.selectionStyle = .None
            
            return cell as VenueTableViewCell
            
        case "Artist":
            
            var cell : ArtistTableViewCell! = tableView.dequeueReusableCellWithIdentifier("artistTableViewCell") as! ArtistTableViewCell!
            
            if(cell == nil)
            {
                cell = NSBundle.mainBundle().loadNibNamed("ArtistTableViewCell", owner: self, options: nil)[0] as! ArtistTableViewCell;
            }
            
            let artistInfo = FetchData(context: managedObjectContext).fetchArtists()
            let artist = artistInfo![indexPath.row]
            
            //println("Begin of code")
            cell.artistsImage.contentMode = UIViewContentMode.ScaleToFill
            if let checkedUrl = NSURL(string:artist.posterUrl) {
                //println("Started downloading \"\(checkedUrl.lastPathComponent!.stringByDeletingPathExtension)\".")
                getDataFromUrl(checkedUrl) { data in
                    dispatch_async(dispatch_get_main_queue()) {
                        //println("Finished downloading \"\(checkedUrl.lastPathComponent!.stringByDeletingPathExtension)\".")
                        cell.artistsImage.image = UIImage(data: data!)
                    }
                }
                
            }
            
            
            //let strCarName = item[indexPath.row] as String
            //cell.artistsImage.image = UIImage(named: strCarName)
            cell.artistName.text = artist.artistName
            cell.circArtistName.text = artist.artistName
            cell.circDescription.text = artist.artistDescription
            
            var temp: NSMutableArray = NSMutableArray()
            temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Like")
            cell.leftUtilityButtons = temp as [AnyObject]
            
            var temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor.grayColor(), title: "Map")
            temp2.sw_addUtilityButtonWithColor(UIColor.orangeColor(), title: "More Info")
            cell.rightUtilityButtons = nil
            cell.rightUtilityButtons = temp2 as [AnyObject]
            
            
            return cell as ArtistTableViewCell
            
        case "Organization":
            
            var cell : OrganizationTableViewCell! = tableView.dequeueReusableCellWithIdentifier("organizationTableViewCell") as! OrganizationTableViewCell!
            
            if(cell == nil)
            {
                cell = NSBundle.mainBundle().loadNibNamed("OrganizationTableViewCell", owner: self, options: nil)[0] as! OrganizationTableViewCell;
            }
            
            let organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()
            let organization = organizationInfo![indexPath.row]
            
            //println("Begin of code")
            cell.organizationImage.contentMode = UIViewContentMode.ScaleToFill
            if let checkedUrl = NSURL(string:organization.posterUrl) {
                //println("Started downloading \"\(checkedUrl.lastPathComponent!.stringByDeletingPathExtension)\".")
                getDataFromUrl(checkedUrl) { data in
                    dispatch_async(dispatch_get_main_queue()) {
                        //println("Finished downloading \"\(checkedUrl.lastPathComponent!.stringByDeletingPathExtension)\".")
                        cell.organizationImage.image = UIImage(data: data!)
                    }
                }
                
            }
            
            
            //let strCarName = item[indexPath.row] as String
            //cell.organizationImage.image = UIImage(named: strCarName)
            cell.organizationName.text = organization.organizationName
            cell.organizationDescription.text = organization.organizationDescription
            cell.address.text = organization.organizationAddress
            cell.circOrgName.text = organization.organizationName
            
            var temp: NSMutableArray = NSMutableArray()
            var like = 0
            let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsOrganization()
            for addict in addictionInfo! {
                if addict.organizationID == organizationInfo![indexPath.row].organizationID {
                    like = 1
                }
            }
            
            if like == 0 {
                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Like")
            } else if like == 1 {
                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Unlike")
            }
            
            cell.leftUtilityButtons = temp as [AnyObject]
            
            
            var temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor.grayColor(), title: "Map")
            temp2.sw_addUtilityButtonWithColor(UIColor.orangeColor(), title: "More Info")
            cell.rightUtilityButtons = nil
            cell.rightUtilityButtons = temp2 as [AnyObject]
            
            
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
            //Like and get addicted
            // Check if user is logged in
            if GlobalVariables.loggedIn == true {
                let user = FetchData(context: managedObjectContext).fetchUserInfo()![0].userName
                
                //When Event is selected
                if (GlobalVariables.selectedDisplay == "Event") {
                    var cellIndexPath = self.exploreTableView.indexPathForCell(cell)
                    var selectedCell = self.exploreTableView.cellForRowAtIndexPath(cellIndexPath!) as! EventTableViewCell
                    GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                    
                    let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
                    for event in eventInfo!{
                        if event.eventID == GlobalVariables.eventSelected {
                            //Like and Unlike
                            if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Unlike"){
                                
                                DeleteData(context: managedObjectContext).deleteAddictionsEvent(event.eventID, deleteUser: user)
                                println("Removed from addiction(event) \(event.eventID)")
                                println("REMOVED")
                                var temp: NSMutableArray = NSMutableArray()
                                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Like")
                                cell.leftUtilityButtons = temp as [AnyObject]
                                
                            } else if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Like") {
    
                                let addEvent = AddictionEvent(eventId: event.eventID, userId: user)
                                SaveData(context: managedObjectContext).saveAddictionEvent(addEvent)
                                println("Getting Addicted with event id \(event.eventID)")
                                println("ADDICTED")
                                var temp: NSMutableArray = NSMutableArray()
                                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Unlike")
                                cell.leftUtilityButtons = temp as [AnyObject]
                            }
                        }
                    }
                }
                
                //When Venue is selected
                if (GlobalVariables.selectedDisplay == "Venue") {
                    var cellIndexPath = self.exploreTableView.indexPathForCell(cell)
                    var selectedCell = self.exploreTableView.cellForRowAtIndexPath(cellIndexPath!) as! VenueTableViewCell
                    GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                    
                    let venueInfo = FetchData(context: managedObjectContext).fetchVenues()
                    for venue in venueInfo!{
                        if venue.venueID == GlobalVariables.eventSelected {
                            //Like and Unlike
                            if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Unlike"){
                                
                                DeleteData(context: managedObjectContext).deleteAddictionsVenue(venue.venueID, deleteUser: user)
                                println("Removed from addiction(venue) \(venue.venueID)")
                                println("REMOVED")
                                var temp: NSMutableArray = NSMutableArray()
                                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Like")
                                cell.leftUtilityButtons = temp as [AnyObject]
                            
                            } else if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Like") {
                                
                                let addVenue = AddictionVenue(venueId: venue.venueID, userId: user)
                                SaveData(context: managedObjectContext).saveAddictionVenue(addVenue)
                                println("Getting Addicted with venue id \(venue.venueID)")
                                println("ADDICTED")
                                var temp: NSMutableArray = NSMutableArray()
                                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Unlike")
                                cell.leftUtilityButtons = temp as [AnyObject]
                            }
                        }
                    }
                }

//                //When Artist is selected
//                if (GlobalVariables.selectedDisplay == "Artist") {
//                    println("artitititi")
//                    var cellIndexPath = self.exploreTableView.indexPathForCell(cell)
//                    var selectedCell = self.exploreTableView.cellForRowAtIndexPath(cellIndexPath!) as! ArtistTableViewCell
//                    GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
//                    
//                    let artistInfo = FetchData(context: managedObjectContext).fetchArtists()
//                    for artist in artistInfo!{
//                        if artist.artistID == GlobalVariables.eventSelected {
//                            //Like and Unlike
//                            if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Unlike"){
//                                
//                                DeleteData(context: managedObjectContext).deleteAddictionsArtist(artist.artistID, deleteUser: user)
//                                println("Removed from addiction(artist) \(artist.artistID)")
//                                println("REMOVED")
//                                var temp: NSMutableArray = NSMutableArray()
//                                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Like")
//                                cell.leftUtilityButtons = temp as [AnyObject]
//                                
//                            } else if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Like") {
//                                
//                                let addArtist = AddictionArtist(artistId: artist.artistID, userId: user)
//                                SaveData(context: managedObjectContext).saveAddictionArtist(addArtist)
//                                println("Getting Addicted with artist id \(artist.artistID)")
//                                println("ADDICTED")
//                                var temp: NSMutableArray = NSMutableArray()
//                                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Unlike")
//                                cell.leftUtilityButtons = temp as [AnyObject]
//                            }
//                        }
//                    }
//                }
                
                //When Oragnization is selected
                if (GlobalVariables.selectedDisplay == "Organization") {
                    var cellIndexPath = self.exploreTableView.indexPathForCell(cell)
                    var selectedCell = self.exploreTableView.cellForRowAtIndexPath(cellIndexPath!) as! OrganizationTableViewCell
                    GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                    
                    let organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()
                    for organization in organizationInfo!{
                        if organization.organizationID == GlobalVariables.eventSelected {
                            //Like and Unlike
                            if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Unlike"){
                                
                                DeleteData(context: managedObjectContext).deleteAddictionsOrgainzation(organization.organizationID, deleteUser: user)
                                println("Removed from addiction(event) \(organization.organizationID)")
                                println("REMOVED")
                                var temp: NSMutableArray = NSMutableArray()
                                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Like")
                                cell.leftUtilityButtons = temp as [AnyObject]
                                
                            } else if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Like") {
                                
                                let addOrgainzation = AddictionOrganization(organizationId: organization.organizationID, userId: user)
                                SaveData(context: managedObjectContext).saveAddictionOrganization(addOrgainzation)
                                println("Getting Addicted with event id \(organization.organizationID)")
                                println("ADDICTED")
                                var temp: NSMutableArray = NSMutableArray()
                                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Unlike")
                                cell.leftUtilityButtons = temp as [AnyObject]
                            }
                        }
                    }
                }
                
            } else {
                
                var alert = UIAlertView(title: "Please log in for this!!!", message: nil, delegate: nil, cancelButtonTitle: nil)
                alert.show()
                let delay = 5.0 * Double(NSEC_PER_SEC)
                var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                alert.dismissWithClickedButtonIndex(-1, animated: true)
                
            }
<<<<<<< HEAD
            else{
                println("Please login first before getting addicted")
            }
            
            
=======
>>>>>>> ZhuoHeng
            break
        case 1:
            break
        default:
            break
        }
    }
    
    func swipeableTableViewCell( cell : SWTableViewCell!,didTriggerRightUtilityButtonWithIndex index:NSInteger){
        
        switch(index){
        case 0:
            //Map
            break
        case 1:
            //Ticket
            println("Displaying Addictions from the local database")
            let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
            for addict in addictionInfo!{
                println("the addicted event id is \(addict.eventID)\nthe user is \(addict.userID)")
            }
            
            break
        case 2:
            //More info
            
            var cellIndexPath = self.exploreTableView.indexPathForCell(cell)
            
            var selectedCell = self.exploreTableView.cellForRowAtIndexPath(cellIndexPath!) as! EventTableViewCell
            
            GlobalVariables.eventSelected = selectedCell.circTitle.text!
            
            self.performSegueWithIdentifier("GoToMoreInfo", sender: self)
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
        
        self.exploreTableView.reloadData()
    }
    
    
}
