//
//  ShowOnMapViewController.swift
//  Bruha
//
//  Created by Hejie Yan on 2015-11-24.
//  Copyright © 2015 Bruha. All rights reserved.
//

import UIKit

class ShowOnMapViewController: UIViewController, GMSMapViewDelegate{
    var panelControllerContainer: ARSPContainerController!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var mapView: GMSMapView!
    let button = UIButton(type: UIButtonType.Custom)
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var locationMarker: GMSMarker!
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    @IBAction func backToExploreButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        mapView.delegate = self
        let mapFrame = mapView.frame.size
        let buttonImage = UIImage(named: "GoogleMapsAppIcon")
        button.setImage(buttonImage, forState: .Normal)
        button.frame = CGRectMake(mapFrame.width - (buttonImage?.size.width)!, mapFrame.height - buttonImage!.size.height, (buttonImage?.size.width)!, buttonImage!.size.height)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        super.viewDidLoad()
        
        var name: String? = "Placeholder" // name of event/venue/org
        var cameraPosition: GMSCameraPosition
        var marker: GMSMarker
        var position: CLLocationCoordinate2D
        
        let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
        let venueInfo = FetchData(context: managedObjectContext).fetchVenues()
        let organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()
        var primaryCategory: String?
//        let venueArtist = FetchData(context: managedObjectContext).fetchArtists()
        
        switch GlobalVariables.selectedDisplay {
            case "Event":

                for event in eventInfo {
                    if event.eventID == GlobalVariables.eventSelected {
                        latitude = event.eventLatitude
                        longitude = event.eventLongitude
                        name = event.eventName
                        primaryCategory = event.primaryCategory
                    }
                }
                cameraPosition = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: 15)
                mapView.camera = cameraPosition
                position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                marker = GMSMarker(position: position)
                marker.icon = UIImage(named: primaryCategory!)
                marker.title = name
                marker.map = mapView
            
            case "Venue":
                for venue in venueInfo! {
                    if venue.venueID == GlobalVariables.eventSelected {
                        latitude = venue.venueLatitude
                        longitude = venue.venueLongitude
                        name = venue.venueName
                        primaryCategory = venue.primaryCategory
                    }
                }
                cameraPosition = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: 15)
                mapView.camera = cameraPosition
                position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                marker = GMSMarker(position: position)
                marker.icon = UIImage(named: primaryCategory!)
                marker.title = name
                marker.map = mapView
            
            case "Organization":
                for organization in organizationInfo! {
                    if organization.organizationID == GlobalVariables.eventSelected {
                        latitude = organization.organizationLatitude
                        longitude = organization.organizationLongitude
                        name = organization.organizationName
                        primaryCategory = organization.primaryCategory
                    }
                }
                cameraPosition = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: 15)
                mapView.camera = cameraPosition
                position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                marker = GMSMarker(position: position)
                marker.icon = UIImage(named: primaryCategory!)
                marker.title = name
                marker.map = mapView
            
            
            default:
                break
            
        }
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        let currentZoom = mapView.camera.zoom
        let centerPostion = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: currentZoom)
        mapView.selectedMarker = marker
        mapView.addSubview(button)
        
        mapView.animateToCameraPosition(centerPostion)
        
        return true
    }
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        
        button.removeFromSuperview()
    }
    
    func buttonAction(sender:UIButton!)
    {
        let currentZoom = mapView.camera.zoom
        print("working")
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:
                "comgooglemaps://?q=\(latitude),\(longitude)&center=\(latitude),\(longitude)&zoom=\(currentZoom)&views=traffic")!)
        } else {
            print("Can't use comgooglemaps://"); //add popup menu
        }
    }

}