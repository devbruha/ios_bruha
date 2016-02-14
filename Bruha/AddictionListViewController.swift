//
//  AddictionListViewController.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-10-02.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import UIKit
import CoreData

class AddictionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, SWTableViewCellDelegate, ARSPDragDelegate, ARSPVisibilityStateDelegate{

    @IBOutlet weak var addictionTableView: UITableView!
    @IBOutlet weak var bruhaButton: UIButton!
    @IBOutlet weak var addictionWidthLabel: NSLayoutConstraint!
    
    @IBOutlet weak var addictionHeightLabel: NSLayoutConstraint!
    @IBOutlet weak var addictionHeightImage: NSLayoutConstraint!
    @IBOutlet weak var addictionWidthImage: NSLayoutConstraint!
    
    @IBOutlet weak var addictionImage: UIImageView!
    @IBOutlet weak var addictionLabel: UILabel!
    
    
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    var panelControllerContainer: ARSPContainerController!
    
    var eventInfo: [Event]!
    var addictedEventInfo: [AddictionEvent]?
    var displayEventInfo: [Event] = []
    var venueInfo: [Venue]?
    var addictedVenueInfo: [AddictionVenue]?
    var displayVenueInfo: [Venue] = []
    var organizationInfo: [Organization]?
    var addictedOrganizationInfo: [AddictionOrganization]?
    var displayOrganizationInfo: [Organization] = []
    
    var searchController: UISearchController!
    var searchedEvents = [Event]()
    var searchedVenues = [Venue]()
    var searchedOrganizations = [Organization]()
    
    
    func configureView(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        addictionTableView.rowHeight = ( screenHeight - screenHeight * 70 / 568 ) * 0.5
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
        
        
        adjustLabelConstraint(addictionWidthLabel)
        adjustImageConstraint(addictionHeightLabel)
        adjustImageConstraint(addictionHeightImage)
        adjustImageConstraint(addictionWidthImage)
        
        addictionLabel.adjustsFontSizeToFitWidth = true
    }
    
    func adjustLabelConstraint(constraint: NSLayoutConstraint) {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        constraint.constant = screenSize.height * 0.3
    }
    func adjustImageConstraint(constraint: NSLayoutConstraint) {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        constraint.constant = screenSize.height/15.5
    }
    
    func animateHeader() {
        UIView.animateWithDuration(1.5, delay: 0.0, options: [.TransitionFlipFromLeft], animations: { () -> Void in
            self.addictionLabel.alpha = 1
            self.addictionImage.alpha = 1
            }) {(finished) -> Void in
                
        }
    }
    
