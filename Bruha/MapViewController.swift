//
//  MapViewController.swift
//  Bruha
//
//  Created by lye on 15/8/7.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

class MapViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate,ARSPDragDelegate, ARSPVisibilityStateDelegate {
    //
    var testLocationMarker: GMSMarker!
    var testLocation = CLLocationCoordinate2D(latitude: 43.2628662, longitude: -79.86648939999998)
    
    
    @IBOutlet weak var viewMap: GMSMapView!
    
    
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
    
    func configureView(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        self.panelControllerContainer.dragDelegate = self
        self.panelControllerContainer.visibilityStateDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateMarkers()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateMarkers", name: "itemDisplayChange", object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        viewMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        
        configureView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if !didFindMyLocation {
            
            let myLocation: CLLocation = change[NSKeyValueChangeNewKey] as! CLLocation
            viewMap.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 13.0)
            //viewMap.settings.myLocationButton = true
            
            didFindMyLocation = true
        }
    }
    // MARK: IBAction method implementation
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            
            viewMap.myLocationEnabled = true
            viewMap.settings.myLocationButton = true
            locationManager.startUpdatingLocation()
        }
        else{
            
            var defaultLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 43.2500,longitude: -79.8667)
            
            viewMap.camera = GMSCameraPosition.cameraWithTarget(defaultLocation, zoom: 13.0)
        }
    }
    
    // 5
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            
            viewMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
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
            
            var eventMarker: GMSMarker! = GMSMarker()
            
            eventMarker.title = event.eventName
            eventMarker.position = CLLocationCoordinate2D(latitude: event.eventLatitude,longitude: event.eventLongitude)
            
            if let icon = markerIcon {
                scaledIcon = scaleToSize(markerIcon!, scaledToSize: scaledToSize)
            } else {
                scaledIcon = nil
            }
            eventMarker.icon = scaledIcon
            
            eventMarkers.append(eventMarker)
        }
        
        
        
        
        for venue in displayedVenues{
            let markerIcon = UIImage(named: venue.primaryCategory)
            let scaledToSize: CGSize = CGSize(width: 30, height: 30)
            let scaledIcon: UIImage?
            
            var venueMarker: GMSMarker! = GMSMarker()
            
            venueMarker.title = venue.venueName
            venueMarker.position = CLLocationCoordinate2D(latitude: venue.venueLatitude,longitude: venue.venueLongitude)
            
            if let icon = markerIcon {
                scaledIcon = scaleToSize(markerIcon!, scaledToSize: scaledToSize)
            } else {
                scaledIcon = nil
            }
            venueMarker.icon = scaledIcon
            
            venueMarkers.append(venueMarker)
        }
        
        for organization in displayedOrganizations{
            let markerIcon = UIImage(named: organization.primaryCategory)
            let scaledToSize: CGSize = CGSize(width: 30, height: 30)
            let scaledIcon: UIImage?
            
            var organizationMarker: GMSMarker! = GMSMarker()
            
            organizationMarker.title = organization.organizationName
            organizationMarker.position = CLLocationCoordinate2D(latitude: organization.organizationLatitude,longitude: organization.organizationLongitude)
            
            if let icon = markerIcon {
                scaledIcon = scaleToSize(markerIcon!, scaledToSize: scaledToSize)
            } else {
                scaledIcon = nil
            }
            organizationMarker.icon = scaledIcon
            
            organizationMarkers.append(organizationMarker)
        }
    }
    
    func updateMarkers(){
        
        if(GlobalVariables.selectedDisplay == "Event"){
            
            for marker in eventMarkers{
                
                marker.map = viewMap
            }
            
            for marker in venueMarkers{
                
                marker.map = nil
            }
            
            for marker in organizationMarkers{
                
                marker.map = nil
            }
        }
            
        else if(GlobalVariables.selectedDisplay == "Venue"){
            
            for marker in eventMarkers{
                
                marker.map = nil
            }
            
            for marker in venueMarkers{
                
                marker.map = viewMap
            }
            
            for marker in organizationMarkers{
                
                marker.map = nil
            }
        }
            
        else if(GlobalVariables.selectedDisplay == "Artist"){
            
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
            
        else if(GlobalVariables.selectedDisplay == "Organization"){
            
            for marker in eventMarkers{
                
                marker.map = nil
            }
            
            for marker in venueMarkers{
                
                marker.map = nil
            }
            
            for marker in organizationMarkers{
                
                marker.map = viewMap
            }
        }
    }
    
    
}