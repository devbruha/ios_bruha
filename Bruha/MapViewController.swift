//
//  MapViewController.swift
//  Bruha
//
//  Created by lye on 15/8/7.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func fadeIn(duration: NSTimeInterval = 0.5, delay: NSTimeInterval = 0.0, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UITableView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.alpha = 1.0
            }, completion: completion)  }
    
    func fadeOut(duration: NSTimeInterval = 0.0, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UITableView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
}

class MapViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate, GMSMapViewDelegate,ARSPDragDelegate, ARSPVisibilityStateDelegate, SWTableViewCellDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var viewMap: GMSMapView!
    
    @IBOutlet var dropDownTable: UITableView!
    
    @IBOutlet var BruhaButton: UIButton!
    @IBOutlet var BackButton: UIButton!
    
    
    var panelControllerContainer: ARSPContainerController!
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    
    var locationMarker: GMSMarker!
    
    var eventMarkers: [GMSMarker] = []
    var venueMarkers: [GMSMarker] = []
    var artistMarkers: [GMSMarker] = []
    var organizationMarkers: [GMSMarker] = []
    
    var displayedEvents = GlobalVariables.displayedEvents
    var displayedVenues = GlobalVariables.displayedVenues
    var displayedArtists = GlobalVariables.displayedArtists
    var displayedOrganizations = GlobalVariables.displayedOrganizations
    
    var dropEvents: [Event] = []
    var dropVenues: [Venue] = []
    var dropOrganizations: [Organization] = []
    
    func configureView(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        self.panelControllerContainer.dragDelegate = self
        self.panelControllerContainer.visibilityStateDelegate = self
    }
    
    func customTopButtons() {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        BruhaButton.setBackgroundImage(UIImage(named: "Bruha_White"), forState: UIControlState.Normal)
        let heightContraints = NSLayoutConstraint(item: BruhaButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.height/15.5)
        heightContraints.priority = UILayoutPriorityDefaultHigh
        
        let widthContraints = NSLayoutConstraint(item: BruhaButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.width/9)
        widthContraints.priority = UILayoutPriorityDefaultHigh
        
        BruhaButton.addConstraints([heightContraints, widthContraints])
        

        BackButton.setBackgroundImage(UIImage(named: "List"), forState: UIControlState.Normal)
        let heightContraint = NSLayoutConstraint(item: BackButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.height/15.5)
        heightContraint.priority = UILayoutPriorityDefaultHigh
        
        let widthContraint = NSLayoutConstraint(item: BackButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.width/9)
        widthContraint.priority = UILayoutPriorityDefaultHigh
        
        BackButton.addConstraints([heightContraint, widthContraint])
        
        self.view.bringSubviewToFront(BackButton)
        self.view.bringSubviewToFront(BruhaButton)
    }
    
    func customStatusBar() {
        let barView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        barView.backgroundColor = UIColor.grayColor()
        
        self.view.addSubview(barView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateMarkers()
        
        customTopButtons()
        
        //customStatusBar()
        //UIApplication.sharedApplication().statusBarStyle = .Default
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        dropDownTable.separatorColor = UIColor.clearColor()
        //dropDownTable.separatorStyle = UITableViewCellSeparatorStyle.SingleLineEtched
        dropDownTable.backgroundColor = UIColor.blackColor()
        //dropDownTable.rowHeight = screenSize.width * 0.4
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateMarkers", name: "itemDisplayChangeEvent", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "clearDrop", name: "itemDisplayChangeEvent", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateMarkers", name: "filter", object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        viewMap.delegate = self
        viewMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        
        configureView()
        
        dropDownTable.dataSource = self
        dropDownTable.delegate = self
        dropDownTable.allowsSelection = false
        
        //dropDownTable.showsVerticalScrollIndicator = true
        dropDownTable.indicatorStyle = UIScrollViewIndicatorStyle.White
        
        let nib = UINib(nibName: "MapDropTableViewCell", bundle: nil)
        dropDownTable.registerNib(nib, forCellReuseIdentifier: "DropCell")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        dropDownTable.reloadData()
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        //Event
        if GlobalVariables.selectedDisplay == "Event" {
            dropEvents.removeAll()
            if GlobalVariables.filterEventBool {
                for event in GlobalVariables.displayFilteredEvents{
                    if(event.eventLatitude == marker.position.latitude && event.eventLongitude == marker.position.longitude){
                        dropEvents.append(event)
                    }
                }
            }
            else {
                for event in GlobalVariables.displayedEvents{
                    if(event.eventLatitude == marker.position.latitude && event.eventLongitude == marker.position.longitude){
                        dropEvents.append(event)
                    }
                }
            }
        }
        //Venue
        else if GlobalVariables.selectedDisplay == "Venue" {
            dropVenues.removeAll()
            if GlobalVariables.filterVenueBool {
                for venue in GlobalVariables.displayFilteredVenues{
                    if(venue.venueLatitude == marker.position.latitude && venue.venueLongitude == marker.position.longitude){
                        dropVenues.append(venue)
                    }
                }
            }
            else {
                for venue in GlobalVariables.displayedVenues{
                    if(venue.venueLatitude == marker.position.latitude && venue.venueLongitude == marker.position.longitude){
                        dropVenues.append(venue)
                    }
                }
            }
        }
        //Organization
        else if GlobalVariables.selectedDisplay == "Organization" {
            dropOrganizations.removeAll()
            if GlobalVariables.filterOrganizationBool {
                for organization in GlobalVariables.displayFilteredOrganizations{
                    if(organization.organizationLatitude == marker.position.latitude && organization.organizationLongitude == marker.position.longitude){
                        dropOrganizations.append(organization)
                    }
                }
            }
            else {
                for organization in GlobalVariables.displayedOrganizations{
                    if(organization.organizationLatitude == marker.position.latitude && organization.organizationLongitude == marker.position.longitude){
                        dropOrganizations.append(organization)
                    }
                }
            }
        }
        
        BruhaButton.hidden = true
        BackButton.hidden = true
        
        dropDownTable.reloadData()
        viewMap.bringSubviewToFront(dropDownTable)
        dropDownTable.fadeIn()
        dropDownTable.flashScrollIndicators()
        
        return false
    }
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        //print(FetchData(context: managedObjectContext).fetchEvents()!.count)
        hideDrop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if !didFindMyLocation {
            
            //let myLocation: CLLocation = change[NSKeyValueChangeNewKey] as! CLLocation
            //viewMap.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 13.0)
            //viewMap.settings.myLocationButton = true
            
            didFindMyLocation = true
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (GlobalVariables.selectedDisplay){
        case "Event":
            return dropEvents.count
        case "Venue":
            return dropVenues.count
        case "Organization":
            return dropOrganizations.count
        default:
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let animatedCell = cell as? MapDropTableViewCell {
            animatedCell.swipeLeft.alpha = 1
            animatedCell.swipeRight.alpha = 1
            animatedCell.animate()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->   UITableViewCell {
        
        let cell: MapDropTableViewCell = self.dropDownTable.dequeueReusableCellWithIdentifier("DropCell") as! MapDropTableViewCell
        
        let posterInfo = FetchData(context: managedObjectContext).fetchPosterImages()
        
        switch GlobalVariables.selectedDisplay {
        case "Event":
            
            let e = dropEvents[indexPath.row]
            
            // Poster Image
            cell.dropImage.contentMode = UIViewContentMode.ScaleToFill
            if let images = posterInfo {
                for img in images {
                    if img.ID == e.eventID {
                        if img.Image?.length > 800 {
                            cell.dropImage.image = UIImage(data: img.Image!)
                        } else {
                            cell.dropImage.image = randomImage()
                        }
                    }
                }
            }
            //Title
            cell.dropTitle.text = "\(e.eventName)"
            
            //Price
            if let price = Float(e.eventPrice!) {
                if price == 0.0 {cell.dropPrice.text = "Free!"}
                else {cell.dropPrice.text = "$\(price)"}
            } else {cell.dropPrice.text = "No Price"}
            
            //Date
            cell.dropStartDate.text = convertTimeFormat("\(e.eventStartDate) \(e.eventStartTime)")
            
            //Venue Name and Address
            if e.eventVenueName == "" {
                cell.dropContent.text = "nil\n\(e.eventVenueAddress.componentsSeparatedByString(", ")[0])\n\(e.eventVenueCity)"
            } else {cell.dropContent.text = "\(e.eventVenueName)\n\(e.eventVenueAddress.componentsSeparatedByString(", ")[0])\n\(e.eventVenueCity)"}
            
            
            cell.dropHiddenID.text = "\(e.eventID)"
            
            // configure swipe cell
            let temp: NSMutableArray = NSMutableArray()
            var like = 0
            let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
            for addict in addictionInfo! {
                if addict.eventID == dropEvents[indexPath.row].eventID {
                    like = 1
                }
            }
            
            if like == 0 {
                temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),title: "Get Addicted")
            } else if like == 1 {
                temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),title: "Addicted!")
            }
            
            cell.leftUtilityButtons = temp as [AnyObject]
            
            let temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1), title: "Buy Tickets")
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1), title: "Map")
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1), title: "More Info")
            
            
            cell.rightUtilityButtons = nil
            cell.rightUtilityButtons = temp2 as [AnyObject]
            
            cell.delegate = self
            cell.selectionStyle = .None
            
        case "Venue":
            
            let v = dropVenues[indexPath.row]
            
            cell.dropImage.contentMode = UIViewContentMode.ScaleToFill
            if let images = posterInfo {
                for img in images {
                    if img.ID == v.venueID {
                        if img.Image?.length > 800 {
                            cell.dropImage.image = UIImage(data: img.Image!)
                        } else {
                            cell.dropImage.image = randomImage()
                        }
                    }
                }
            }
            //cell.dropWebContent.loadHTMLString("<font color=\"white\">\(v.venueDescription)</font>", baseURL: nil)
            
            cell.dropTitle.text = "\(v.venueName)"
            cell.dropContent.text = "\(v.venueAddress.componentsSeparatedByString(", ")[0])"
            cell.dropStartDate.text = ""
            cell.dropPrice.text = ""
            
            cell.dropHiddenID.text = "\(v.venueID)"
            
            
            // configure swipe cell
            let temp: NSMutableArray = NSMutableArray()
            var like = 0
            let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsVenue()
            for addict in addictionInfo! {
                if addict.venueID == dropVenues[indexPath.row].venueID {
                    like = 1
                }
            }
            
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

            
        case "Organization":
            
            let o = dropOrganizations[indexPath.row]
            
            cell.dropImage.contentMode = UIViewContentMode.ScaleToFill
            if let images = posterInfo {
                for img in images {
                    if img.ID == o.organizationID {
                        if img.Image?.length > 800 {
                            cell.dropImage.image = UIImage(data: img.Image!)
                        } else {
                            cell.dropImage.image = randomImage()
                        }
                    }
                }
            }
            
            cell.dropTitle.text = "\(o.organizationName)"
            cell.dropContent.text = "\(o.organizationAddress.componentsSeparatedByString(", ")[0])"
            cell.dropStartDate.text = ""
            cell.dropPrice.text = ""
            
            cell.dropHiddenID.text = "\(o.organizationID)"
            
            // configure swipe cell
            let temp: NSMutableArray = NSMutableArray()
            var like = 0
            let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsOrganization()
            for addict in addictionInfo! {
                if addict.organizationID == dropOrganizations[indexPath.row].organizationID {
                    like = 1
                }
            }
            
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
            
        default:
            break
        }
        
        return cell
    }
    
    // MARK: IBAction method implementation
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            
            viewMap.myLocationEnabled = true
            viewMap.settings.myLocationButton = true
            locationManager.startUpdatingLocation()
        }
        else{
            
            let defaultLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 43.2500,longitude: -79.8667)
            
            viewMap.camera = GMSCameraPosition.cameraWithTarget(defaultLocation, zoom: 13.0)
        }
    }
    
    // 5
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first as CLLocation! {
            
            viewMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
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
        //println("Panel Controller was dragged")
    }
    
    func scaleToSize(markerIcon: UIImage, scaledToSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(scaledToSize)
        markerIcon.drawInRect(CGRectMake(0, 0, scaledToSize.width, scaledToSize.height))
        let scaledIcon = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledIcon
    }
    
    func generateMarkers(){
        for event in displayedEvents{
            let markerIcon = UIImage(named: event.primaryCategory)
//            let scaledToSize: CGSize = CGSize(width: 30, height: 30)
//            let scaledIcon: UIImage?
            
            let eventMarker: GMSMarker! = GMSMarker()
            
            eventMarker.title = event.eventName
            
            eventMarker.position = CLLocationCoordinate2D(latitude: event.eventLatitude,longitude: event.eventLongitude)
            
//            if let icon = markerIcon {
//                scaledIcon = scaleToSize(markerIcon!, scaledToSize: scaledToSize)
//            } else {
//                scaledIcon = nil
//            }
            eventMarker.icon = markerIcon
            
            eventMarker.userData = event.eventID
            
            eventMarker.userData = event.eventID
            
            eventMarkers.append(eventMarker)
        }
        
        
        
        
        for venue in displayedVenues{
            let markerIcon = UIImage(named: venue.primaryCategory)
//            let scaledToSize: CGSize = CGSize(width: 30, height: 30)
//            let scaledIcon: UIImage?
            
            let venueMarker: GMSMarker! = GMSMarker()
            
            venueMarker.title = venue.venueName
            venueMarker.position = CLLocationCoordinate2D(latitude: venue.venueLatitude,longitude: venue.venueLongitude)
            
//            if let icon = markerIcon {
//                scaledIcon = scaleToSize(markerIcon!, scaledToSize: scaledToSize)
//            } else {
//                scaledIcon = nil
//            }
            venueMarker.icon = markerIcon
            
            venueMarker.userData = venue.venueID
            
            venueMarker.userData = venue.venueID
            
            venueMarkers.append(venueMarker)
        }
        
        for organization in displayedOrganizations{
            let markerIcon = UIImage(named: organization.primaryCategory)
//            let scaledToSize: CGSize = CGSize(width: 30, height: 30)
//            let scaledIcon: UIImage?
            
            let organizationMarker: GMSMarker! = GMSMarker()
            
            organizationMarker.title = organization.organizationName
            organizationMarker.position = CLLocationCoordinate2D(latitude: organization.organizationLatitude,longitude: organization.organizationLongitude)
            
//            if let icon = markerIcon {
//                scaledIcon = scaleToSize(markerIcon!, scaledToSize: scaledToSize)
//            } else {
//                scaledIcon = nil
//            }
            organizationMarker.icon = markerIcon
            
            organizationMarker.userData = organization.organizationID
            
            organizationMarker.userData = organization.organizationID
            
            organizationMarkers.append(organizationMarker)
        }
    }
    
    func updateMarkers(){
        
        //clears markers
        for marker in eventMarkers{
            marker.map = nil
        }
        for marker in venueMarkers{
            marker.map = nil
        }
        for marker in organizationMarkers{
            marker.map = nil
        }
        
        //updates according to filter
        switch (GlobalVariables.selectedDisplay){
            
        case "Event":
            if GlobalVariables.filterEventBool {
                
                for var i = eventMarkers.count; i > 0; i-- {
                    if GlobalVariables.displayFilteredEvents.contains({$0.eventID == eventMarkers[i-1].userData as! String}) {
                        
                        eventMarkers[i-1].map = viewMap
                    }
                }
            } else {
                for marker in eventMarkers{
                    marker.map = viewMap
                }
            }
            
        case "Venue":
            if GlobalVariables.filterVenueBool {
                
                for var i = venueMarkers.count; i > 0; i-- {
                    if GlobalVariables.displayFilteredVenues.contains({$0.venueID == venueMarkers[i-1].userData as! String}) {
                        
                        venueMarkers[i-1].map = viewMap
                    }
                }
            } else {
                for marker in venueMarkers{
                    marker.map = viewMap
                }
            }
            
        case "Organization":
            if GlobalVariables.filterOrganizationBool {
                
                for var i = organizationMarkers.count; i > 0; i-- {
                    if GlobalVariables.displayFilteredOrganizations.contains({$0.organizationID == organizationMarkers[i-1].userData as! String}) {
                        
                        organizationMarkers[i-1].map = viewMap
                    }
                }
            } else {
                for marker in organizationMarkers{
                    marker.map = viewMap
                }
            }

        default:
            for marker in eventMarkers{
                marker.map = nil
            }
            for marker in venueMarkers{
                marker.map = nil
            }
            for marker in organizationMarkers{
                marker.map = nil
            }
        }        
    }
    
    //Swipe Cells Actions
    func swipeableTableViewCell( cell : SWTableViewCell!,didTriggerLeftUtilityButtonWithIndex index:NSInteger){
      
        switch(index){
        case 0:
            
            if GlobalVariables.loggedIn == true {
                let user = FetchData(context: managedObjectContext).fetchUserInfo()![0].userName
                
                //When Event is selected
                if (GlobalVariables.selectedDisplay == "Event") {
                    var cellIndexPath = self.dropDownTable.indexPathForCell(cell)
                    var selectedCell = self.dropDownTable.cellForRowAtIndexPath(cellIndexPath!) as! MapDropTableViewCell
                    GlobalVariables.eventSelected = selectedCell.dropHiddenID.text!
                    
                    let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
                    for event in eventInfo!{
                        if event.eventID == GlobalVariables.eventSelected {
                            //Like and Unlike
                            if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Addicted!"){
                                
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
                                    
                                    self.hideDrop()
                                    
                                    var temp: NSMutableArray = NSMutableArray()
                                    temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Get Addicted")
                                    cell.leftUtilityButtons = temp as [AnyObject]
                                    
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
                                
                                hideDrop()
                                
                                var temp: NSMutableArray = NSMutableArray()
                                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Addicted!")
                                cell.leftUtilityButtons = temp as [AnyObject]
                                
                                
                            }
                        }
                    }
                }
                
                //When Venue is selected
                if (GlobalVariables.selectedDisplay == "Venue") {
                    var cellIndexPath = self.dropDownTable.indexPathForCell(cell)
                    var selectedCell = self.dropDownTable.cellForRowAtIndexPath(cellIndexPath!) as! MapDropTableViewCell
                    GlobalVariables.eventSelected = selectedCell.dropHiddenID.text!
                    
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
                                    
                                    self.hideDrop()
                                    
                                    var temp: NSMutableArray = NSMutableArray()
                                    temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Get Addicted")
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
                                
                                hideDrop()
                                
                                var temp: NSMutableArray = NSMutableArray()
                                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Addicted!")
                                cell.leftUtilityButtons = temp as [AnyObject]
                            }
                        }
                    }
                }
                
                //When Oragnization is selected
                if (GlobalVariables.selectedDisplay == "Organization") {
                    let cellIndexPath = self.dropDownTable.indexPathForCell(cell)
                    let selectedCell = self.dropDownTable.cellForRowAtIndexPath(cellIndexPath!) as! MapDropTableViewCell
                    GlobalVariables.eventSelected = selectedCell.dropHiddenID.text!
                    
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
                                    
                                    self.hideDrop()
                                    
                                    let temp: NSMutableArray = NSMutableArray()
                                    temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Get Addicted")
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
                                
                                hideDrop()
                                
                                let temp: NSMutableArray = NSMutableArray()
                                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Addicted!")
                                cell.leftUtilityButtons = temp as [AnyObject]
                            }
                        }
                    }
                }
                
                
            } else {
                
                let alert = UIAlertView(title: "Please log in for this!!!", message: nil, delegate: nil, cancelButtonTitle: nil)
                alert.show()
                let delay = 5.0 * Double(NSEC_PER_SEC)
                var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                alert.dismissWithClickedButtonIndex(-1, animated: true)
                
            }
            break
        default:
            break
        }

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
                let cellIndexPath = self.dropDownTable.indexPathForCell(cell)
                let selectedCell = self.dropDownTable.cellForRowAtIndexPath(cellIndexPath!) as! MapDropTableViewCell
                GlobalVariables.eventSelected = selectedCell.dropHiddenID.text!
                self.performSegueWithIdentifier("ShowOnMap", sender: self)
            }
            else if GlobalVariables.selectedDisplay == "Organization" {
                let cellIndexPath = self.dropDownTable.indexPathForCell(cell)
                let selectedCell = self.dropDownTable.cellForRowAtIndexPath(cellIndexPath!) as! MapDropTableViewCell
                GlobalVariables.eventSelected = selectedCell.dropHiddenID.text!
                self.performSegueWithIdentifier("ShowOnMap", sender: self)
            }
            break
        case 1:
            if GlobalVariables.selectedDisplay == "Event" {
                //event map
                let cellIndexPath = self.dropDownTable.indexPathForCell(cell)
                let selectedCell = self.dropDownTable.cellForRowAtIndexPath(cellIndexPath!) as! MapDropTableViewCell
                GlobalVariables.eventSelected = selectedCell.dropHiddenID.text!
                self.performSegueWithIdentifier("ShowOnMap", sender: self)
            }
            //Venue MoreInfo
            if (GlobalVariables.selectedDisplay == "Venue"){
                let cellIndexPath = self.dropDownTable.indexPathForCell(cell)
                let selectedCell = self.dropDownTable.cellForRowAtIndexPath(cellIndexPath!) as! MapDropTableViewCell
                GlobalVariables.eventSelected = selectedCell.dropHiddenID.text!
                self.performSegueWithIdentifier("MoreInfore", sender: self)
            }
            //Organization MoreInfo
            if (GlobalVariables.selectedDisplay == "Organization"){
                let cellIndexPath = self.dropDownTable.indexPathForCell(cell)
                let selectedCell = self.dropDownTable.cellForRowAtIndexPath(cellIndexPath!) as! MapDropTableViewCell
                GlobalVariables.eventSelected = selectedCell.dropHiddenID.text!
                self.performSegueWithIdentifier("MoreInfore", sender: self)
                
            }
            break
        case 2:
            //Event More info
            print("event more info")
            let cellIndexPath = self.dropDownTable.indexPathForCell(cell)
            let selectedCell = self.dropDownTable.cellForRowAtIndexPath(cellIndexPath!) as! MapDropTableViewCell
            GlobalVariables.eventSelected = selectedCell.dropHiddenID.text!
            self.performSegueWithIdentifier("MoreInfore", sender: self)
            break
        default:
            break
        }
        
    }
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell : SWTableViewCell ) -> Bool {
        return true
    }
    
    func hideDrop()  {
        
        BruhaButton.hidden = false
        BackButton.hidden = false
        dropDownTable.fadeOut()
    }

    func clearDrop() {
        dropEvents.removeAll()
        dropVenues.removeAll()
        dropOrganizations.removeAll()
        
        dropDownTable.fadeOut()
        
        BruhaButton.hidden = false
        BackButton.hidden = false
    }
    
    func convertTimeFormat(date: String) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        if let ndate = dateFormatter.dateFromString(date) {
            
            dateFormatter.dateFormat = "EEE, MMM dd, yyyy 'at' h:mma"
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            let timeStamp = dateFormatter.stringFromDate(ndate)
            return timeStamp
        }
        else {return "nil or error times"}
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
    
}