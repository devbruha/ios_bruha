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
    @IBOutlet weak var backButton: UIButton!
    let button = UIButton(type: UIButtonType.Custom)
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var locationMarker: GMSMarker!
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var sourceForMarker: String?
    var sourceID: String?
    
    @IBAction func backToExploreButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func customStatusBar() {
        let barView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        barView.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
        
        self.view.addSubview(barView)
    }
    
    func customTopButtons() {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        backButton.setBackgroundImage(UIImage(named: "List"), forState: UIControlState.Normal)
        let heightContraint = NSLayoutConstraint(item: backButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.height/15.5)
        heightContraint.priority = UILayoutPriorityDefaultHigh
        
        let widthContraint = NSLayoutConstraint(item: backButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.width/9)
        widthContraint.priority = UILayoutPriorityDefaultHigh
        
        backButton.addConstraints([heightContraint, widthContraint])
        self.view.bringSubviewToFront(backButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customStatusBar()
        //customTopButtons()
        
        mapView.delegate = self
        let mapFrame = mapView.frame.size
        let buttonImage = UIImage(named: "GoogleMapsAppIcon")
        button.setImage(buttonImage, forState: .Normal)
        button.frame = CGRectMake(self.view.frame.size.width - (buttonImage?.size.width)!, self.view.frame.height - buttonImage!.size.height, (buttonImage?.size.width)!, buttonImage!.size.height)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        var name: String? = "Placeholder" // name of event/venue/org
        var cameraPosition: GMSCameraPosition
        var marker: GMSMarker
        var position: CLLocationCoordinate2D
        
        let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
        let venueInfo = FetchData(context: managedObjectContext).fetchVenues()
        let organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()
        var primaryCategory: String?
//        let venueArtist = FetchData(context: managedObjectContext).fetchArtists()
        
        if sourceForMarker == "event"{
            
            for event in eventInfo {
                if event.eventID == sourceID {
                    latitude = event.eventLatitude
                    longitude = event.eventLongitude
                    name = event.eventName
                    primaryCategory = event.primaryCategory
                    
                    cameraPosition = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: 15)
                    mapView.camera = cameraPosition
                    position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    marker = GMSMarker(position: position)
                    marker.icon = resizeCategoryImage(primaryCategory!)
                    marker.title = name
                    marker.map = mapView
                }
            }
        }
        
        if sourceForMarker == "venue"{
            
            for venue in venueInfo! {
                if venue.venueID == sourceID {
                    latitude = venue.venueLatitude
                    longitude = venue.venueLongitude
                    name = venue.venueName
                    primaryCategory = venue.primaryCategory
                    
                    cameraPosition = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: 15)
                    mapView.camera = cameraPosition
                    position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    marker = GMSMarker(position: position)
                    marker.icon = resizeCategoryImage(primaryCategory!)
                    marker.title = name
                    marker.map = mapView
                }
            }
        }
        
        if sourceForMarker == "organization"{
            
            for organization in organizationInfo! {
                if organization.organizationID == sourceID {
                    latitude = organization.organizationLatitude
                    longitude = organization.organizationLongitude
                    name = organization.organizationName
                    primaryCategory = organization.primaryCategory
                    
                    cameraPosition = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: 15)
                    mapView.camera = cameraPosition
                    position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    marker = GMSMarker(position: position)
                    marker.icon = resizeCategoryImage(primaryCategory!)
                    marker.title = name
                    marker.map = mapView
                }
            }
        }
        
    }
    
    func resizeCategoryImage (imgString: String) -> UIImage {
        
        let newImgSize: CGFloat = 30
        
        let imgToResize = UIImage(named: imgString)
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newImgSize, newImgSize), false, 0)
        imgToResize?.drawInRect(CGRectMake(0, 0, newImgSize, newImgSize))
        
        let resizedImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImg
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