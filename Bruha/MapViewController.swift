//
//  MapViewController.swift
//  Bruha
//
//  Created by lye on 15/8/7.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

class MapViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var viewMap: GMSMapView!
    
    @IBOutlet weak var bbFindAddress: UIBarButtonItem!
    
    @IBOutlet weak var lblInfo: UILabel!
    
    var locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: 8.0)
        viewMap.camera = camera
        
        viewMap.delegate = self
        viewMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: IBAction method implementation
    
    @IBAction func changeMapType(sender: AnyObject) {
        
    }
    
    
    @IBAction func findAddress(sender: AnyObject) {
        
    }
    
    
    @IBAction func createRoute(sender: AnyObject) {
        
    }
    
    
    @IBAction func changeTravelMode(sender: AnyObject) {
        
    }
    

}
