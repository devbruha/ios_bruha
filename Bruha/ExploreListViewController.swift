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
    @IBOutlet weak var bruhaButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var panelControllerContainer: ARSPContainerController!
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    
    func configureView(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        exploreTableView.rowHeight = screenHeight * 0.5
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        self.panelControllerContainer.dragDelegate = self
        self.panelControllerContainer.visibilityStateDelegate = self
        self.exploreTableView!.allowsMultipleSelection = false
        //print("OOOOOOOOOOOOOOO", screenHeight, screenSize.width)
        self.view.bringSubviewToFront(bruhaButton)
        self.view.bringSubviewToFront(mapButton)
    }
    
    func customTopButtons() {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        bruhaButton.setBackgroundImage(UIImage(named: "Bruha_White"), forState: UIControlState.Normal)
        let heightContraints = NSLayoutConstraint(item: bruhaButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.height/15.5)
        heightContraints.priority = UILayoutPriorityDefaultHigh
        
        let widthContraints = NSLayoutConstraint(item: bruhaButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.width/9)
        widthContraints.priority = UILayoutPriorityDefaultHigh
        
        bruhaButton.addConstraints([heightContraints, widthContraints])
        
        
        mapButton.setBackgroundImage(UIImage(named: "MapIcon"), forState: UIControlState.Normal)
        let heightContraint = NSLayoutConstraint(item: mapButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.height/15.5)
        heightContraint.priority = UILayoutPriorityDefaultHigh
        
        let widthContraint = NSLayoutConstraint(item: mapButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.width/9)
        widthContraint.priority = UILayoutPriorityDefaultHigh
        
        mapButton.addConstraints([heightContraint, widthContraint])
    }
    
    /*func adjustCircSizeOfCell(view: UIView) {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let heightContraint = NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.height * 0.5)
        heightContraint.priority = UILayoutPriorityDefaultHigh
        
        let widthContraint = NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.height * 0.5)
        widthContraint.priority = UILayoutPriorityDefaultHigh
        
        view.addConstraints([heightContraint, widthContraint])
        
    }*/
    
    func customStatusBar() {
        let barView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        barView.backgroundColor = UIColor.grayColor()
        //barView.alpha = 0.5
        self.view.addSubview(barView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        customTopButtons()
        //customStatusBar()
            
        exploreTableView.backgroundColor = UIColor.blackColor()
        exploreTableView.separatorColor = UIColor.blackColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationEvent", name: "itemDisplayChangeEvent", object: nil)
        
        GlobalVariables.displayedEvents = FetchData(context: managedObjectContext).fetchEvents()!
        GlobalVariables.displayedVenues = FetchData(context: managedObjectContext).fetchVenues()!
        GlobalVariables.displayedArtists = FetchData(context: managedObjectContext).fetchArtists()!
        GlobalVariables.displayedOrganizations = FetchData(context: managedObjectContext).fetchOrganizations()!
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationEvent", name: "filter", object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        exploreTableView.reloadData()
//        if GlobalVariables.selectedDisplay == "Event"{
//            for cell in exploreTableView.visibleCells as! [EventTableViewCell] {
//                cell.animate()
//            }
//            
//        }
//        if GlobalVariables.selectedDisplay == "Venue"{
//            for cell in exploreTableView.visibleCells as! [VenueTableViewCell] {
//                cell.animate()
//            }
//            
//        }
//        if GlobalVariables.selectedDisplay == "Organization"{
//            for cell in exploreTableView.visibleCells as! [OrganizationTableViewCell] {
//                cell.animate()
//            }
//            
//        }
    }
    
    /*override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if GlobalVariables.selectedDisplay == "Event"{
            for cell in exploreTableView.visibleCells as! [EventTableViewCell] {
                cell.animate()
            }
            
        }
        if GlobalVariables.selectedDisplay == "Venue"{
            for cell in exploreTableView.visibleCells as! [VenueTableViewCell] {
                cell.animate()
            }
            
        }
        if GlobalVariables.selectedDisplay == "Organization"{
            for cell in exploreTableView.visibleCells as! [OrganizationTableViewCell] {
                cell.animate()
            }
            
        }
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if GlobalVariables.selectedDisplay == "Event"{
            if let animatedCell = cell as? EventTableViewCell {
                animatedCell.animate()
            }
            
        }
        if GlobalVariables.selectedDisplay == "Venue"{
            if let animatedCell = cell as? VenueTableViewCell {
                animatedCell.animate()
            }
            
        }
        if GlobalVariables.selectedDisplay == "Organization"{
            if let animatedCell = cell as? OrganizationTableViewCell {
                animatedCell.animate()
            }
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        //println("This is global variable on clicking \(GlobalVariables.selectedDisplay)")
        switch (GlobalVariables.selectedDisplay){
        case "Event":
            var eventInfo: [Event] = []
            
            if GlobalVariables.filterEventBool {
                eventInfo = GlobalVariables.displayFilteredEvents
            } else {
                eventInfo = FetchData(context: managedObjectContext).fetchEvents()
            }
            return (eventInfo.count)
            
        case "Venue":
            var venueInfo: [Venue] = []
            
            if GlobalVariables.filterVenueBool {
                venueInfo = GlobalVariables.displayFilteredVenues
            } else {
                venueInfo = FetchData(context: managedObjectContext).fetchVenues()!
            }
            return (venueInfo.count)
            
        case "Artist":
            let artistInfo = FetchData(context: managedObjectContext).fetchArtists()
            return (artistInfo?.count)!
            
        case "Organization":
            var organizationInfo: [Organization] = []
            
            if GlobalVariables.filterOrganizationBool {
                organizationInfo = GlobalVariables.displayFilteredOrganizations
            } else {
                organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()!
            }
            return (organizationInfo.count)
            
        default:
            let venueInfo = FetchData(context: managedObjectContext).fetchVenues()
            return (venueInfo?.count)!
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let posterInfo = FetchData(context: managedObjectContext).fetchPosterImages()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        switch (GlobalVariables.selectedDisplay){
            
        case "Event":
            
            var cell : EventTableViewCell! = tableView.dequeueReusableCellWithIdentifier("eventTableViewCell") as! EventTableViewCell!
            
            if(cell == nil){
                
                cell = NSBundle.mainBundle().loadNibNamed("EventTableViewCell", owner: self, options: nil)[0] as! EventTableViewCell;
            }
            
//            cell.circView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
//            cell.circView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
////            cell.circView.sizeThatFits(circSize)
//            adjustCircSizeOfCell(cell.circView)
            
//            let c = cell.convertPoint(cell.circView.center, fromView: self.view)
//            print(c.y, "mYSIDONs")
//            cell.circView.frame = CGRectMake(0, 0, screenSize.height * 0.33, screenSize.height * 0.33)

            
            let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
            let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
            var like = 0
            
            if GlobalVariables.filterEventBool {
                
                let filteredEventInfo = GlobalVariables.displayFilteredEvents
                let event = filteredEventInfo[indexPath.row]
                
                for addict in addictionInfo! {
                    if addict.eventID == event.eventID {
                        like = 1
                    }
                }
                
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
                
                cell.circTitle.text = event.eventName
                cell.circDate.text = convertCircTimeFormat("\(event.eventStartDate)")
                
                if let price = Float(event.eventPrice!) {
                    if price == 0.0 {cell.circPrice.text = "Free!"; cell.rectPrice.text = "Free!"}
                    else {cell.circPrice.text = "$\(price)"; cell.rectPrice.text = "$\(price)"}
                } else {cell.circPrice.text = "No Price"; cell.rectPrice.text = "No Price"}
                
                cell.circHiddenID.text = event.eventID
            
                cell.rectTitle.text = event.eventName
                //cell.rectPrice.text = "$\(event.eventPrice!)"
                
                if event.eventVenueName == "" {
                    cell.venueName.text = "nil"
                }else{cell.venueName.text = event.eventVenueName}
                
                cell.venueAddress.text = "\(event.eventVenueAddress.componentsSeparatedByString(", ")[0])\n\(event.eventVenueCity)"
                
                cell.startTime.text = "\(convertRectTimeFormat("\(event.eventStartDate) \(event.eventStartTime)")) -"
                cell.endTime.text = convertRectTimeFormat("\(event.eventEndDate) \(event.eventEndTime)")
                
                cell.rectCategory.contentMode = UIViewContentMode.ScaleAspectFill
                cell.rectCategory.image = UIImage(named: event.primaryCategory)
                cell.rectCategoryName.text = event.primaryCategory
                
                cell.circAddicted.contentMode = UIViewContentMode.ScaleAspectFit
                cell.circAddicted.image = UIImage(named: "MyAddictions_Sm")
                cell.circCategory.contentMode = UIViewContentMode.ScaleAspectFit
                cell.circCategory.image = UIImage(named: event.primaryCategory)
                // Configure the cell...
                
                
            } else { // when there is no filtering
                
                let event = eventInfo![indexPath.row]
                
                for addict in addictionInfo! {
                    if addict.eventID == event.eventID {
                        like = 1
                    }
                }

                
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
//                if let checkedUrl = NSURL(string:event.posterUrl) {
//                    //println("Started downloading \"\(checkedUrl.lastPathComponent!.stringByDeletingPathExtension)\".")
//                    getDataFromUrl(checkedUrl) { data in
//                        dispatch_async(dispatch_get_main_queue()) {
//                            //println("Finished downloading \"\(checkedUrl.lastPathComponent!.stringByDeletingPathExtension)\".")
//                            cell.ExploreImage.image = UIImage(data: data!)
//                        }
//                    
//                    }
//                
//                }
                //println("End of code. The image will continue downloading in the background and it will be loaded when it ends.")
                //Synchronously:
                /*if let url = NSURL(string: event.url) {
                if let data = NSData(contentsOfURL: url){
                cell.ExploreImage.contentMode = UIViewContentMode.ScaleToFill
                cell.ExploreImage.image = UIImage(data: data)
                }
                }*/
            
            
            
                cell.circTitle.text = event.eventName
                cell.circDate.text = convertCircTimeFormat("\(event.eventStartDate)")
                
                if let price = Float(event.eventPrice!) {
                    if price == 0.0 {cell.circPrice.text = "Free!"; cell.rectPrice.text = "Free!"}
                    else {cell.circPrice.text = "$\(price)"; cell.rectPrice.text = "$\(price)"}
                } else {cell.circPrice.text = "No Price"; cell.rectPrice.text = "No Price"}
                
                cell.circHiddenID.text = event.eventID
            
                cell.rectTitle.text = event.eventName
                //cell.rectPrice.text = "$\(event.eventPrice!)"
                
                if event.eventVenueName == "" {
                    cell.venueName.text = "nil"
                }else{cell.venueName.text = event.eventVenueName}
                
                cell.venueAddress.text = "\(event.eventVenueAddress.componentsSeparatedByString(", ")[0])\n\(event.eventVenueCity)"
                
                cell.startTime.text = "\(convertRectTimeFormat("\(event.eventStartDate) \(event.eventStartTime)")) -"
                cell.endTime.text = convertRectTimeFormat("\(event.eventEndDate) \(event.eventEndTime)")
                
//                let rStart = convertRectTimeFormat("\(event.eventStartDate) \(event.eventStartTime)")
//                let rEnd = convertRectTimeFormat("\(event.eventEndDate) \(event.eventEndTime)")
//                cell.startDate.text = rStart.componentsSeparatedByString(",")[0]
//                cell.startTime.text = rStart.componentsSeparatedByString(",")[1]
//                cell.endDate.text = rEnd.componentsSeparatedByString(",")[0]
//                cell.endTime.text = rEnd.componentsSeparatedByString(",")[1]
                
                cell.rectCategory.contentMode = UIViewContentMode.ScaleAspectFill
                cell.rectCategory.image = UIImage(named: event.primaryCategory)
                cell.rectCategoryName.text = event.primaryCategory
                
                cell.circAddicted.contentMode = UIViewContentMode.ScaleAspectFit
                cell.circAddicted.image = UIImage(named: "MyAddictions_Sm")
                cell.circCategory.contentMode = UIViewContentMode.ScaleAspectFit
                cell.circCategory.image = UIImage(named: event.primaryCategory)
                // Configure the cell...
            
            }
                    
            let temp: NSMutableArray = NSMutableArray()
            
            if like == 0 {
                temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),title: "Get Addicted")
                cell.circAddicted.hidden = true
            } else if like == 1 {
                temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),title: "Addicted!")
                cell.circAddicted.hidden = false
            }
            
            cell.leftUtilityButtons = temp as [AnyObject]
            
            //println(cell.leftUtilityButtons[0].titleLabel!!.text!)
            
            
            let temp2: NSMutableArray = NSMutableArray()
            //temp2.sw_addUtilityButtonWithColor(UIColor.purpleColor(), icon: UIImage(named: "Slide 5"))
            
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1), title: "Buy Tickets")
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
            
            
            let venueInfo = FetchData(context: managedObjectContext).fetchVenues()
            var like = 0
            let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsVenue()
            
            
            if GlobalVariables.filterVenueBool {
                
                let filteredVenueInfo = GlobalVariables.displayFilteredVenues
                let venue = filteredVenueInfo[indexPath.row]
                
                for addict in addictionInfo! {
                    if addict.venueID == venue.venueID {
                        like = 1
                    }
                }
                
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
                cell.venueDescription.text = venue.venueDescription
                cell.venueAddress.text = venue.venueAddress
                cell.circVenueName.text = venue.venueName
                cell.circHiddenID.text = venue.venueID
                
                cell.circCategory.contentMode = UIViewContentMode.ScaleAspectFit
                cell.circCategory.image = UIImage(named: venue.primaryCategory)
                
                
            } else { // when there is no filtering
                                    
                let venue = venueInfo![indexPath.row]
                
                for addict in addictionInfo! {
                    if addict.venueID == venue.venueID {
                        like = 1
                    }
                }
            
                cell.venueImage.contentMode = UIViewContentMode.ScaleToFill
                if let images = posterInfo {
                    for img in images {
                        if img.ID == venue.venueID {
                            // 475 bytes when no image
                            if img.Image?.length > 800 {
                                cell.venueImage.image = UIImage(data: img.Image!)
                            } else {
                                cell.venueImage.backgroundColor = UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1)
                            }
                        }
                        //if img.ID == "venue201512030620212367" {print(img.Image)}
                    }
                }
                //if venue.venueName == "zsdf" {print(venue.venueID)}
                //if venue.venueName == "Niagra" {print(venue.venueID)}
                cell.venueName.text = venue.venueName
                cell.venueDescription.text = venue.venueDescription
                cell.venueAddress.text = venue.venueAddress
                cell.circVenueName.text = venue.venueName
                cell.circHiddenID.text = venue.venueID
                
                cell.circCategory.contentMode = UIViewContentMode.ScaleAspectFit
                cell.circCategory.image = UIImage(named: venue.primaryCategory)
            }
            
            
            let temp: NSMutableArray = NSMutableArray()
            
            if like == 0 {
                temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),title: "Get Addicted")
            } else if like == 1 {
                temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),title: "Addicted!")
            }
            
            cell.leftUtilityButtons = temp as [AnyObject]
            
            
            let temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1), title: "Map")
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1), title: "More Info")
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
            
            cell.artistsImage.contentMode = UIViewContentMode.ScaleToFill
            if let checkedUrl = NSURL(string:artist.posterUrl) {
//                getDataFromUrl(checkedUrl) { data in
//                    dispatch_async(dispatch_get_main_queue()) {
//                        cell.artistsImage.image = UIImage(data: data!)
//                    }
//                }
                
            }
            
            cell.artistName.text = artist.artistName
            cell.circArtistName.text = artist.artistName
            cell.circDescription.text = artist.artistDescription
            
            let temp: NSMutableArray = NSMutableArray()
            temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Like")
            cell.leftUtilityButtons = temp as [AnyObject]
            
            let temp2: NSMutableArray = NSMutableArray()
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
            var like = 0
            let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsOrganization()
            
            
            if GlobalVariables.filterOrganizationBool {
                let filteredOrganizationInfo = GlobalVariables.displayFilteredOrganizations
                let organization = filteredOrganizationInfo[indexPath.row]
                
                for addict in addictionInfo! {
                    if addict.organizationID == organization.organizationID {
                        like = 1
                    }
                }
                
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
                cell.organizationDescription.text = organization.organizationDescription
                cell.address.text = organization.organizationAddress
                cell.circOrgName.text = organization.organizationName
                cell.circHiddenID.text = organization.organizationID
                
                cell.circCategory.contentMode = UIViewContentMode.ScaleAspectFit
                cell.circCategory.image = UIImage(named: organization.primaryCategory)
                
                
            } else { // when there is no filtering
                let organization = organizationInfo![indexPath.row]
                
                for addict in addictionInfo! {
                    if addict.organizationID == organization.organizationID {
                        like = 1
                    }
                }
            
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
                cell.organizationDescription.text = organization.organizationDescription
                cell.address.text = organization.organizationAddress
                cell.circOrgName.text = organization.organizationName
                cell.circHiddenID.text = organization.organizationID
                
                cell.circCategory.contentMode = UIViewContentMode.ScaleAspectFit
                cell.circCategory.image = UIImage(named: organization.primaryCategory)
            
            }
            
            
            let temp: NSMutableArray = NSMutableArray()
            
            if like == 0 {
                temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),title: "Get Addicted")
            } else if like == 1 {
                temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),title: "Addicted!")
            }
            
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
                            if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Addicted!"){
                                
                                let alertController = UIAlertController(title: "Are you no longer addicted?", message:nil, preferredStyle: .Alert)
                                let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                                let unlikeAction = UIAlertAction(title: "I'm Over It", style: .Default) { (_) -> Void in
                                    //print("my idddd \(event.subCategoryID)")
                                    DeleteData(context: self.managedObjectContext).deleteAddictionsEvent(event.eventID, deleteUser: user)
                                    print("Removed from addiction(event) \(event.eventID)")
                                    print("REMOVED")
                                    
                                    let eventService = EventService()
                                    eventService.removeAddictedEvents(event.eventID) {
                                        (let removeInfo ) in
                                        print(removeInfo!)
                                    }
                                    
                                    var temp: NSMutableArray = NSMutableArray()
                                    temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),title: "Get Addicted")
                                    cell.leftUtilityButtons = temp as [AnyObject]
                                    
                                    selectedCell.circAddicted.hidden = true
                                }
                                alertController.addAction(unlikeAction)
                                alertController.addAction(cancelAction)
                                
                                self.presentViewController(alertController, animated: true, completion: nil)
                                
                                
                            } else if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Get Addicted") {
                                
                                let addEvent = AddictionEvent(eventId: event.eventID, userId: user)
                                SaveData(context: managedObjectContext).saveAddictionEvent(addEvent)
                                print("Getting Addicted with event id \(event.eventID)")
                                print("ADDICTED")
                                
                                let eventService = EventService()
                                
                                eventService.addAddictedEvents(event.eventID) {
                                    (let addInfo ) in
                                    print(addInfo!)
                                }
                                
                                var temp: NSMutableArray = NSMutableArray()
                                temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),title: "Addicted!")
                                cell.leftUtilityButtons = temp as [AnyObject]
                                
                                selectedCell.circAddicted.hidden = false
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
                            if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Addicted!"){
                                
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
                                    
                                    var temp: NSMutableArray = NSMutableArray()
                                    temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),title: "Get Addicted")
                                    cell.leftUtilityButtons = temp as [AnyObject]
                                    
                                }
                                alertController.addAction(unlikeAction)
                                alertController.addAction(cancelAction)
                                
                                self.presentViewController(alertController, animated: true, completion: nil)
                                
                                
                            } else if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Get Addicted") {
                                
                                let addVenue = AddictionVenue(venueId: venue.venueID, userId: user)
                                SaveData(context: managedObjectContext).saveAddictionVenue(addVenue)
                                print("Getting Addicted with venue id \(venue.venueID)")
                                print("ADDICTED")
                                
                                let venueService = VenueService()
                                
                                venueService.addAddictedVenues(venue.venueID) {
                                    (let addInfo ) in
                                    print(addInfo!)
                                }
                                
                                var temp: NSMutableArray = NSMutableArray()
                                temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),title: "Addicted!")
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
                    let cellIndexPath = self.exploreTableView.indexPathForCell(cell)
                    let selectedCell = self.exploreTableView.cellForRowAtIndexPath(cellIndexPath!) as! OrganizationTableViewCell
                    GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                    
                    let organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()
                    for organization in organizationInfo!{
                        if organization.organizationID == GlobalVariables.eventSelected {
                            //Like and Unlike
                            if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Addicted!"){
                                
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
                                    
                                    let temp: NSMutableArray = NSMutableArray()
                                    temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),title: "Get Addicted")
                                    cell.leftUtilityButtons = temp as [AnyObject]
                                    
                                }
                                alertController.addAction(unlikeAction)
                                alertController.addAction(cancelAction)
                                
                                self.presentViewController(alertController, animated: true, completion: nil)
                                
                                
                            } else if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Get Addicted") {
                                
                                let addOrgainzation = AddictionOrganization(organizationId: organization.organizationID, userId: user)
                                SaveData(context: managedObjectContext).saveAddictionOrganization(addOrgainzation)
                                print("Getting Addicted with event id \(organization.organizationID)")
                                print("ADDICTED")
                                
                                let organizationService = OrganizationService()
                                
                                organizationService.addAddictedOrganizations(organization.organizationID) {
                                    (let addInfo ) in
                                    print(addInfo!)
                                }
                                
                                let temp: NSMutableArray = NSMutableArray()
                                temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),title: "Addicted!")
                                cell.leftUtilityButtons = temp as [AnyObject]
                            }
                        }
                    }
                }
                
            } else {
                
                let alert = UIAlertView(title: "Please log in for this!!!", message: nil, delegate: nil, cancelButtonTitle: nil)
                alert.show()
                let delay = 1.0 * Double(NSEC_PER_SEC)
                var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    alert.dismissWithClickedButtonIndex(-1, animated: true)
                })
                
            }
            break
        case 1:
            break
        default:
            break
        }
    }
    
    func alert() {
        let alertController = UIAlertController(title: "Are you sure you wanna unlike it!", message:nil, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        let unlikeAction = UIAlertAction(title: "Yes", style: .Default) { (_) -> Void in
            
        }
        
        alertController.addAction(unlikeAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    func swipeableTableViewCell( cell : SWTableViewCell!,didTriggerRightUtilityButtonWithIndex index:NSInteger){
        
        switch(index){
        case 0:
            if GlobalVariables.selectedDisplay == "Event" {
                //event ticket
                print("event ticket")
            }
                //venue and organization map
            else if GlobalVariables.selectedDisplay == "Venue" {
                let cellIndexPath = self.exploreTableView.indexPathForCell(cell)
                let selectedCell = self.exploreTableView.cellForRowAtIndexPath(cellIndexPath!) as! VenueTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                self.performSegueWithIdentifier("ShowOnMap", sender: self)
            }
            else if GlobalVariables.selectedDisplay == "Organization" {
                let cellIndexPath = self.exploreTableView.indexPathForCell(cell)
                let selectedCell = self.exploreTableView.cellForRowAtIndexPath(cellIndexPath!) as! OrganizationTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                self.performSegueWithIdentifier("ShowOnMap", sender: self)
            }
            
            
            
//            print("event filter applied", GlobalVariables.filterEventBool)
//            print("afterFilterEvent", GlobalVariables.displayFilteredEvents.count)
//            for e in GlobalVariables.displayFilteredEvents{
//                print("they are", e.eventName)
//            }
//            
//            
//            print("venue filter applied", GlobalVariables.filterVenueBool)
//            print("afterFilterVenue", GlobalVariables.displayFilteredVenues.count)
//            for v in GlobalVariables.displayFilteredVenues{
//                print("they are", v.venueName)
//            }
//            
//            print("organization filter applied", GlobalVariables.filterOrganizationBool)
//            print("afterFilterOrganization", GlobalVariables.displayFilteredOrganizations.count)
//            for o in GlobalVariables.displayFilteredOrganizations{
//                print("they are", o.organizationName)
//            }
            
            
            break
        case 1:
            //Event Ticket
            if GlobalVariables.selectedDisplay == "Event"{

                let cellIndexPath = self.exploreTableView.indexPathForCell(cell)
                let selectedCell = self.exploreTableView.cellForRowAtIndexPath(cellIndexPath!) as! EventTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                self.performSegueWithIdentifier("ShowOnMap", sender: self)
                
            }
            
            //Venue MoreInfo
            if (GlobalVariables.selectedDisplay == "Venue"){
                let cellIndexPath = self.exploreTableView.indexPathForCell(cell)
                
                let selectedCell = self.exploreTableView.cellForRowAtIndexPath(cellIndexPath!) as! VenueTableViewCell
                
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                self.performSegueWithIdentifier("GoToMoreInfo", sender: self)
            }
            //Organization MoreInfo
            if (GlobalVariables.selectedDisplay == "Organization"){
                let cellIndexPath = self.exploreTableView.indexPathForCell(cell)
                
                let selectedCell = self.exploreTableView.cellForRowAtIndexPath(cellIndexPath!) as! OrganizationTableViewCell
                
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                self.performSegueWithIdentifier("GoToMoreInfo", sender: self)

            }
            else if GlobalVariables.selectedDisplay == "Venue" || GlobalVariables.selectedDisplay == "Organization" {
                //venue and organizaiton more info
                print("venue and org more info")
            }
            
            
            
//            print("Displaying Addictions from the local database")
//            let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
//            for addict in addictionInfo!{
//                print("the addicted event id is \(addict.eventID)\nthe user is \(addict.userID)")
//            }
            
            break
        case 2:

            //Event More info
            print("event more info")
            
            let cellIndexPath = self.exploreTableView.indexPathForCell(cell)
            
            let selectedCell = self.exploreTableView.cellForRowAtIndexPath(cellIndexPath!) as! EventTableViewCell
            
            GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
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
        
        let indexPath = tableView.indexPathForSelectedRow;
        
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
    
    func updateNotificationEvent(){
        
        self.exploreTableView.reloadData()
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
    
}