//
//  MoreInformationViewController.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-12-15.
//  Copyright © 2015 Bruha. All rights reserved.
//

import UIKit

class MoreInformationViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var bruhaButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var VenueName: UILabel!
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var DateUpcoming: UIButton!
    @IBOutlet weak var DateUpcomingLabel: UILabel!
    @IBOutlet weak var PriceCalendar: UIButton!
    @IBOutlet weak var PriceCalendarLabel: UILabel!
    @IBOutlet weak var smallImage: UIImageView!
    @IBOutlet var getAddictedButton: UIButton!
    @IBOutlet var getAddictedLabel: UILabel!
    @IBOutlet var webDescriptionContent: UIWebView!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var ImgeHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var EventCategory: UILabel!
    
    @IBOutlet weak var moreInfoLabel: UILabel!
    @IBOutlet weak var moreInfoHeightLabel: NSLayoutConstraint!
    
    @IBOutlet weak var moreInfoWidthLabel: NSLayoutConstraint!
    
    @IBOutlet weak var moreInfoImage: UIImageView!
    @IBOutlet weak var moreInfoWidthImage: NSLayoutConstraint!
    
    @IBOutlet weak var moreInfoHeightImage: NSLayoutConstraint!
    
    @IBAction func backToExploreButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var iconForSource: String?
    var sourceForComingEvent: String?
    var sourceID: String = "id"
    
    
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
        
        
        
        adjustLabelConstraint(moreInfoWidthLabel)
        adjustImageConstraint(moreInfoHeightLabel)
        adjustImageConstraint(moreInfoHeightImage)
        adjustImageConstraint(moreInfoWidthImage)
        
        moreInfoLabel.adjustsFontSizeToFitWidth = true
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
            self.moreInfoLabel.alpha = 1
            self.moreInfoImage.alpha = 1
            }) {(finished) -> Void in
                
                UIView.animateWithDuration(2.5, delay: 0.3, options: [.TransitionFlipFromRight], animations: { () -> Void in
                    self.moreInfoLabel.alpha = 0.0
                    self.moreInfoImage.alpha = 0.0
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
        
        PriceCalendar.enabled = false
        DateUpcoming.enabled = false
        
        //let posterInfo = FetchData(context: managedObjectContext).fetchPosterImages()
        if GlobalVariables.eventImageCache.count >= 50 { GlobalVariables.eventImageCache.removeAtIndex(0) }
        if GlobalVariables.venueImageCache.count >= 50 { GlobalVariables.venueImageCache.removeAtIndex(0) }
        if GlobalVariables.organizationImageCache.count >= 50 { GlobalVariables.organizationImageCache.removeAtIndex(0) }
        
        if sourceForComingEvent == "event" {
            
            let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
            let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
            for event in eventInfo{
                if event.eventID == sourceID{
                    Name.text = event.eventName
                    
                    if event.eventVenueName == "" {
                        VenueName.text = "nil"
                    } else {VenueName.text = event.eventVenueName }
                    
                    moreInfoLabel.text = "Up & Coming"
                    
                    Address.text = "\(event.eventVenueAddress.componentsSeparatedByString(", ")[0]), \(event.eventVenueCity)"
                    
                    
                    if let price = Float(event.eventPrice!) {
                        if price == 0.0 {PriceCalendarLabel.text = "Free!"}
                        else {PriceCalendarLabel.text = "$\(price)"}
                    } else {PriceCalendarLabel.text = "No Price"}
                    
                    DateUpcomingLabel.text = convertTimeFormat("\(event.eventStartDate)")
                    smallImage.image = UIImage(named: event.primaryCategory)
                    EventCategory.text = event.primaryCategory
                    webDescriptionContent.loadHTMLString("<div style=\"font-family:OpenSans;color:white;width:100%;word-wrap:break-word;\">\(event.eventDescription)</div>", baseURL: nil)
                    
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
                if event.eventID == sourceID && addictionInfo!.contains({$0.eventID == sourceID}) {
                    
                    getAddictedButton.backgroundColor = UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1)
                    getAddictedLabel.text = "You are addicted"
                }
            }
            
        }
        if sourceForComingEvent == "venue"{

            let venueInfo = FetchData(context: managedObjectContext).fetchVenues()!
            let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsVenue()
            for venue in venueInfo{
                if venue.venueID == sourceID{
                    Name.text = venue.venueName
                    VenueName.text = venue.venueAddress   //this is venue address
                    Address.text = ""
                    PriceCalendarLabel.text = "Calendar"
                    DateUpcomingLabel.text = "Up Coming Events"
                    smallImage.image = UIImage(named: venue.primaryCategory)
                    EventCategory.text = venue.primaryCategory
                    webDescriptionContent.loadHTMLString("<div style=\"font-family:OpenSans;color:white;width:100%;word-wrap:break-word;\">\(venue.venueDescription)</div>", baseURL: nil)
                    
                    PriceCalendar.enabled = true
                    DateUpcoming.enabled = true
                    
                    if let img = GlobalVariables.venueImageCache[venue.venueID] {
                        Image.image = img
                    }
                    else if let checkedUrl = NSURL(string:venue.posterUrl) {
                        
                        self.getDataFromUrl(checkedUrl) { data in
                            dispatch_async(dispatch_get_main_queue()) {
                                if let downloadImg = data {
                                    if downloadImg.length > 800 {
                                        
                                        let image = UIImage(data: downloadImg)
                                        GlobalVariables.venueImageCache[venue.venueID] = image
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
                if venue.venueID == sourceID && addictionInfo!.contains({$0.venueID == sourceID}) {
                    
                    getAddictedButton.backgroundColor = UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1)
                    getAddictedLabel.text = "You are addicted"
                }
            }
            
        }
        if sourceForComingEvent == "organization"{

            let organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()
            let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsOrganization()
            for organization in organizationInfo!{
                if organization.organizationID == sourceID{
                    Name.text = organization.organizationName
                    VenueName.text = organization.organizationAddress  //this is the org address
                    Address.text = ""
                    PriceCalendarLabel.text = "Calendar"
                    DateUpcomingLabel.text = "Up Coming Events"
                    smallImage.image = UIImage(named: organization.primaryCategory)
                    EventCategory.text = organization.primaryCategory
                    webDescriptionContent.loadHTMLString("<div style=\"font-family:OpenSans;color:white;width:100%;word-wrap:break-word;\">\(organization.organizationDescription)</div>", baseURL: nil)
                    
                    PriceCalendar.enabled = true
                    DateUpcoming.enabled = true
                    
                    if let img = GlobalVariables.organizationImageCache[organization.organizationID] {
                        Image.image = img
                    }
                    else if let checkedUrl = NSURL(string:organization.posterUrl) {
                        
                        self.getDataFromUrl(checkedUrl) { data in
                            dispatch_async(dispatch_get_main_queue()) {
                                if let downloadImg = data {
                                    if downloadImg.length > 800 {
                                        
                                        let image = UIImage(data: downloadImg)
                                        GlobalVariables.venueImageCache[organization.organizationID] = image
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
                if organization.organizationID == sourceID && addictionInfo!.contains({$0.organizationID == sourceID}) {
                    
                    getAddictedButton.backgroundColor = UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1)
                    getAddictedLabel.text = "You are addicted"
                }
            }
            
        }
        
    }
    
    @IBAction func goUpComing(sender: UIButton) {
        //GlobalVariables.eventSelected = "passing information"
        self.performSegueWithIdentifier("UpComing", sender: self)
    }
    
    @IBAction func goCalendar(sender: UIButton) {
        self.performSegueWithIdentifier("ComingCalendar", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "UpComing" {
            let comingController = segue.destinationViewController as! UpComingEventsViewController
            comingController.sourceForEvent = sourceForComingEvent
            comingController.sourceID = sourceID
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
        
        DateUpcoming.showsTouchWhenHighlighted = true
        PriceCalendar.showsTouchWhenHighlighted = true
        
        moreInfoImage.alpha = 0
        moreInfoLabel.alpha = 0
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        animateHeader()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Logic of getting addicted
    @IBAction func getAddicted(sender: UIButton) {
        //LoggedIn
        if GlobalVariables.loggedIn == true {
            let user = FetchData(context: managedObjectContext).fetchUserInfo()![0].userName
            //Event
            if sourceForComingEvent == "event"{
                let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
                let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
                for event in eventInfo!{
                    if event.eventID == sourceID && !addictionInfo!.contains({$0.eventID == sourceID}) {
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
                        
                    } else if event.eventID == sourceID && addictionInfo!.contains({$0.eventID == sourceID}) {
                        
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
            //Venue
            if sourceForComingEvent == "venue"{
                let venueInfo = FetchData(context: managedObjectContext).fetchVenues()
                let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsVenue()
                for venue in venueInfo!{
                    if venue.venueID == sourceID && !addictionInfo!.contains({$0.venueID == sourceID}) {
                        let addVenue = AddictionVenue(venueId: venue.venueID, userId: user)
                        SaveData(context: managedObjectContext).saveAddictionVenue(addVenue)
                        print("new Venue getaddicted success!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                        let venueService = VenueService()
                        venueService.addAddictedVenues(venue.venueID){
                            (let addInfo) in
                            print(addInfo!)
                        }
                        
                        getAddictedButton.backgroundColor = UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1)
                        getAddictedLabel.text = "You are addicted"
                        
                    } else if venue.venueID == sourceID && addictionInfo!.contains({$0.venueID == sourceID}) {
                        
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
                            
                            self.getAddictedButton.backgroundColor = UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1)
                            self.getAddictedLabel.text = "Get addicted"
                            
                        }
                        alertController.addAction(unlikeAction)
                        alertController.addAction(cancelAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
            //Organization
            if sourceForComingEvent == "organization"{
                let organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()
                let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsOrganization()
                for organization in organizationInfo!{
                    if organization.organizationID == sourceID && !addictionInfo!.contains({$0.organizationID == sourceID}){
                        let addOrganization = AddictionOrganization(organizationId: organization.organizationID, userId: user)
                        SaveData(context: managedObjectContext).saveAddictionOrganization(addOrganization)
                        print("new ORG getaddicted success!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                        let organizationService = OrganizationService()
                        organizationService.addAddictedOrganizations(organization.organizationID){
                            (let addInfo) in
                            print(addInfo!)
                        }
                        print(organization.organizationName)
                        getAddictedButton.backgroundColor = UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1)
                        getAddictedLabel.text = "You are addicted"
                        
                    } else if organization.organizationID == sourceID && addictionInfo!.contains({$0.organizationID == sourceID}) {
                        
                        let alertController = UIAlertController(title: "Are you no longer addicted?", message:nil, preferredStyle: .Alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                        let unlikeAction = UIAlertAction(title: "I'm Over It", style: .Default) { (_) -> Void in
                            
                            DeleteData(context: self.managedObjectContext).deleteAddictionsOrgainzation(organization.organizationID, deleteUser: user)
                            print("Removed from addiction(org) \(organization.organizationID)")
                            print("REMOVED")
                            
                            let organizationService = OrganizationService()
                            
                            organizationService.removeAddictedOrganizations(organization.organizationID) {
                                (let removeInfo ) in
                                print(removeInfo!)
                            }
                            
                            self.getAddictedButton.backgroundColor = UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1)
                            self.getAddictedLabel.text = "Get addicted"
                            
                        }
                        alertController.addAction(unlikeAction)
                        alertController.addAction(cancelAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
        else { //user not logged in
            
            alertLogin()
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
        
        webDescriptionContent.scrollView.scrollEnabled = true
        
        let height = webView.scrollView.contentSize.height
        
        scrollView.contentInset.bottom = height + 180 + 40 + UIScreen.mainScreen().bounds.height * 0.33 + 20
        
        
//        webDescriptionContent.scrollView.scrollEnabled = true
//        
//        scrollView.scrollEnabled = false
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
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        if let ndate = dateFormatter.dateFromString(date) {
            
            dateFormatter.dateFormat = "MMMM dd\nyyyy"
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            let timeStamp = dateFormatter.stringFromDate(ndate)
            return timeStamp
        }
        else {return "nil or error times"}
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
