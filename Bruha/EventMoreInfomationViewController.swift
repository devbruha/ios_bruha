//
//  EventMoreInfomationViewController.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2016-01-04.
//  Copyright © 2016 Bruha. All rights reserved.
//

import UIKit

class EventMoreInfomationViewController: UIViewController, UIWebViewDelegate{
    
    @IBOutlet weak var bruhaButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var AffiliatedOrgButton: UIButton!
    @IBOutlet weak var AffiliatedOrgLabel: UILabel!
    @IBOutlet weak var VenueButton: UIButton!
    @IBOutlet weak var VenueNameLabel: UILabel!
    @IBOutlet weak var smallImage: UIImageView!
    @IBOutlet var getAddictedButton: UIButton!
    @IBOutlet var getAddictedLabel: UILabel!
    @IBOutlet var webDescriptionContent: UIWebView!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var ImgeHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var venueAddress: UILabel!
    @IBOutlet weak var eventPrice: UILabel!
    @IBOutlet weak var eventCategory: UILabel!
   
    @IBOutlet weak var eventMoreInfoLabel: UILabel!
    @IBOutlet weak var eventMoreInfoHeightLabel: NSLayoutConstraint!
    
    @IBOutlet weak var eventMoreInfoWidthLabel: NSLayoutConstraint!
    
    @IBOutlet weak var eventMoreInfoImage: UIImageView!
    @IBOutlet weak var eventMoreInfoWidthImage: NSLayoutConstraint!
    
    @IBOutlet weak var eventMoreInfoHeightImage: NSLayoutConstraint!
    
