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
    //
    var testLocationMarker: GMSMarker!
    var testLocation = CLLocationCoordinate2D(latitude: 43.2628662, longitude: -79.86648939999998)
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateMarkers()
        
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
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        
        if GlobalVariables.selectedDisplay == "Event" {
            dropEvents.removeAll()
            for event in GlobalVariables.displayedEvents{
                if(event.eventLatitude == marker.position.latitude && event.eventLongitude == marker.position.longitude){
                    dropEvents.append(event)
                }
            }
        }
        else if GlobalVariables.selectedDisplay == "Venue" {
            dropVenues.removeAll()
            for venue in GlobalVariables.displayedVenues{
                if(venue.venueLatitude == marker.position.latitude && venue.venueLongitude == marker.position.longitude){
                    dropVenues.append(venue)
                }
            }
        }
        else if GlobalVariables.selectedDisplay == "Organization" {
            dropOrganizations.removeAll()
            for organization in GlobalVariables.displayedOrganizations{
                if(organization.organizationLatitude == marker.position.latitude && organization.organizationLongitude == marker.position.longitude){
                    dropOrganizations.append(organization)
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
        print(FetchData(context: managedObjectContext).fetchEvents()!.count)
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
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->   UITableViewCell {
        
        let cell: MapDropTableViewCell = self.dropDownTable.dequeueReusableCellWithIdentifier("DropCell") as! MapDropTableViewCell
        
        switch GlobalVariables.selectedDisplay {
        case "Event":
            
            let e = dropEvents[indexPath.row]
            
            cell.dropImage.contentMode = UIViewContentMode.ScaleToFill
            if let checkedUrl = NSURL(string:e.posterUrl) {
                getDataFromUrl(checkedUrl) { data in
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.dropImage.image = UIImage(data: data!)
                    }
                }
            }
            
            cell.dropTitle.text = "\(e.eventName)"
            cell.dropPrice.text = "\(e.eventPrice!)"
            cell.dropStartDate.text = "\(e.eventStartDate) At \(e.eventStartTime)"
            
            cell.dropContent.text = "\(e.eventVenueName)\n\(e.eventVenueAddress.componentsSeparatedByString(", ")[0])\n\(e.eventVenueAddress.componentsSeparatedByString(", ")[1])"
            
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
                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Get Addicted")
            } else if like == 1 {
                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Addicted!")
            }
            
            cell.leftUtilityButtons = temp as [AnyObject]
            
            let temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor.purpleColor(), title: "Buy Tickets")
            temp2.sw_addUtilityButtonWithColor(UIColor.grayColor(), title: "Map")
            temp2.sw_addUtilityButtonWithColor(UIColor.orangeColor(), title: "More Info")
            
            
            cell.rightUtilityButtons = nil
            cell.rightUtilityButtons = temp2 as [AnyObject]
            
            cell.delegate = self
            cell.selectionStyle = .None
            
        case "Venue":
            
            let v = dropVenues[indexPath.row]
            
            cell.dropImage.contentMode = UIViewContentMode.ScaleToFill
            if let checkedUrl = NSURL(string:v.posterUrl) {
                getDataFromUrl(checkedUrl) { data in
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.dropImage.image = UIImage(data: data!)
                    }
                }
            }
            //cell.dropWebContent.loadHTMLString("<font color=\"white\">\(v.venueDescription)</font>", baseURL: nil)
            
            cell.dropTitle.text = "\(v.venueName)"
            cell.dropContent.text = "\(v.venueAddress.componentsSeparatedByString(", ")[0])\n\(v.venueAddress.componentsSeparatedByString(", ")[1])\n\(v.venueDescription)"
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
                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Get Addicted")
            } else if like == 1 {
                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Addicted!")
            }
            
            cell.leftUtilityButtons = temp as [AnyObject]
            
            let temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor.grayColor(), title: "Map")
            temp2.sw_addUtilityButtonWithColor(UIColor.orangeColor(), title: "More Info")
            cell.rightUtilityButtons = nil
            cell.rightUtilityButtons = temp2 as [AnyObject]
            
            cell.delegate = self
            cell.selectionStyle = .None

            
        case "Organization":
            
            let o = dropOrganizations[indexPath.row]
            
            cell.dropImage.contentMode = UIViewContentMode.ScaleToFill
            if let checkedUrl = NSURL(string:o.posterUrl) {
                getDataFromUrl(checkedUrl) { data in
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.dropImage.image = UIImage(data: data!)
                    }
                }
            }
            
            cell.dropTitle.text = "\(o.organizationName)"
            cell.dropContent.text = "\(o.organizationAddress.componentsSeparatedByString(", ")[0])\n\(o.organizationAddress.componentsSeparatedByString(", ")[1])\n\(o.organizationDescription)"
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
                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Get Addicted")
            } else if like == 1 {
                temp.sw_addUtilityButtonWithColor(UIColor.redColor(),title: "Addicted!")
            }
            
            cell.leftUtilityButtons = temp as [AnyObject]
            
            let temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor.grayColor(), title: "Map")
            temp2.sw_addUtilityButtonWithColor(UIColor.orangeColor(), title: "More Info")
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
            let scaledToSize: CGSize = CGSize(width: 30, height: 30)
            let scaledIcon: UIImage?
            
            let eventMarker: GMSMarker! = GMSMarker()
            
            eventMarker.title = event.eventName
            
            eventMarker.position = CLLocationCoordinate2D(latitude: event.eventLatitude,longitude: event.eventLongitude)
            
            if let icon = markerIcon {
                scaledIcon = scaleToSize(markerIcon!, scaledToSize: scaledToSize)
            } else {
                scaledIcon = nil
            }
            eventMarker.icon = scaledIcon
            
            eventMarker.userData = event.eventID
            
            eventMarkers.append(eventMarker)
        }
        
        
        
        
        for venue in displayedVenues{
            let markerIcon = UIImage(named: venue.primaryCategory)
            let scaledToSize: CGSize = CGSize(width: 30, height: 30)
            let scaledIcon: UIImage?
            
            let venueMarker: GMSMarker! = GMSMarker()
            
            venueMarker.title = venue.venueName
            venueMarker.position = CLLocationCoordinate2D(latitude: venue.venueLatitude,longitude: venue.venueLongitude)
            
            if let icon = markerIcon {
                scaledIcon = scaleToSize(markerIcon!, scaledToSize: scaledToSize)
            } else {
                scaledIcon = nil
            }
            venueMarker.icon = scaledIcon
            
            venueMarker.userData = venue.venueID
            
            venueMarkers.append(venueMarker)
        }
        
        for organization in displayedOrganizations{
            let markerIcon = UIImage(named: organization.primaryCategory)
            let scaledToSize: CGSize = CGSize(width: 30, height: 30)
            let scaledIcon: UIImage?
            
            let organizationMarker: GMSMarker! = GMSMarker()
            
            organizationMarker.title = organization.organizationName
            organizationMarker.position = CLLocationCoordinate2D(latitude: organization.organizationLatitude,longitude: organization.organizationLongitude)
            
            if let icon = markerIcon {
                scaledIcon = scaleToSize(markerIcon!, scaledToSize: scaledToSize)
            } else {
                scaledIcon = nil
            }
            organizationMarker.icon = scaledIcon
            
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
            
            for marker in venueMarkers{
                marker.map = nil
            }
            for marker in organizationMarkers{
                marker.map = nil
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
            
            for marker in eventMarkers{
                marker.map = nil
            }
            for marker in organizationMarkers{
                marker.map = nil
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
            
            for marker in eventMarkers{
                marker.map = nil
            }
            for marker in venueMarkers{
                marker.map = nil
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
            else if GlobalVariables.selectedDisplay == "Venue" || GlobalVariables.selectedDisplay == "Organization" {
                //venue and organization map
                print("venue and org map")
            }
            break
        case 1:
            if GlobalVariables.selectedDisplay == "Event" {
                //event map
                print("event map")
            }
            else if GlobalVariables.selectedDisplay == "Venue" || GlobalVariables.selectedDisplay == "Organization" {
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
    
}