//
//  ExploreViewController.swift
//  Bruha
//
//  Created by lye on 15/7/27.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

class ExploreListViewController: UIViewController, SWTableViewCellDelegate,ARSPDragDelegate, ARSPVisibilityStateDelegate{
    
    @IBOutlet weak var exploreTableView: UITableView!
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var panelControllerContainer: ARSPContainerController!
    var item = ["Slide 1.jpg","Slide 2.jpg","Slide 3.jpg","Slide 4.jpg","Slide 5.jpg","Slide 6.jpg","Slide 7.jpg","Slide 8.jpg","Slide 8.jpg","Slide 8.jpg","Slide 8.jpg","Slide 8.jpg","Slide 8.jpg","Slide 8.jpg","Slide 8.jpg","Slide 8.jpg","Slide 8.jpg","Slide 8.jpg"]
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
        switch (GlobalVariables.selectedDisplay){
            case "Event":
                let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
                println(eventInfo?.count)
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
            
            var cell : EventTableViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as! EventTableViewCell!
            
            if(cell == nil){
                
                cell = NSBundle.mainBundle().loadNibNamed("Cell", owner: self, options: nil)[0] as! EventTableViewCell;
            }
            
            //let strCarName = item[indexPath.row] as String
            //cell.ExploreImage.image = UIImage(named: strCarName)
            
            let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
            let event = eventInfo![indexPath.row]
            
            println("Begin of code")
            cell.ExploreImage.contentMode = UIViewContentMode.ScaleToFill
            if let checkedUrl = NSURL(string:event.url) {
                println("Started downloading \"\(checkedUrl.lastPathComponent!.stringByDeletingPathExtension)\".")
                getDataFromUrl(checkedUrl) { data in
                    dispatch_async(dispatch_get_main_queue()) {
                        println("Finished downloading \"\(checkedUrl.lastPathComponent!.stringByDeletingPathExtension)\".")
                        cell.ExploreImage.image = UIImage(data: data!)
                    }
                }

            }
            println("End of code. The image will continue downloading in the background and it will be loaded when it ends.")
            //Synchronously:
            /*if let url = NSURL(string: event.url) {
                if let data = NSData(contentsOfURL: url){
                    cell.ExploreImage.contentMode = UIViewContentMode.ScaleToFill
                    cell.ExploreImage.image = UIImage(data: data)
                }
            }*/

            
            let circViewWidthConstraint = NSLayoutConstraint (item: cell.circView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: screenHeight)
            
            //cell.circView.addConstraint(circViewWidthConstraint)
            
            let xConstraint = NSLayoutConstraint(item: cell.circView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: cell, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            
            let yConstraint = NSLayoutConstraint(item: cell.circView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: cell, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
            
            cell.addConstraint(xConstraint)
            cell.addConstraint(yConstraint)
            
            let rectxConstraint = NSLayoutConstraint(item: cell.rectView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: cell, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            
            let rectyConstraint = NSLayoutConstraint(item: cell.rectView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: cell, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
            
            let rectWidthConstraint = NSLayoutConstraint(item: cell.rectView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: cell, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
            
            cell.addConstraint(rectxConstraint)
            cell.addConstraint(rectyConstraint)
            cell.addConstraint(rectWidthConstraint)
            
            cell.circTitle.text = event.eventName
            cell.circDate.text = event.eventStartDate
            cell.circPrice.text = "$\(event.eventPrice!)"
            
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
            temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Map")
            cell.leftUtilityButtons = temp as [AnyObject]
            
            
            var temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor.purpleColor(), title: "Buy Tickets")
            temp2.sw_addUtilityButtonWithColor(UIColor.grayColor(), title: "Preview")
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

            
            //let strCarName = item[indexPath.row] as String
            //cell.venueImage.image = UIImage(named: strCarName)
            cell.venueName.text = venue.venueName
            cell.venueDescription.text = venue.venueDescription
            cell.venueAddress.text = venue.venueAddress
            cell.circVenueName.text = venue.venueName
            
            var temp: NSMutableArray = NSMutableArray()
            temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Like")
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
            
            //let strCarName = item[indexPath.row] as String
            //cell.organizationImage.image = UIImage(named: strCarName)
            cell.organizationName.text = organization.organizationName
            cell.organizationDescription.text = organization.organizationDescription
            cell.address.text = organization.organizationAddress
            cell.circOrgName.text = organization.organizationName
            
            var temp: NSMutableArray = NSMutableArray()
            temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Like")
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
            //map
            //self.performSegueWithIdentifier("GoToMap", sender: self)
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
            //Preview
            break
        case 1:
            //Ticket
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
