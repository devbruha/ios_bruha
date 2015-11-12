//
//  MoreInfoViewController.swift
//  Bruha
//
//  Created by lye on 15/11/4.
//  Copyright © 2015年 Bruha. All rights reserved.
//

import UIKit

class MoreInfoViewController: UIViewController,ARSPDragDelegate, ARSPVisibilityStateDelegate {
    @IBOutlet weak var Image: UIImageView!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var panelControllerContainer: ARSPContainerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        self.panelControllerContainer.dragDelegate = self
        self.panelControllerContainer.visibilityStateDelegate = self
        
        if GlobalVariables.selectedDisplay == "Event"{
            let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
            for event in eventInfo{
                if event.eventID == GlobalVariables.eventSelected{
                    if let checkedUrl = NSURL(string: event.posterUrl){
                    getDataFromUrl(checkedUrl){
                        data in
                        dispatch_async(dispatch_get_main_queue()){
                            self.Image.image = UIImage(data: data!)
                            }
                        }
                    }
                }
            }
        }
        
        if GlobalVariables.selectedDisplay == "Venue"{
            let venueInfo = FetchData(context: managedObjectContext).fetchVenues()!
            for venue in venueInfo{
                if venue.venueID == GlobalVariables.eventSelected{
                    if let checkedUrl = NSURL(string: venue.posterUrl){
                        getDataFromUrl(checkedUrl){
                            data in
                            dispatch_async(dispatch_get_main_queue()){
                                self.Image.image = UIImage(data: data!)
                            }
                        }
                    }
                }
            }
        }
        if GlobalVariables.selectedDisplay == "Organization"{
            let organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()!
            for organization in organizationInfo{
                if organization.organizationID == GlobalVariables.eventSelected{
                    if let checkedUrl = NSURL(string: organization.posterUrl){
                        getDataFromUrl(checkedUrl){
                            data in
                            dispatch_async(dispatch_get_main_queue()){
                                self.Image.image = UIImage(data: data!)
                            }
                        }
                    }
                }
            }
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
