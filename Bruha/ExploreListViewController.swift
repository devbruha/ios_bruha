//
//  ExploreViewController.swift
//  Bruha
//
//  Created by lye on 15/7/27.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit
import CoreData

class ExploreListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, SWTableViewCellDelegate,ARSPDragDelegate, ARSPVisibilityStateDelegate {
    
    @IBOutlet weak var exploreTableView: UITableView!
    @IBOutlet weak var bruhaButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    @IBOutlet weak var exploreLabel: UILabel!
    @IBOutlet weak var exploreHeightLabel: NSLayoutConstraint!
    
    @IBOutlet weak var exploreWidthLabel: NSLayoutConstraint!
    
    @IBOutlet weak var exploreImage: UIImageView!
    @IBOutlet weak var exploreWidthImage: NSLayoutConstraint!
    
    @IBOutlet weak var exploreHeightImage: NSLayoutConstraint!
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    @IBOutlet weak var emptyStateImage: UIImageView!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var panelControllerContainer: ARSPContainerController!
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    
    //var posterInfo: [Image]?
    var eventInfo: [Event]!
    var addictionEventInfo: [AddictionEvent]?
    var venueInfo: [Venue]?
    var addictionVenueInfo: [AddictionVenue]?
    var organizationInfo: [Organization]?
    var addictionOrganizationInfo: [AddictionOrganization]?
    
    var filteredEventInfo: [Event] = []
    var filteredVenueInfo: [Venue] = []
    var filteredOrganizationInfo: [Organization] = []
    
    var searchController: UISearchController!
    var searchedEvents = [Event]()
    var searchedVenues = [Venue]()
    var searchedOrganizations = [Organization]()
    
    //var GlobalVariables.eventImageCache = [String:UIImage]()
    //var GlobalVariables.venueImageCache = [String:UIImage]()
    //var GlobalVariables.organizationImageCache = [String:UIImage]()
    