    @IBAction func backToExploreButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var iconForSource: String?
    var sourceID: [String] = ["id"]
    var eventVenueSource: String = "ID"
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    func customTopButtons() {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        bruhaButton.setBackgroundImage(UIImage(named: "Bruha_White"), forState: UIControlState.Normal)
        let heightContraints = NSLayoutConstraint(item: bruhaButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.height/15.5)
        heightContraints.priority = UILayoutPriorityDefaultHigh
        
        let widthContraints = NSLayoutConstraint(item: bruhaButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.width/9)
        widthContraints.priority = UILayoutPriorityDefaultHigh
        
        bruhaButton.addConstraints([heightContraints, widthContraints])
        
        
        
        if iconForSource == "MapIcon" {
            backButton.setBackgroundImage(UIImage(named: "MapIcon"), forState: UIControlState.Normal)
        }
        else{
            backButton.setBackgroundImage(UIImage(named: "List"), forState: UIControlState.Normal)
        }
        
        let heightContraint = NSLayoutConstraint(item: backButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.height/15.5)
        heightContraint.priority = UILayoutPriorityDefaultHigh
        
        let widthContraint = NSLayoutConstraint(item: backButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.width/9)
        widthContraint.priority = UILayoutPriorityDefaultHigh
        
        backButton.addConstraints([heightContraint, widthContraint])
        
        self.view.bringSubviewToFront(backButton)
        self.view.bringSubviewToFront(bruhaButton)
        
        adjustLabelConstraint(eventMoreInfoWidthLabel)
        adjustImageConstraint(eventMoreInfoHeightLabel)
        adjustImageConstraint(eventMoreInfoHeightImage)
        adjustImageConstraint(eventMoreInfoWidthImage)
        
        eventMoreInfoLabel.adjustsFontSizeToFitWidth = true
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
            self.eventMoreInfoLabel.alpha = 1
            self.eventMoreInfoImage.alpha = 1
            }) {(finished) -> Void in
                
                UIView.animateWithDuration(2.5, delay: 0.3, options: [.TransitionFlipFromRight], animations: { () -> Void in
                    self.eventMoreInfoLabel.alpha = 0.0
                    self.eventMoreInfoImage.alpha = 0.0
                    }) {(finished) -> Void in
                }
        }
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }

    
    func labelDisplay(){
        webDescriptionContent.opaque = false
        webDescriptionContent.backgroundColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
        //webDescriptionContent
        
        Image.contentMode = UIViewContentMode.ScaleToFill
        
//        PriceCalendar.enabled = false
//        DateUpcoming.enabled = false
        
        //let posterInfo = FetchData(context: managedObjectContext).fetchPosterImages()
        if GlobalVariables.eventImageCache.count >= 50 { GlobalVariables.eventImageCache.removeAtIndex(0) }
        if GlobalVariables.venueImageCache.count >= 50 { GlobalVariables.venueImageCache.removeAtIndex(0) }
        if GlobalVariables.organizationImageCache.count >= 50 { GlobalVariables.organizationImageCache.removeAtIndex(0) }
        
        if GlobalVariables.selectedDisplay == "Event" || GlobalVariables.addictedDisplay == "Event" || GlobalVariables.uploadDisplay == "Event"{
            
            let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
            let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
            for event in eventInfo{
                if event.eventID == GlobalVariables.eventSelected{
                    Name.text = event.eventName
                    
                    if event.eventVenueName == "" {
                        VenueNameLabel.text = "\(event.eventVenueAddress.componentsSeparatedByString(", ")[0]), \(event.eventVenueCity)"
                        venueAddress.text = ""
                        VenueButton.enabled = false
                    } else {
                        VenueNameLabel.text = event.eventVenueName
                        venueAddress.text = "\(event.eventVenueAddress.componentsSeparatedByString(", ")[0]), \(event.eventVenueCity)"
                        VenueButton.enabled = true
                    }
                    
                    eventTime.text = "\(convertTimeFormat("\(event.eventStartDate) \(event.eventStartTime)"))"
                    
                    
                    if let price = Float(event.eventPrice!) {
                        if price == 0.0 {eventPrice.text = "Free!"}
                        else {eventPrice.text = "$\(price)"}
                    } else {eventPrice.text = "No Price"}
                    
                    AffiliatedOrgLabel.text = "Affiliated Organizations" //convertTimeFormat("\(event.eventStartDate)")
                    smallImage.image = UIImage(named: event.primaryCategory)
                    eventCategory.text = event.primaryCategory
                    webDescriptionContent.loadHTMLString("<div style=\"font-family:OpenSans;color:white;width:100%;word-wrap:break-word;\">\(event.eventDescription)</div>", baseURL: nil)
                    
                    sourceID.append(event.organizationID)
                    eventVenueSource = event.venueID
                    print("org id passed", sourceID); print("event id", event.eventID)
                    if let img = GlobalVariables.eventImageCache[event.eventID] {
                        Image.image = img
                    }
                    else if let checkedUrl = NSURL(string:event.posterUrl) {
                        
                        self.getDataFromUrl(checkedUrl) { data in
                            dispatch_async(dispatch_get_main_queue()) {
                                if let downloadImg = data {
                                    if downloadImg.length > 800 {
                                        
                                        let image = UIImage(data: downloadImg)
                                        GlobalVariables.eventImageCache[event.eventID] = image
                                        
                                        self.Image.image = image
                                        
                                    } else {
                                        self.Image.image = self.randomImage()
                                    }
                                }
                                else {
                                    self.Image.image = self.randomImage()
                                }
                            }
                        }
                    }
                    
                }
                if event.eventID == GlobalVariables.eventSelected && addictionInfo!.contains({$0.eventID == GlobalVariables.eventSelected}) {
                    
                    getAddictedButton.backgroundColor = UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1)
                    getAddictedLabel.text = "You are addicted"
                }
            }
            
        }
    }

    @IBAction func goAffiliatedOrg(sender: UIButton) {
        //GlobalVariables.eventSelected = "passing information"
        self.performSegueWithIdentifier("AffiliatedOrg", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AffiliatedOrg" {
            let comingController = segue.destinationViewController as! AffiliatedOrgViewController
            comingController.sourceID = sourceID
        }
        if segue.identifier == "MoreInfore" {
            let destinationController = segue.destinationViewController as! MoreInformationViewController
            destinationController.sourceForComingEvent = "venue"
            destinationController.sourceID = eventVenueSource
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let imgHeight: CGFloat = screenSize.height * 0.33
        ImgeHeight.constant = imgHeight
        
        customTopButtons()
        labelDisplay()
        webDescriptionContent.delegate = self
        
        scrollView.contentMode = UIViewContentMode.ScaleAspectFit
        scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "Splash Background")!)
        
        AffiliatedOrgButton.showsTouchWhenHighlighted = true
        VenueButton.showsTouchWhenHighlighted = true

        
        self.eventMoreInfoLabel.alpha = 0
        self.eventMoreInfoImage.alpha = 0
        
        // Do any additional setup after loading the view.
        
