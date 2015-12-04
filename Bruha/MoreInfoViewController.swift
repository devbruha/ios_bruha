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
    @IBOutlet weak var bruhaButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var panelControllerContainer: ARSPContainerController!

    @IBAction func backToExploreButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func customStatusBar() {
        let barView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        barView.backgroundColor = UIColor.grayColor()
        
        self.view.addSubview(barView)
    }
    
    func customTopButtons() {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        bruhaButton.setBackgroundImage(UIImage(named: "Bruha_White"), forState: UIControlState.Normal)
        let heightContraints = NSLayoutConstraint(item: bruhaButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.height/15.5)
        heightContraints.priority = UILayoutPriorityDefaultHigh
        
        let widthContraints = NSLayoutConstraint(item: bruhaButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.width/9)
        widthContraints.priority = UILayoutPriorityDefaultHigh
        
        bruhaButton.addConstraints([heightContraints, widthContraints])
        
        
        backButton.setBackgroundImage(UIImage(named: "MapIcon"), forState: UIControlState.Normal)
        let heightContraint = NSLayoutConstraint(item: backButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.height/15.5)
        heightContraint.priority = UILayoutPriorityDefaultHigh
        
        let widthContraint = NSLayoutConstraint(item: backButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.width/9)
        widthContraint.priority = UILayoutPriorityDefaultHigh
        
        backButton.addConstraints([heightContraint, widthContraint])
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        self.panelControllerContainer.dragDelegate = self
        self.panelControllerContainer.visibilityStateDelegate = self
        
        customStatusBar()
        customTopButtons()
        
        if GlobalVariables.selectedDisplay == "Event"{
            let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
            for event in eventInfo{
                if event.eventID == GlobalVariables.eventSelected {
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