    func customStatusBar() {
        let barView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        barView.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
        self.view.addSubview(barView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchInformation()
        
        configureView()
        //customTopButtons()
        customStatusBar()
        
        //addictionTableView.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
        addictionTableView.separatorColor = UIColor.clearColor()
        
        self.addictionLabel.alpha = 0.0
        self.addictionImage.alpha = 0.0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationAddiction", name: "itemDisplayChangeAddiction", object: nil)
        
        backgroundGradient()
        // Do any additional setup after loading the view.
        
        
        setUpSearchBar()
        
        
    }
    
    func setUpSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Events"
        
        searchController.searchBar.barTintColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
        searchController.searchBar.tintColor = UIColor.whiteColor()
        
        searchController.searchBar.scopeButtonTitles = ["Search", "Location"]
        
        searchController.searchBar.sizeToFit()
        
        addictionTableView.tableHeaderView = searchController.searchBar
        
//        let searchView = UIView.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, searchController.searchBar.bounds.size.height))
//        
//        searchView.addSubview(searchController.searchBar)
//        
//        self.view.addSubview(searchView)
        
        //self.navigationItem.titleView = searchController.searchBar
        
    }
    
    
    func backgroundGradient() {
        let background = CAGradientLayer().gradientColor()
        background.frame = self.view.bounds
        self.addictionTableView.layer.insertSublayer(background, atIndex: 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animateHeader()
        
        addictionTableView.reloadData()
        
//        if GlobalVariables.addictedDisplay == "Event"{
//            for cell in addictionTableView.visibleCells as! [EventTableViewCell] {
//                cell.animate()
//            }
//            
//        }
//        if GlobalVariables.addictedDisplay == "Venue"{
//            for cell in addictionTableView.visibleCells as! [VenueTableViewCell] {
//                cell.animate()
//            }
//            
//        }
//        if GlobalVariables.addictedDisplay == "Organization"{
//            for cell in addictionTableView.visibleCells as! [OrganizationTableViewCell] {
//                cell.animate()
//            }
//            
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func filterForSearchText(searchText: String, scope: String = "Search") {
        
        if GlobalVariables.addictedDisplay == "Event" {
            searchedEvents = displayEventInfo.filter({ (event: Event) -> Bool in
                //print(event.eventVenueAddress.componentsSeparatedByString(", ")[0] + " " + event.eventVenueCity)
                return ( scope == "Search" && event.eventName.lowercaseString.containsString(searchText.lowercaseString) ) ||
                    ( scope == "Location" && (event.eventVenueAddress.componentsSeparatedByString(", ")[0] + " " + event.eventVenueCity).lowercaseString.containsString(searchText.lowercaseString) )
            })
        }
        if GlobalVariables.addictedDisplay == "Venue" {
            searchedVenues = displayVenueInfo.filter({ (venue: Venue) -> Bool in
                return ( scope == "Search" && venue.venueName.lowercaseString.containsString(searchText.lowercaseString) ) ||
                    ( scope == "Location" && (venue.venueAddress.componentsSeparatedByString(", ")[0]).lowercaseString.containsString(searchText.lowercaseString) )
            })
        }
        if GlobalVariables.addictedDisplay == "Organization" {
            searchedOrganizations = displayOrganizationInfo.filter({ (organization: Organization) -> Bool in
                return ( scope == "Search" && organization.organizationName.lowercaseString.containsString(searchText.lowercaseString) ) ||
                    ( scope == "Location" && (organization.organizationAddress.componentsSeparatedByString(", ")[0]).lowercaseString.containsString(searchText.lowercaseString) )
            })
        }

        addictionTableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterForSearchText(searchController.searchBar.text!, scope: scope)

        //print(searchedEvents.count, "searchEvents")
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
            if searchController.active && searchController.searchBar.text != "" {
                return searchedEvents.count
            }else {
                return (displayEventInfo.count)
            }
            
        case "Venue":
            if searchController.active && searchController.searchBar.text != "" {
                return searchedVenues.count
            } else {
                return (displayVenueInfo.count)
            }
            
        case "Artist":
            let artistInfo = FetchData(context: managedObjectContext).fetchArtists()
            return (artistInfo?.count)!
        case "Organization":
            if searchController.active && searchController.searchBar.text != "" {
                return searchedOrganizations.count
            } else {
                return (displayOrganizationInfo.count)
            }
            
        default:
            return (displayVenueInfo.count)
        }
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if GlobalVariables.addictedDisplay == "Event"{
            if let animatedCell = cell as? EventTableViewCell {
                animatedCell.animate()
            }
            
        }
        if GlobalVariables.addictedDisplay == "Venue"{
            if let animatedCell = cell as? VenueTableViewCell {
                animatedCell.animate()
            }
            
        }
        if GlobalVariables.addictedDisplay == "Organization"{
            if let animatedCell = cell as? OrganizationTableViewCell {
                animatedCell.animate()
            }
            
        }
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let posterInfo = FetchData(context: managedObjectContext).fetchPosterImages()
        if GlobalVariables.eventImageCache.count >= 50 { GlobalVariables.eventImageCache.removeAtIndex(0) }
        if GlobalVariables.venueImageCache.count >= 50 { GlobalVariables.venueImageCache.removeAtIndex(0) }
        if GlobalVariables.organizationImageCache.count >= 50 { GlobalVariables.organizationImageCache.removeAtIndex(0) }
        
        switch (GlobalVariables.addictedDisplay){
        case "Event":
            var cell : EventTableViewCell! = tableView.dequeueReusableCellWithIdentifier("eventTableViewCell") as! EventTableViewCell!
            
            if(cell == nil){
                
                cell = NSBundle.mainBundle().loadNibNamed("EventTableViewCell", owner: self, options: nil)[0] as! EventTableViewCell;
            }

            
            
            // addicted events in view did load, then do this
            if searchController.active && searchController.searchBar.text != "" {
                
                let event = searchedEvents[indexPath.row]
                
                cell.ExploreImage.contentMode = UIViewContentMode.ScaleToFill
                
                if let img = GlobalVariables.eventImageCache[event.eventID] {
                    cell.ExploreImage.image = img
                }
                else if let checkedUrl = NSURL(string:event.posterUrl) {
                    
                    self.getDataFromUrl(checkedUrl) { data in
                        dispatch_async(dispatch_get_main_queue()) {
                            if let downloadImg = data {
                                if downloadImg.length > 800 {
                                    
                                    let image = UIImage(data: downloadImg)
                                    GlobalVariables.eventImageCache[event.eventID] = image
                                    
                                    cell.ExploreImage.image = image
                                    
                                } else {
                                    cell.ExploreImage.image = self.randomImage()
                                }
                            }
                            else {
                                cell.ExploreImage.image = self.randomImage()
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
                
                //cell.startDate.text = event.eventStartDate
                //cell.startTime.text = "\(event.eventStartTime) -"
                //cell.endDate.text = event.eventEndDate
                //cell.endTime.text = event.eventEndTime
                
                cell.circAddicted.contentMode = UIViewContentMode.ScaleAspectFit
                cell.circAddicted.image = UIImage(named: "MyAddictions_Sm")
                cell.circCategory.contentMode = UIViewContentMode.ScaleAspectFit
                cell.circCategory.image = UIImage(named: event.primaryCategory)
                
                cell.rectCategory.contentMode = UIViewContentMode.ScaleAspectFill
                cell.rectCategory.image = UIImage(named: event.primaryCategory)
                cell.rectCategoryName.text = event.primaryCategory
                // Configure the cell...
                
            }
            else { // when there is no search
                
                let event = displayEventInfo[indexPath.row]
                
                cell.ExploreImage.contentMode = UIViewContentMode.ScaleToFill
                
                if let img = GlobalVariables.eventImageCache[event.eventID] {
                    cell.ExploreImage.image = img
                }
                else if let checkedUrl = NSURL(string:event.posterUrl) {
                    
                    self.getDataFromUrl(checkedUrl) { data in
                        dispatch_async(dispatch_get_main_queue()) {
                            if let downloadImg = data {
                                if downloadImg.length > 800 {
                                    
                                    let image = UIImage(data: downloadImg)
                                    GlobalVariables.eventImageCache[event.eventID] = image
                                    
                                    cell.ExploreImage.image = image
                                    
                                } else {
                                    cell.ExploreImage.image = self.randomImage()
                                }
                            }
                            else {
                                cell.ExploreImage.image = self.randomImage()
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
                
                //cell.startDate.text = event.eventStartDate
                //cell.startTime.text = "\(event.eventStartTime) -"
                //cell.endDate.text = event.eventEndDate
                //cell.endTime.text = event.eventEndTime
                
                cell.circAddicted.contentMode = UIViewContentMode.ScaleAspectFit
                cell.circAddicted.image = UIImage(named: "MyAddictions_Sm")
                cell.circCategory.contentMode = UIViewContentMode.ScaleAspectFit
                cell.circCategory.image = UIImage(named: event.primaryCategory)
                
                cell.rectCategory.contentMode = UIViewContentMode.ScaleAspectFill
                cell.rectCategory.image = UIImage(named: event.primaryCategory)
                cell.rectCategoryName.text = event.primaryCategory
                // Configure the cell...
                
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
            temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),attributedTitle: swipeCellTitle("Addicted!"))
            cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
            cell.leftUtilityButtons = temp as [AnyObject]
            
            
            let temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1), attributedTitle: swipeCellTitle("Buy\nTickets"))
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1), attributedTitle: swipeCellTitle("Map"))
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1), attributedTitle: swipeCellTitle("More\nInfo"))
            cell.rightUtilityButtons = nil
            cell.setRightUtilityButtons(temp2 as [AnyObject], withButtonWidth: 75)
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
            
            if searchController.active && searchController.searchBar.text != "" {
                
                let venue = searchedVenues[indexPath.row]
                
                cell.venueImage.contentMode = UIViewContentMode.ScaleToFill
                if let img = GlobalVariables.venueImageCache[venue.venueID] {
                    cell.venueImage.image = img
                }
                else if let checkedUrl = NSURL(string:venue.posterUrl) {
                    
                    self.getDataFromUrl(checkedUrl) { data in
                        dispatch_async(dispatch_get_main_queue()) {
                            if let downloadImg = data {
                                if downloadImg.length > 800 {
                                    
                                    let image = UIImage(data: downloadImg)
                                    GlobalVariables.venueImageCache[venue.venueID] = image
                                    cell.venueImage.image = image
                                    
                                } else {
                                    cell.venueImage.image = self.randomImage()
                                }
                            }
                            else {
                                cell.venueImage.image = self.randomImage()
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
                cell.circAddicted.image = UIImage(named: "MyAddictions_Sm")
                cell.circCategory.contentMode = UIViewContentMode.ScaleAspectFit
                cell.circCategory.image = UIImage(named: venue.primaryCategory)
                
                cell.rectCategory.contentMode = UIViewContentMode.ScaleAspectFill
                cell.rectCategory.image = UIImage(named: venue.primaryCategory)
                cell.rectCategoryName.text = venue.primaryCategory
            }
                
            else { // when there is no search
                let venue = displayVenueInfo[indexPath.row]
                
                cell.venueImage.contentMode = UIViewContentMode.ScaleToFill
                if let img = GlobalVariables.venueImageCache[venue.venueID] {
                    cell.venueImage.image = img
                }
                else if let checkedUrl = NSURL(string:venue.posterUrl) {
                    
                    self.getDataFromUrl(checkedUrl) { data in
                        dispatch_async(dispatch_get_main_queue()) {
                            if let downloadImg = data {
                                if downloadImg.length > 800 {
                                    
                                    let image = UIImage(data: downloadImg)
                                    GlobalVariables.venueImageCache[venue.venueID] = image
                                    cell.venueImage.image = image
                                    
                                } else {
                                    cell.venueImage.image = self.randomImage()
                                }
                            }
                            else {
                                cell.venueImage.image = self.randomImage()
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
                cell.circAddicted.image = UIImage(named: "MyAddictions_Sm")
                cell.circCategory.contentMode = UIViewContentMode.ScaleAspectFit
                cell.circCategory.image = UIImage(named: venue.primaryCategory)
                
                cell.rectCategory.contentMode = UIViewContentMode.ScaleAspectFill
                cell.rectCategory.image = UIImage(named: venue.primaryCategory)
                cell.rectCategoryName.text = venue.primaryCategory
            }
            
            
            //let strCarName = item[indexPath.row] as String
            //cell.venueImage.image = UIImage(named: strCarName)
            
            
            let temp: NSMutableArray = NSMutableArray()
            temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),attributedTitle: swipeCellTitle("Addicted!"))
            cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
            cell.leftUtilityButtons = temp as [AnyObject]
            
            
            let temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1), attributedTitle: swipeCellTitle("Map"))
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1), attributedTitle: swipeCellTitle("More\nInfo"))
            cell.rightUtilityButtons = nil
            cell.setRightUtilityButtons(temp2 as [AnyObject], withButtonWidth: 75)
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
            
            if searchController.active && searchController.searchBar.text != "" {
                
                let organization = searchedOrganizations[indexPath.row]
                
                cell.organizationImage.contentMode = UIViewContentMode.ScaleToFill
                if let img = GlobalVariables.organizationImageCache[organization.organizationID] {
                    cell.organizationImage.image = img
                }
                else if let checkedUrl = NSURL(string:organization.posterUrl) {
                    
                    self.getDataFromUrl(checkedUrl) { data in
                        dispatch_async(dispatch_get_main_queue()) {
                            if let downloadImg = data {
                                if downloadImg.length > 800 {
                                    
                                    let image = UIImage(data: downloadImg)
                                    GlobalVariables.venueImageCache[organization.organizationID] = image
                                    cell.organizationImage.image = image
                                } else {
                                    cell.organizationImage.image = self.randomImage()
                                }
                            }
                            else {
                                cell.organizationImage.image = self.randomImage()
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
                cell.circAddicted.image = UIImage(named: "MyAddictions_Sm")
                cell.circCategory.contentMode = UIViewContentMode.ScaleAspectFit
                cell.circCategory.image = UIImage(named: organization.primaryCategory)
                
                cell.rectCategory.contentMode = UIViewContentMode.ScaleAspectFill
                cell.rectCategory.image = UIImage(named: organization.primaryCategory)
                cell.rectCategoryName.text = organization.primaryCategory
            }
            
            else { // when there is no search
                let organization = displayOrganizationInfo[indexPath.row]
                
                cell.organizationImage.contentMode = UIViewContentMode.ScaleToFill
                if let img = GlobalVariables.organizationImageCache[organization.organizationID] {
                    cell.organizationImage.image = img
                }
                else if let checkedUrl = NSURL(string:organization.posterUrl) {
                    
                    self.getDataFromUrl(checkedUrl) { data in
                        dispatch_async(dispatch_get_main_queue()) {
                            if let downloadImg = data {
                                if downloadImg.length > 800 {
                                    
                                    let image = UIImage(data: downloadImg)
                                    GlobalVariables.venueImageCache[organization.organizationID] = image
                                    cell.organizationImage.image = image
                                } else {
                                    cell.organizationImage.image = self.randomImage()
                                }
                            }
                            else {
                                cell.organizationImage.image = self.randomImage()
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
                cell.circAddicted.image = UIImage(named: "MyAddictions_Sm")
                cell.circCategory.contentMode = UIViewContentMode.ScaleAspectFit
                cell.circCategory.image = UIImage(named: organization.primaryCategory)
                
                cell.rectCategory.contentMode = UIViewContentMode.ScaleAspectFill
                cell.rectCategory.image = UIImage(named: organization.primaryCategory)
                cell.rectCategoryName.text = organization.primaryCategory
            }
            
            
            
            let temp: NSMutableArray = NSMutableArray()
            temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),attributedTitle: swipeCellTitle("Addicted!"))
            cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
            cell.leftUtilityButtons = temp as [AnyObject]
            
            
            let temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1), attributedTitle: swipeCellTitle("Map"))
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1), attributedTitle: swipeCellTitle("More\nInfo"))
            cell.rightUtilityButtons = nil
            cell.setRightUtilityButtons(temp2 as [AnyObject], withButtonWidth: 75)
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
                            
                            self.updateAddictFetch()
                            
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
                            if self.searchController.active && self.searchController.searchBar.text != "" {
                                self.searchController.searchResultsUpdater?.updateSearchResultsForSearchController(self.searchController)
                            } else { self.addictionTableView.reloadData() }
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
                            
                            self.updateAddictFetch()
                            
                            let venueService = VenueService()
                            venueService.removeAddictedVenues(addicted.venueID) {
                                (let addInfo ) in
                                print(addInfo!)
                            }
                            
                            if self.searchController.active && self.searchController.searchBar.text != "" {
                                self.searchController.searchResultsUpdater?.updateSearchResultsForSearchController(self.searchController)
                            } else { self.addictionTableView.reloadData() }
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
                            
                            self.updateAddictFetch()
                            
                            let organizationService = OrganizationService()
                            
                            organizationService.removeAddictedOrganizations(addicted.organizationID) {
                                (let removeInfo ) in
                                print(removeInfo!)
                            }
                            
                            if self.searchController.active && self.searchController.searchBar.text != "" {
                                self.searchController.searchResultsUpdater?.updateSearchResultsForSearchController(self.searchController)
                            } else { self.addictionTableView.reloadData() }
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
                //venue and organization map
            else if GlobalVariables.addictedDisplay == "Venue" {
                let cellIndexPath = self.addictionTableView.indexPathForCell(cell)
                let selectedCell = self.addictionTableView.cellForRowAtIndexPath(cellIndexPath!) as! VenueTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                self.performSegueWithIdentifier("ShowOnMap", sender: self)
            }
            else if GlobalVariables.addictedDisplay == "Organization" {
                let cellIndexPath = self.addictionTableView.indexPathForCell(cell)
                let selectedCell = self.addictionTableView.cellForRowAtIndexPath(cellIndexPath!) as! OrganizationTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                self.performSegueWithIdentifier("ShowOnMap", sender: self)
            }
           
        case 1:
            //Event Ticket
            if GlobalVariables.addictedDisplay == "Event"{
                
                let cellIndexPath = self.addictionTableView.indexPathForCell(cell)
                let selectedCell = self.addictionTableView.cellForRowAtIndexPath(cellIndexPath!) as! EventTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                self.performSegueWithIdentifier("ShowOnMap", sender: self)
                
            }
            
            //Venue MoreInfo
            if (GlobalVariables.addictedDisplay == "Venue"){
                let cellIndexPath = self.addictionTableView.indexPathForCell(cell)
                
                let selectedCell = self.addictionTableView.cellForRowAtIndexPath(cellIndexPath!) as! VenueTableViewCell
                
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                self.performSegueWithIdentifier("MoreInfore", sender: self)
            }
            //Organization MoreInfo
            if (GlobalVariables.addictedDisplay == "Organization"){
                let cellIndexPath = self.addictionTableView.indexPathForCell(cell)
                
                let selectedCell = self.addictionTableView.cellForRowAtIndexPath(cellIndexPath!) as! OrganizationTableViewCell
                
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                self.performSegueWithIdentifier("MoreInfore", sender: self)
                
            }
            
        case 2:
            
            //Event More info
            print("event more info")
            
            let cellIndexPath = self.addictionTableView.indexPathForCell(cell)
            
            let selectedCell = self.addictionTableView.cellForRowAtIndexPath(cellIndexPath!) as! EventTableViewCell
            
            GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
            self.performSegueWithIdentifier("EventMoreInfo", sender: self)
            break
        default:
            break
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "MoreInfore" {
            let destinationController = segue.destinationViewController as! MoreInformationViewController
            if GlobalVariables.addictedDisplay == "Venue" {
                destinationController.sourceForComingEvent = "venue"
                destinationController.sourceID = GlobalVariables.eventSelected
            }
            if GlobalVariables.addictedDisplay == "Organization" {
                destinationController.sourceForComingEvent = "organization"
                destinationController.sourceID = GlobalVariables.eventSelected
            }
        }
        
        if segue.identifier == "ShowOnMap" {
            let destinationController = segue.destinationViewController as! ShowOnMapViewController
            if GlobalVariables.addictedDisplay == "Event" {
                destinationController.sourceForMarker = "event"
                destinationController.sourceID = GlobalVariables.eventSelected
            }
            if GlobalVariables.addictedDisplay == "Venue" {
                destinationController.sourceForMarker = "venue"
                destinationController.sourceID = GlobalVariables.eventSelected
            }
            if GlobalVariables.addictedDisplay == "Organization" {
                destinationController.sourceForMarker = "organization"
                destinationController.sourceID = GlobalVariables.eventSelected
            }
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
        
        if GlobalVariables.addictedDisplay == "Event"{
            searchController.searchBar.placeholder = "Search Events"
        }
        if GlobalVariables.addictedDisplay == "Venue"{
            searchController.searchBar.placeholder = "Search Venues"
        }
        if GlobalVariables.addictedDisplay == "Organization"{
            searchController.searchBar.placeholder = "Search Organizatons"
        }
        
        if self.searchController.active && self.searchController.searchBar.text != "" {
            self.searchController.searchResultsUpdater?.updateSearchResultsForSearchController(self.searchController)
        }
        
        self.addictionTableView.reloadData()
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
    
    func randomImage() -> UIImage {
        let imgNo = Int(arc4random_uniform(6) + 1)
        
        switch(imgNo){
            
        case 1:
            return UIImage(named: "Background1")!
            
        case 2:
            return UIImage(named: "Background2")!
            
        case 3:
            return UIImage(named: "Background3")!
            
        case 4:
            return UIImage(named: "Background4")!
            
        case 5:
            return UIImage(named: "Background5")!
            
        case 6:
            return UIImage(named: "Background6")!
            
        default:
            return UIImage(named: "Background1")!
        }
        
    }
    
    func swipeCellTitle(title: String) -> NSAttributedString {
        
        let mAttribute = [NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        let aString = NSMutableAttributedString(string: title, attributes: mAttribute)
        
        return aString
    }
    
    func fetchInformation() {
        eventInfo = FetchData(context: managedObjectContext).fetchEvents()
        addictedEventInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
        venueInfo = FetchData(context: managedObjectContext).fetchVenues()
        addictedVenueInfo = FetchData(context: managedObjectContext).fetchAddictionsVenue()
        organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()
        addictedOrganizationInfo = FetchData(context: managedObjectContext).fetchAddictionsOrganization()
        
        //let start1 = NSDate()
        
        for event in eventInfo {
            for addict in addictedEventInfo! {
                if event.eventID == addict.eventID {
                    displayEventInfo.append(event)
                }
            }
        }
        
        
//        let end1 = NSDate()
//        let timeInterval1: Double = end1.timeIntervalSinceDate(start1)
//        print("time 1 running is \(timeInterval1)")
        
        
//        let start2 = NSDate()
//        
//        for addict in addictedEventInfo! {
//            if eventInfo.contains({$0.eventID == addict.eventID}) {
//                let idx = eventInfo.indexOf({$0.eventID == addict.eventID})!
//                displayEventInfo?.append(eventInfo[idx])
//            }
//        }
//        let end2 = NSDate()
//        let timeInterval2: Double = end2.timeIntervalSinceDate(start2)
//        print("time 2 running is \(timeInterval2)")
        
        
        for venue in venueInfo! {
            for addict in addictedVenueInfo! {
                if venue.venueID == addict.venueID {
                    displayVenueInfo.append(venue)
                }
            }
        }
        
        for org in organizationInfo! {
            for addict in addictedOrganizationInfo! {
                if org.organizationID == addict.organizationID {
                    displayOrganizationInfo.append(org)
                }
            }
        }
        
        
    }
    
    func updateAddictFetch() {
        
        if GlobalVariables.addictedDisplay == "Event"{
            
            addictedEventInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
            
            displayEventInfo.removeAll()
            for event in eventInfo {
                for addict in addictedEventInfo! {
                    if event.eventID == addict.eventID {
                        displayEventInfo.append(event)
                    }
                }
            }
        }
        if GlobalVariables.addictedDisplay == "Venue"{
            
            addictedVenueInfo = FetchData(context: managedObjectContext).fetchAddictionsVenue()
            
            displayVenueInfo.removeAll()
            for venue in venueInfo! {
                for addict in addictedVenueInfo! {
                    if venue.venueID == addict.venueID {
                        displayVenueInfo.append(venue)
                    }
                }
            }
        }
        if GlobalVariables.addictedDisplay == "Organization"{
            
            addictedOrganizationInfo = FetchData(context: managedObjectContext).fetchAddictionsOrganization()
            
            displayOrganizationInfo.removeAll()
            for org in organizationInfo! {
                for addict in addictedOrganizationInfo! {
                    if org.organizationID == addict.organizationID {
                        displayOrganizationInfo.append(org)
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