    func configureView(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        exploreTableView.rowHeight = ( screenHeight - screenHeight * 70 / 568 ) * 0.5
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        self.panelControllerContainer.dragDelegate = self
        self.panelControllerContainer.visibilityStateDelegate = self
        self.exploreTableView!.allowsMultipleSelection = false
        //print("OOOOOOOOOOOOOOO", screenHeight, screenSize.width)
        
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
        
        self.view.bringSubviewToFront(bruhaButton)
        self.view.bringSubviewToFront(mapButton)
        
        self.view.bringSubviewToFront(exploreLabel)
        self.view.bringSubviewToFront(exploreImage)
        adjustLabelConstraint(exploreWidthLabel)
        adjustImageConstraint(exploreHeightLabel)
        adjustImageConstraint(exploreHeightImage)
        adjustImageConstraint(exploreWidthImage)
        
        exploreLabel.adjustsFontSizeToFitWidth = true
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
        
        switch(GlobalVariables.selectedDisplay){
            
        case "Event":
            exploreLabel.text = "Event"
            
        case "Venue":
            exploreLabel.text = "Venue"
            
        case "Organization":
            exploreLabel.text = "Organization"
            
        default:
            exploreLabel.text = "Event"
        }
        
        
        UIView.animateWithDuration(1.5, delay: 0.0, options: [.TransitionFlipFromLeft], animations: { () -> Void in
            self.exploreLabel.alpha = 1
            self.exploreImage.alpha = 1
            }) {(finished) -> Void in
                
                UIView.animateWithDuration(2.5, delay: 0.3, options: [.TransitionFlipFromRight], animations: { () -> Void in
                    self.exploreLabel.alpha = 0.0
                    self.exploreImage.alpha = 0.0
                    }) {(finished) -> Void in
                }
        }
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
        barView.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
        //barView.alpha = 0.5
        self.view.addSubview(barView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        //customTopButtons()
        customStatusBar()
        
        //exploreTableView.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
        exploreTableView.separatorColor = UIColor.clearColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationEvent", name: "itemDisplayChangeEvent", object: nil)
        
        GlobalVariables.displayedEvents = FetchData(context: managedObjectContext).fetchEvents()!
        GlobalVariables.displayedVenues = FetchData(context: managedObjectContext).fetchVenues()!
        GlobalVariables.displayedArtists = FetchData(context: managedObjectContext).fetchArtists()!
        GlobalVariables.displayedOrganizations = FetchData(context: managedObjectContext).fetchOrganizations()!
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationEvent", name: "filter", object: nil)
        
        
        self.exploreLabel.alpha = 0.0
        self.exploreImage.alpha = 0.0
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "animateHeader", name: "itemDisplayChangeEvent", object: nil)
        
        backgroundGradient()
        // Do any additional setup after loading the view.
        
        fetchInformation()
        
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
        
        exploreTableView.tableHeaderView = searchController.searchBar
        
        if GlobalVariables.searchedText != "" {
            searchController.searchBar.text = GlobalVariables.searchedText
        }
        
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
        self.exploreTableView.layer.insertSublayer(background, atIndex: 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animateHeader()
        
        if GlobalVariables.searchedText != "" {
            searchController.active = true
            searchController.becomeFirstResponder()
        }
        
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
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        GlobalVariables.searchedText = ""
    }
    
    func filterForSearchText(searchText: String, scope: String = "Search") {
        
        if GlobalVariables.selectedDisplay == "Event" {
            if GlobalVariables.filterEventBool {
                if searchController.searchBar.text != ""  {
                    searchedEvents = filteredEventInfo.filter({ (event: Event) -> Bool in
                        //print(event.eventVenueAddress.componentsSeparatedByString(", ")[0] + " " + event.eventVenueCity)
                        return ( scope == "Search" && event.eventName.lowercaseString.containsString(searchText.lowercaseString) ) ||
                            ( scope == "Location" && (event.eventVenueAddress.componentsSeparatedByString(", ")[0] + " " + event.eventVenueCity).lowercaseString.containsString(searchText.lowercaseString) )
                    })
                } else if searchController.searchBar.text == "" {
                    searchedEvents = filteredEventInfo
                }
            }
            else {
                if searchController.searchBar.text != "" {
                    // searched results
                    searchedEvents = eventInfo.filter({ (event: Event) -> Bool in
                        //print(event.eventVenueAddress.componentsSeparatedByString(", ")[0] + " " + event.eventVenueCity)
                        return ( scope == "Search" && event.eventName.lowercaseString.containsString(searchText.lowercaseString) ) ||
                            ( scope == "Location" && (event.eventVenueAddress.componentsSeparatedByString(", ")[0] + " " + event.eventVenueCity).lowercaseString.containsString(searchText.lowercaseString) )
                    })
                    print("searched Events numebr", searchedEvents.count)
                } else if searchController.searchBar.text == "" {
                    searchedEvents = eventInfo
                }
            }
        }
        
        if GlobalVariables.selectedDisplay == "Venue" {
            if GlobalVariables.filterVenueBool {
                if searchController.searchBar.text != ""  {
                    searchedVenues = filteredVenueInfo.filter({ (venue: Venue) -> Bool in
                        return ( scope == "Search" && venue.venueName.lowercaseString.containsString(searchText.lowercaseString) ) ||
                            ( scope == "Location" && (venue.venueAddress.stringByReplacingOccurrencesOfString(",", withString: "")).lowercaseString.containsString(searchText.lowercaseString) )
                    })
                } else if searchController.searchBar.text == "" {
                    searchedVenues = filteredVenueInfo
                }
            }
            else {
                if searchController.searchBar.text != "" {
                    searchedVenues = venueInfo!.filter({ (venue: Venue) -> Bool in
                        return ( scope == "Search" && venue.venueName.lowercaseString.containsString(searchText.lowercaseString) ) ||
                            ( scope == "Location" && (venue.venueAddress.stringByReplacingOccurrencesOfString(",", withString: "")).lowercaseString.containsString(searchText.lowercaseString) )
                    })
                } else if searchController.searchBar.text == "" {
                    searchedVenues = venueInfo!
                }
            }
        }
        
        if GlobalVariables.selectedDisplay == "Organization" {
            if GlobalVariables.filterOrganizationBool {
                if searchController.searchBar.text != ""  {
                    searchedOrganizations = filteredOrganizationInfo.filter({ (organization: Organization) -> Bool in
                        return ( scope == "Search" && organization.organizationName.lowercaseString.containsString(searchText.lowercaseString) ) ||
                            ( scope == "Location" && (organization.organizationAddress.stringByReplacingOccurrencesOfString(",", withString: "")).lowercaseString.containsString(searchText.lowercaseString) )
                    })
                } else if searchController.searchBar.text == "" {
                    searchedOrganizations = filteredOrganizationInfo
                }
            }
            else {
                if searchController.searchBar.text != "" {
                    searchedOrganizations = organizationInfo!.filter({ (organization: Organization) -> Bool in
                        return ( scope == "Search" && organization.organizationName.lowercaseString.containsString(searchText.lowercaseString) ) ||
                            ( scope == "Location" && (organization.organizationAddress.stringByReplacingOccurrencesOfString(",", withString: "")).lowercaseString.containsString(searchText.lowercaseString) )
                    })
                } else if searchController.searchBar.text == "" {
                    searchedOrganizations = organizationInfo!
                }
            }
        }
        
        exploreTableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        GlobalVariables.searchedText = searchText
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
            var mEventInfo: [Event] = []
            
            if searchController.searchBar.text == "" && !GlobalVariables.filterEventBool{
                mEventInfo = eventInfo
            }
            else if searchController.searchBar.text == "" && GlobalVariables.filterEventBool {
                mEventInfo = filteredEventInfo
            }
            else if searchController.searchBar.text != "" {
                mEventInfo = searchedEvents
            }
            
            if mEventInfo.count == 0 {
                emptyStateImage.hidden = false
            } else {
                emptyStateImage.hidden = true
            }
            
            return (mEventInfo.count)
            
        case "Venue":
            var mVenueInfo: [Venue] = []
            
            if searchController.searchBar.text == "" && !GlobalVariables.filterVenueBool{
                mVenueInfo = venueInfo!
            }
            else if searchController.searchBar.text == "" && GlobalVariables.filterVenueBool {
                mVenueInfo = filteredVenueInfo
            }
            else if searchController.searchBar.text != "" {
                mVenueInfo = searchedVenues
            }
            
            if mVenueInfo.count == 0 {
                emptyStateImage.hidden = false
            } else {
                emptyStateImage.hidden = true
            }
            
            return (mVenueInfo.count)
            
        case "Artist":
            let artistInfo = FetchData(context: managedObjectContext).fetchArtists()
            return (artistInfo?.count)!
            
        case "Organization":
            var mOrganizationInfo: [Organization] = []
            
            if searchController.searchBar.text == "" && !GlobalVariables.filterOrganizationBool{
                mOrganizationInfo = organizationInfo!
            }
            else if searchController.searchBar.text == "" && GlobalVariables.filterOrganizationBool {
                mOrganizationInfo = filteredOrganizationInfo
            }
            else if searchController.searchBar.text != "" {
                mOrganizationInfo = searchedOrganizations
            }
            
            if mOrganizationInfo.count == 0 {
                emptyStateImage.hidden = false
            } else {
                emptyStateImage.hidden = true
            }
            
            return (mOrganizationInfo.count)
            
        default:
            
            return (venueInfo!.count)
        }
        
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        if GlobalVariables.eventImageCache.count >= 50 { GlobalVariables.eventImageCache.removeAtIndex(0) }
        if GlobalVariables.venueImageCache.count >= 50 { GlobalVariables.venueImageCache.removeAtIndex(0) }
        if GlobalVariables.organizationImageCache.count >= 50 { GlobalVariables.organizationImageCache.removeAtIndex(0) }
        
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
            
            
            //let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
            //let addictionEventInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
            
            var like = 0
            
            
            if searchController.searchBar.text == "" && !GlobalVariables.filterEventBool{ //when there is no filtering & no searching
                let event = eventInfo![indexPath.row]
                
                for addict in addictionEventInfo! {
                    if addict.eventID == event.eventID {
                        like = 1
                    }
                }
                
                //                let start = NSDate()
                //                let end = NSDate()
                //                let timeInterval: Double = end.timeIntervalSinceDate(start)
                //                print("time running is \(timeInterval)")
                
                cell.ExploreImage.contentMode = UIViewContentMode.ScaleToFill
                
                //                if mPosterInfo!.contains({$0.ID == event.eventID}) {
                //
                //                    let idx = mPosterInfo!.indexOf({$0.ID == event.eventID})
                //
                //                    if mPosterInfo![idx!].Image?.length > 800 {
                //                        cell.ExploreImage.image = UIImage(data: mPosterInfo![idx!].Image!)
                //                    } else {
                //                        cell.ExploreImage.image = randomImage()
                //                    }
                //                }
                //                else {
                //                    cell.ExploreImage.image = randomImage()
                //                }
                
                
                if let img = GlobalVariables.eventImageCache[event.eventID] {
                    cell.ExploreImage.image = img
                    //print("catched! \(event.eventName)")
                    
                    //print(GlobalVariables.eventImageCache[event.eventID])
                }
                    
                else if let checkedUrl = NSURL(string:event.posterUrl) {
                    
                    self.getDataFromUrl(checkedUrl) { data in
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            if let downloadImg = data {
                                
                                if downloadImg.length > 800 {
                                    
                                    let image = UIImage(data: downloadImg)
                                    GlobalVariables.eventImageCache[event.eventID] = image
                                    
                                    cell.ExploreImage.image = image
                                    //print("new! \(event.eventName)", GlobalVariables.eventImageCache.count)
                                    
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
                
                
                //                if let images = posterInfo {
                //                    for img in images {
                //                        if img.ID == event.eventID {
                //                            if img.Image?.length > 800 {
                //                                cell.ExploreImage.image = UIImage(data: img.Image!)
                //                            } else {
                //                                cell.ExploreImage.image = randomImage()
                //                            }
                //                        }
                //                    }
                //                }
                
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
                
                if let price = event.eventPrice {
                    if price == "0.00" {cell.circPrice.text = "Free!"; cell.rectPrice.text = "Free!"}
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
            else if searchController.searchBar.text == "" && GlobalVariables.filterEventBool { // when there is filter and no search
                let event = filteredEventInfo[indexPath.row]
                
                for addict in addictionEventInfo! {
                    if addict.eventID == event.eventID {
                        like = 1
                    }
                }
                
                cell.ExploreImage.contentMode = UIViewContentMode.ScaleToFill
                
                // if there is already cache
                if let img = GlobalVariables.eventImageCache[event.eventID] {
                    cell.ExploreImage.image = img
                    //print("catched! \(event.eventName)")
                }
                    
                    // get image from url
                else if let checkedUrl = NSURL(string:event.posterUrl) {
                    //print(checkedUrl)
                    
                    self.getDataFromUrl(checkedUrl) { data in
                        dispatch_async(dispatch_get_main_queue()) {
                            if let downloadImg = data {
                                
                                // getting the image data
                                if downloadImg.length > 800 {
                                    
                                    let image = UIImage(data: downloadImg)
                                    
                                    GlobalVariables.eventImageCache[event.eventID] = image
                                    
                                    cell.ExploreImage.image = image
                                    //print("new! \(event.eventName)")
                                    
                                } else { // when getting error message
                                    cell.ExploreImage.image = self.randomImage()
                                }
                            }
                            else { // when there is no data retrieved, most likely no internet
                                cell.ExploreImage.image = self.randomImage()
                            }
                        }
                    }
                    
                }
                
                
                cell.circTitle.text = event.eventName
                cell.circDate.text = convertCircTimeFormat("\(event.eventStartDate)")
                
                if let price = event.eventPrice! {
                    if price == "0.00" {cell.circPrice.text = "Free!"; cell.rectPrice.text = "Free!"}
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
            }
            else if searchController.searchBar.text != "" { // when there is search
                print(searchedEvents.count, "error count")
                let event = searchedEvents[indexPath.row]
                
                for addict in addictionEventInfo! {
                    if addict.eventID == event.eventID {
                        like = 1
                    }
                }
                
                cell.ExploreImage.contentMode = UIViewContentMode.ScaleToFill
                
                // if there is already cache
                if let img = GlobalVariables.eventImageCache[event.eventID] {
                    cell.ExploreImage.image = img
                    //print("catched! \(event.eventName)")
                }
                    
                    // get image from url
                else if let checkedUrl = NSURL(string:event.posterUrl) {
                    //print(checkedUrl)
                    
                    self.getDataFromUrl(checkedUrl) { data in
                        dispatch_async(dispatch_get_main_queue()) {
                            if let downloadImg = data {
                                
                                // getting the image data
                                if downloadImg.length > 800 {
                                    
                                    let image = UIImage(data: downloadImg)
                                    
                                    GlobalVariables.eventImageCache[event.eventID] = image
                                    
                                    cell.ExploreImage.image = image
                                    //print("new! \(event.eventName)")
                                    
                                } else { // when getting error message
                                    cell.ExploreImage.image = self.randomImage()
                                }
                            }
                            else { // when there is no data retrieved, most likely no internet
                                cell.ExploreImage.image = self.randomImage()
                            }
                        }
                    }
                    
                }
                
                
                cell.circTitle.text = event.eventName
                cell.circDate.text = convertCircTimeFormat("\(event.eventStartDate)")
                
                if let price = event.eventPrice! {
                    if price == "0.00" {cell.circPrice.text = "Free!"; cell.rectPrice.text = "Free!"}
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
            }
            
            
            
            
            let temp: NSMutableArray = NSMutableArray()
            
            if like == 0 {
                temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),attributedTitle: swipeCellTitle("Get Addicted"))
                cell.circAddicted.hidden = true
            } else if like == 1 {
                temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),attributedTitle: swipeCellTitle("Addicted!"))
                cell.circAddicted.hidden = false
            }
            
            cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
            cell.leftUtilityButtons = temp as [AnyObject]
            
            //println(cell.leftUtilityButtons[0].titleLabel!!.text!)
            
            
            let temp2: NSMutableArray = NSMutableArray()
            //temp2.sw_addUtilityButtonWithColor(UIColor.purpleColor(), icon: UIImage(named: "Slide 5"))
            
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
            
            
            //let venueInfo = FetchData(context: managedObjectContext).fetchVenues()
            var like = 0
            //let addictionVenueInfo = FetchData(context: managedObjectContext).fetchAddictionsVenue()
            
            
            if searchController.searchBar.text == "" && !GlobalVariables.filterVenueBool{ // when there is no filtering & no searching
                let venue = venueInfo![indexPath.row]
                
                for addict in addictionVenueInfo! {
                    if addict.venueID == venue.venueID {
                        like = 1
                    }
                }
                
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
                
                //if venue.venueName == "zsdf" {print(venue.venueID)}
                //if venue.venueName == "Niagra" {print(venue.venueID)}
                cell.venueName.text = venue.venueName
                //cell.venueDescription.text = venue.venueName
                cell.venueAddress.text = "\(venue.venueAddress.componentsSeparatedByString(", ")[0])\n\(venue.venueAddress.componentsSeparatedByString(", ")[1])\n\(venue.venueAddress.componentsSeparatedByString(", ")[2])"
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
            else if searchController.searchBar.text == "" && GlobalVariables.filterVenueBool { // when there is filter and no search
                let venue = filteredVenueInfo[indexPath.row]
                
                for addict in addictionVenueInfo! {
                    if addict.venueID == venue.venueID {
                        like = 1
                    }
                }
                
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
                //cell.venueDescription.text = venue.venueName
                cell.venueAddress.text = "\(venue.venueAddress.componentsSeparatedByString(", ")[0])\n\(venue.venueAddress.componentsSeparatedByString(", ")[1])\n\(venue.venueAddress.componentsSeparatedByString(", ")[2])"
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
            else if searchController.searchBar.text != "" { // when there is search
                let venue = searchedVenues[indexPath.row]
                
                for addict in addictionVenueInfo! {
                    if addict.venueID == venue.venueID {
                        like = 1
                    }
                }
                
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
                //cell.venueDescription.text = venue.venueName
                cell.venueAddress.text = "\(venue.venueAddress.componentsSeparatedByString(", ")[0])\n\(venue.venueAddress.componentsSeparatedByString(", ")[1])\n\(venue.venueAddress.componentsSeparatedByString(", ")[2])"
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
            
            
            
            let temp: NSMutableArray = NSMutableArray()
            
            if like == 0 {
                temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),attributedTitle: swipeCellTitle("Get Addicted"))
                cell.circAddicted.hidden = true
            } else if like == 1 {
                temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),attributedTitle: swipeCellTitle("Addicted!"))
                cell.circAddicted.hidden = false
            }
            
            cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75) //must call after assign title and before assigning array to the buttons.
            cell.leftUtilityButtons = temp as [AnyObject]
            
            
            let temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1), attributedTitle: swipeCellTitle("Map"))
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1), attributedTitle: swipeCellTitle("More\nInfo"))
            cell.rightUtilityButtons = nil
            cell.setRightUtilityButtons(temp2 as [AnyObject], withButtonWidth: 75)//must call after assign title and before assigning array to the buttons.
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
            
            
            //let organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()
            var like = 0
            //let addictionOrganizationInfo = FetchData(context: managedObjectContext).fetchAddictionsOrganization()
            
            
            
            if searchController.searchBar.text == "" && !GlobalVariables.filterOrganizationBool{
                let organization = organizationInfo![indexPath.row]
                
                for addict in addictionOrganizationInfo! {
                    if addict.organizationID == organization.organizationID {
                        like = 1
                    }
                }
                
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
                //cell.organizationDescription.text = organization.organizationName
                cell.address.text = "\(organization.organizationAddress.componentsSeparatedByString(", ")[0])\n\(organization.organizationAddress.componentsSeparatedByString(", ")[1])\n\(organization.organizationAddress.componentsSeparatedByString(", ")[2])"
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
            else if searchController.searchBar.text == "" && GlobalVariables.filterOrganizationBool {
                
                let organization = filteredOrganizationInfo[indexPath.row]
                
                for addict in addictionOrganizationInfo! {
                    if addict.organizationID == organization.organizationID {
                        like = 1
                    }
                }
                
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
                //cell.organizationDescription.text = organization.organizationName
                cell.address.text = "\(organization.organizationAddress.componentsSeparatedByString(", ")[0])\n\(organization.organizationAddress.componentsSeparatedByString(", ")[1])\n\(organization.organizationAddress.componentsSeparatedByString(", ")[2])"
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
            else if searchController.searchBar.text != "" {
                
                let organization = searchedOrganizations[indexPath.row]
                
                for addict in addictionOrganizationInfo! {
                    if addict.organizationID == organization.organizationID {
                        like = 1
                    }
                }
                
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
                //cell.organizationDescription.text = organization.organizationName
                cell.address.text = "\(organization.organizationAddress.componentsSeparatedByString(", ")[0])\n\(organization.organizationAddress.componentsSeparatedByString(", ")[1])\n\(organization.organizationAddress.componentsSeparatedByString(", ")[2])"
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
            
            if like == 0 {
                temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),attributedTitle: swipeCellTitle("Get Addicted"))
                cell.circAddicted.hidden = true
            } else if like == 1 {
                temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),attributedTitle: swipeCellTitle("Addicted!"))
                cell.circAddicted.hidden = false
            }
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
                                    
                                    self.updateAddictFetch()
                                    
                                    let eventService = EventService()
                                    eventService.removeAddictedEvents(event.eventID) {
                                        (let removeInfo ) in
                                        print(removeInfo!)
                                    }
                                    
                                    var temp: NSMutableArray = NSMutableArray()
                                    temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),attributedTitle: self.swipeCellTitle("Get Addicted"))
                                    cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
                                    cell.leftUtilityButtons = temp as [AnyObject]
                                    
                                    selectedCell.circAddicted.hidden = true
                                    
                                    self.exploreTableView.reloadData()
                                }
                                alertController.addAction(unlikeAction)
                                alertController.addAction(cancelAction)
                                
                                self.presentViewController(alertController, animated: true, completion: nil)
                                
                                
                            } else if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Get Addicted") {
                                
                                let addEvent = AddictionEvent(eventId: event.eventID, userId: user)
                                SaveData(context: managedObjectContext).saveAddictionEvent(addEvent)
                                print("Getting Addicted with event id \(event.eventID)")
                                print("ADDICTED")
                                
                                updateAddictFetch()
                                
                                let eventService = EventService()
                                
                                eventService.addAddictedEvents(event.eventID) {
                                    (let addInfo ) in
                                    print(addInfo!)
                                }
                                
                                var temp: NSMutableArray = NSMutableArray()
                                temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),attributedTitle: swipeCellTitle("Addicted!"))
                                cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
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
                                    
                                    self.updateAddictFetch()
                                    
                                    let venueService = VenueService()
                                    venueService.removeAddictedVenues(venue.venueID) {
                                        (let removeInfo ) in
                                        print(removeInfo!)
                                    }
                                    
                                    var temp: NSMutableArray = NSMutableArray()
                                    temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),attributedTitle: self.swipeCellTitle("Get Addicted"))
                                    cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
                                    cell.leftUtilityButtons = temp as [AnyObject]
                                    
                                    selectedCell.circAddicted.hidden = true
                                    
                                    self.exploreTableView.reloadData()
                                    
                                }
                                alertController.addAction(unlikeAction)
                                alertController.addAction(cancelAction)
                                
                                self.presentViewController(alertController, animated: true, completion: nil)
                                
                                
                            } else if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Get Addicted") {
                                
                                let addVenue = AddictionVenue(venueId: venue.venueID, userId: user)
                                SaveData(context: managedObjectContext).saveAddictionVenue(addVenue)
                                print("Getting Addicted with venue id \(venue.venueID)")
                                print("ADDICTED")
                                
                                updateAddictFetch()
                                
                                let venueService = VenueService()
                                
                                venueService.addAddictedVenues(venue.venueID) {
                                    (let addInfo ) in
                                    print(addInfo!)
                                }
                                
                                var temp: NSMutableArray = NSMutableArray()
                                temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),attributedTitle: swipeCellTitle("Addicted!"))
                                cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
                                cell.leftUtilityButtons = temp as [AnyObject]
                                
                                selectedCell.circAddicted.hidden = false
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
                                    
                                    self.updateAddictFetch()
                                    
                                    let organizationService = OrganizationService()
                                    
                                    organizationService.removeAddictedOrganizations(organization.organizationID) {
                                        (let removeInfo ) in
                                        print(removeInfo!)
                                    }
                                    
                                    let temp: NSMutableArray = NSMutableArray()
                                    temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),attributedTitle: self.swipeCellTitle("Get Addicted"))
                                    cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
                                    cell.leftUtilityButtons = temp as [AnyObject]
                                    
                                    selectedCell.circAddicted.hidden = true
                                    
                                    self.exploreTableView.reloadData()
                                    
                                }
                                alertController.addAction(unlikeAction)
                                alertController.addAction(cancelAction)
                                
                                self.presentViewController(alertController, animated: true, completion: nil)
                                
                                
                            } else if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Get Addicted") {
                                
                                let addOrgainzation = AddictionOrganization(organizationId: organization.organizationID, userId: user)
                                SaveData(context: managedObjectContext).saveAddictionOrganization(addOrgainzation)
                                print("Getting Addicted with event id \(organization.organizationID)")
                                print("ADDICTED")
                                
                                updateAddictFetch()
                                
                                let organizationService = OrganizationService()
                                
                                organizationService.addAddictedOrganizations(organization.organizationID) {
                                    (let addInfo ) in
                                    print(addInfo!)
                                }
                                
                                let temp: NSMutableArray = NSMutableArray()
                                temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),attributedTitle: swipeCellTitle("Addicted!"))
                                cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
                                cell.leftUtilityButtons = temp as [AnyObject]
                                
                                selectedCell.circAddicted.hidden = false
                            }
                        }
                    }
                }
                
            } else {
                
                alertLogin()
                
            }
            break
        case 1:
            break
        default:
            break
        }
    }
    
    func alertLogin() {
        let alertController = UIAlertController(title: "You are not logged in!", message:nil, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        let loginAction = UIAlertAction(title: "Login", style: .Default) { (_) -> Void in
            self.performSegueWithIdentifier("GoToLogin", sender: self) // Replace SomeSegue with your segue identifier (name)
        }
        let signupAction = UIAlertAction(title: "Signup", style: .Default) { (_) -> Void in
            self.performSegueWithIdentifier("GoToSignup", sender: self) // Replace SomeSegue with your segue identifier (name)
        }
        alertController.addAction(signupAction)
        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
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
                let alert = UIAlertView(title: "Tickets Coming Soon", message: nil, delegate: nil, cancelButtonTitle: nil)
                alert.show()
                let delay = 1.0 * Double(NSEC_PER_SEC)
                var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    alert.dismissWithClickedButtonIndex(-1, animated: true)
                })
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
                self.performSegueWithIdentifier("MoreInfore", sender: self)
            }
            //Organization MoreInfo
            if (GlobalVariables.selectedDisplay == "Organization"){
                let cellIndexPath = self.exploreTableView.indexPathForCell(cell)
                
                let selectedCell = self.exploreTableView.cellForRowAtIndexPath(cellIndexPath!) as! OrganizationTableViewCell
                
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                self.performSegueWithIdentifier("MoreInfore", sender: self)

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
            self.performSegueWithIdentifier("EventMoreInfo", sender: self)
            break
        default:
            break
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "MoreInfore" {
            let destinationController = segue.destinationViewController as! MoreInformationViewController
            destinationController.iconForSource = "Explore"
            if GlobalVariables.selectedDisplay == "Venue" {
                destinationController.sourceForComingEvent = "venue"
                destinationController.sourceID = GlobalVariables.eventSelected
            }
            if GlobalVariables.selectedDisplay == "Organization" {
                destinationController.sourceForComingEvent = "organization"
                destinationController.sourceID = GlobalVariables.eventSelected
            }
        }
        
        if segue.identifier == "ShowOnMap" {
            let destinationController = segue.destinationViewController as! ShowOnMapViewController
            if GlobalVariables.selectedDisplay == "Event" {
                destinationController.sourceForMarker = "event"
                destinationController.sourceID = GlobalVariables.eventSelected
            }
            if GlobalVariables.selectedDisplay == "Venue" {
                destinationController.sourceForMarker = "venue"
                destinationController.sourceID = GlobalVariables.eventSelected
            }
            if GlobalVariables.selectedDisplay == "Organization" {
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
        
        if GlobalVariables.selectedDisplay == "Event"{
            emptyStateImage.image = UIImage(named: "Event-Taco-White")
            navigationTitle.title = "Event"
            searchController.searchBar.placeholder = "Search Events"
            if GlobalVariables.filterEventBool{
                filteredEventInfo = GlobalVariables.displayFilteredEvents
            }
        }
        if GlobalVariables.selectedDisplay == "Venue"{
            emptyStateImage.image = UIImage(named: "Venue_Stool-White")
            navigationTitle.title = "Venue"
            searchController.searchBar.placeholder = "Search Venues"
            if GlobalVariables.filterVenueBool{
                filteredVenueInfo = GlobalVariables.displayFilteredVenues
            }
        }
        if GlobalVariables.selectedDisplay == "Organization"{
            emptyStateImage.image = UIImage(named: "Glasses-White")
            navigationTitle.title = "Organization"
            searchController.searchBar.placeholder = "Search Organizations"
            if GlobalVariables.filterOrganizationBool{
                filteredOrganizationInfo = GlobalVariables.displayFilteredOrganizations
            }
        }
        
        if self.searchController.active && self.searchController.searchBar.text != "" {
            self.searchController.searchResultsUpdater?.updateSearchResultsForSearchController(self.searchController)
        } else { self.exploreTableView.reloadData() }
        
        
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
        
        addictionEventInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
        
        venueInfo = FetchData(context: managedObjectContext).fetchVenues()
        
        addictionVenueInfo = FetchData(context: managedObjectContext).fetchAddictionsVenue()
        
        organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()
        
        addictionOrganizationInfo = FetchData(context: managedObjectContext).fetchAddictionsOrganization()
    }
    
    func updateAddictFetch() {
        
        if GlobalVariables.selectedDisplay == "Event"{
            
            addictionEventInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
        }
        if GlobalVariables.selectedDisplay == "Venue"{
            
            addictionVenueInfo = FetchData(context: managedObjectContext).fetchAddictionsVenue()
        }
        if GlobalVariables.selectedDisplay == "Organization"{
            
            addictionOrganizationInfo = FetchData(context: managedObjectContext).fetchAddictionsOrganization()
        }
        
    }
    
}