//        var events = OrderedDictionary<String, Int>()
//        
//        events["one"] = 1
//        events["two"] = 2
//        events["three"] = 3
//        events["four"] = 4
//        events["five"] = 5
//        
//        print(events)
//        
//        events.removeAtIndex(0)
//        
//        print(events)
//        
//        print(events["two"])
//        
//        if let aaa = events["one"] {
//            print(aaa)
//        }
//        //print(events["one"])
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animateHeader()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func goMoreInfo(sender: UIButton) {
        self.performSegueWithIdentifier("MoreInfore", sender: self)
    }
    
    //Logic of getting addicted
    @IBAction func getAddicted(sender: UIButton) {
        //LoggedIn
        if GlobalVariables.loggedIn == true {
            let user = FetchData(context: managedObjectContext).fetchUserInfo()![0].userName
            //Event
            if GlobalVariables.selectedDisplay == "Event" || GlobalVariables.addictedDisplay == "Event" || GlobalVariables.uploadDisplay == "Event"{
                let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
                let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
                for event in eventInfo!{
                    if event.eventID == GlobalVariables.eventSelected && !addictionInfo!.contains({$0.eventID == GlobalVariables.eventSelected}) {
                        let addEvent = AddictionEvent(eventId: event.eventID, userId: user)
                        SaveData(context: managedObjectContext).saveAddictionEvent(addEvent)
                        print("new getaddicted success!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                        let eventService = EventService()
                        eventService.addAddictedEvents(event.eventID){
                            (let addInfo) in
                            print(addInfo!)
                        }
                        
                        getAddictedButton.backgroundColor = UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1)
                        getAddictedLabel.text = "You are addicted"
                        
                    } else if event.eventID == GlobalVariables.eventSelected && addictionInfo!.contains({$0.eventID == GlobalVariables.eventSelected}) {
                        
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
                            
                            self.getAddictedButton.backgroundColor = UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1)
                            self.getAddictedLabel.text = "Get addicted"
                            
                        }
                        alertController.addAction(unlikeAction)
                        alertController.addAction(cancelAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                        //                        let alert = UIAlertView(title: "You are addicted", message: nil, delegate: nil, cancelButtonTitle: nil)
                        //                        alert.show()
                        //                        let delay = 1.0 * Double(NSEC_PER_SEC)
                        //                        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        //                        dispatch_after(time, dispatch_get_main_queue(), {
                        //                            alert.dismissWithClickedButtonIndex(-1, animated: true)
                        //                        })
                    }
                }
            }
            else { //user not logged in
                
                let alert = UIAlertView(title: "Please log in for this!!!", message: nil, delegate: nil, cancelButtonTitle: nil)
                alert.show()
                let delay = 1.0 * Double(NSEC_PER_SEC)
                var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    alert.dismissWithClickedButtonIndex(-1, animated: true)
                })
            }
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .LinkClicked:
            // Open links in Safari
            let alertController = UIAlertController(title: "This link will navigate to a 3rd party website", message:nil, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            let yesAction = UIAlertAction(title: "Ok", style: .Default) { (_) -> Void in
                
                UIApplication.sharedApplication().openURL(request.URL!)
            }
            alertController.addAction(yesAction)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return false
        default:
            // Handle other navigation types...
            return true
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        webDescriptionContent.scrollView.scrollEnabled = false
        
        let height = webView.scrollView.contentSize.height
        
        scrollView.contentInset.bottom = height + 180 + 40 + UIScreen.mainScreen().bounds.height * 0.33 + 30
        
        
        
        //scrollView.setContentOffset(CGPointMake(0, UIScreen.mainScreen().bounds.height * 0.33 + 50), animated: false)
        
//        scrollView.scrollEnabled = true
//        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 500, 0)
//        webDescriptionContent.scrollView.scrollEnabled = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touched")
        if touches.count > 0 {
            let tempTouch = UITouch()
            let touchLocation: CGPoint = tempTouch.locationInView(webDescriptionContent)
            if touchLocation.y > 20 {
                webDescriptionContent.scrollView.scrollEnabled = true
                print("Stop")
            }
            //scrollView.scrollEnabled = false
            
        }
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
    
    func convertTimeFormat(date: String) -> String {
        
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

    func buttonBounce(sender: UIButton) {
        
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = NSNumber(float: 0.5)
        pulseAnimation.toValue = NSNumber(float: 1.0)
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = false
        pulseAnimation.repeatCount = 1  //FLT_MAX
        sender.layer.addAnimation(pulseAnimation, forKey: nil)
        
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
