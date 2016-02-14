//
//  UpComingEventsViewController.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-12-17.
//  Copyright © 2015 Bruha. All rights reserved.
//

import UIKit

class UpComingEventsViewController: UIViewController, SWTableViewCellDelegate {

    @IBOutlet weak var upComingTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var comingEventLabel: UILabel!
    @IBOutlet weak var comingEventHeightLabel: NSLayoutConstraint!
    
    @IBOutlet weak var comingEventWidthLabel: NSLayoutConstraint!
    
    @IBOutlet weak var comingEventImage: UIImageView!
    @IBOutlet weak var comingEventWidthImage: NSLayoutConstraint!
    
    @IBOutlet weak var comingEventHeightImage: NSLayoutConstraint!
    
    
    @IBOutlet weak var bruhaButton: UIButton!
    @IBAction func backToExploreButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    
    var upcomingEvents: [Event] = []
    var sourceForEvent: String?
    var sourceID: String?
    
    var addictionInfo: [AddictionEvent]?
    
    
    func configureView(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        upComingTableView.rowHeight = ( screenHeight - screenHeight * 70 / 568 ) * 0.5
        
        self.upComingTableView!.allowsMultipleSelection = false
    }
    
    func customTopButtons() {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        bruhaButton.setBackgroundImage(UIImage(named: "Bruha_White"), forState: UIControlState.Normal)
        let heightContraints = NSLayoutConstraint(item: bruhaButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.height/15.5)
        heightContraints.priority = UILayoutPriorityDefaultHigh
        
        let widthContraints = NSLayoutConstraint(item: bruhaButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.width/9)
        widthContraints.priority = UILayoutPriorityDefaultHigh
        
        bruhaButton.addConstraints([heightContraints, widthContraints])
        
        backButton.setBackgroundImage(UIImage(named: "arrow-left"), forState: UIControlState.Normal)
        let heightContraint = NSLayoutConstraint(item: backButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.height/15.5)
        heightContraint.priority = UILayoutPriorityDefaultHigh
        
        let widthContraint = NSLayoutConstraint(item: backButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.width/9)
        widthContraint.priority = UILayoutPriorityDefaultHigh
        
        backButton.addConstraints([heightContraint, widthContraint])
        
        self.view.bringSubviewToFront(backButton)
        self.view.bringSubviewToFront(bruhaButton)
        
        
        adjustLabelConstraint(comingEventWidthLabel)
        adjustImageConstraint(comingEventHeightLabel)
        adjustImageConstraint(comingEventHeightImage)
        adjustImageConstraint(comingEventWidthImage)
        
        comingEventLabel.adjustsFontSizeToFitWidth = true
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
            self.comingEventLabel.alpha = 1
            self.comingEventImage.alpha = 1
            }) {(finished) -> Void in
                
                UIView.animateWithDuration(2.5, delay: 0.3, options: [.TransitionFlipFromRight], animations: { () -> Void in
                    self.comingEventLabel.alpha = 0.0
                    self.comingEventImage.alpha = 0.0
                    }) {(finished) -> Void in
                }
        }
    }
    
    func customStatusBar() {
        let barView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        barView.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
        //barView.alpha = 0.5
        self.view.addSubview(barView)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        //customTopButtons()
        customStatusBar()
        
        //upComingTableView.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
        upComingTableView.separatorColor = UIColor.clearColor()
        
        self.comingEventLabel.alpha = 0.0
        self.comingEventImage.alpha = 0.0
        
        backgroundGradient()
        
        upcomingEvents.removeAll()
        print(sourceForEvent)
        let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
        for event in eventInfo {
            if sourceForEvent == "venue" {
                if event.venueID == sourceID {
                    upcomingEvents.append(event)
                    print(event.venueID)
                }
            }
            if sourceForEvent == "organization" {
                
                for orgID in event.organizationID {
                    if orgID == sourceID {
                        upcomingEvents.append(event)
                        print(event.eventName)
                    }
                }
            }
        }
        
        
        // Do any additional setup after loading the view.
        addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
    }
    
    func backgroundGradient() {
        let background = CAGradientLayer().gradientColor()
        background.frame = self.view.bounds
        self.upComingTableView.layer.insertSublayer(background, atIndex: 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        animateHeader()
        upComingTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        
        return (upcomingEvents.count)
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let animatedCell = cell as? EventTableViewCell {
            animatedCell.animate()
        }
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let posterInfo = FetchData(context: managedObjectContext).fetchPosterImages()
        if GlobalVariables.eventImageCache.count >= 50 { GlobalVariables.eventImageCache.removeAtIndex(0) }
        if GlobalVariables.venueImageCache.count >= 50 { GlobalVariables.venueImageCache.removeAtIndex(0) }
        if GlobalVariables.organizationImageCache.count >= 50 { GlobalVariables.organizationImageCache.removeAtIndex(0) }
        
        var cell : EventTableViewCell! = tableView.dequeueReusableCellWithIdentifier("eventTableViewCell") as! EventTableViewCell!
        
        if(cell == nil){
            
            cell = NSBundle.mainBundle().loadNibNamed("EventTableViewCell", owner: self, options: nil)[0] as! EventTableViewCell;
        }
        
        let event = upcomingEvents[indexPath.row]
        
        cell.ExploreImage.contentMode = UIViewContentMode.ScaleToFill
        if let img = GlobalVariables.eventImageCache[event.eventID] {
            cell.ExploreImage.image = img
        }
        else if let checkedUrl = NSURL(string:event.posterUrl) {
            
            self.getDataFromUrl(checkedUrl) { data in
                dispatch_async(dispatch_get_main_queue()) {
                    if let downloadImg = data {
                        if downloadImg.length > 800 {
                            
                            let image = UIImage(data: downloadImg)
                            GlobalVariables.eventImageCache[event.eventID] = image
                            
                            cell.ExploreImage.image = image
                            
                        } else {
                            cell.ExploreImage.image = self.randomImage()
                        }
                    }
                    else {
                        cell.ExploreImage.image = self.randomImage()
                    }
                }
            }
        }
        
        cell.circTitle.text = event.eventName
        cell.circDate.text = event.eventStartDate
        cell.circPrice.text = "$\(event.eventPrice!)"
        cell.circHiddenID.text = event.eventID
        
        cell.rectTitle.text = event.eventName
        cell.rectPrice.text = "$\(event.eventPrice!)"
        
        if event.eventVenueName == "" {
            cell.venueName.text = "nil"
        }else{cell.venueName.text = event.eventVenueName}
        
        cell.venueAddress.text = "\(event.eventVenueAddress.componentsSeparatedByString(", ")[0])\n\(event.eventVenueCity)"
        
        cell.startTime.text = "\(convertRectTimeFormat("\(event.eventStartDate) \(event.eventStartTime)")) -"
        cell.endTime.text = convertRectTimeFormat("\(event.eventEndDate) \(event.eventEndTime)")
        
        //cell.startDate.text = event.eventStartDate
        //cell.startTime.text = "\(event.eventStartTime) -"
        //cell.endDate.text = event.eventEndDate
        //cell.endTime.text = event.eventEndTime
        
        cell.circAddicted.contentMode = UIViewContentMode.ScaleAspectFit
        cell.circAddicted.image = UIImage(named: "MyAddictions_Sm")
        cell.circCategory.contentMode = UIViewContentMode.ScaleAspectFit
        cell.circCategory.image = UIImage(named: event.primaryCategory)
        
        cell.rectCategory.contentMode = UIViewContentMode.ScaleAspectFill
        cell.rectCategory.image = UIImage(named: event.primaryCategory)
        cell.rectCategoryName.text = event.primaryCategory
        // Configure the cell...

        
        var like = 0
        
        for addict in addictionInfo! {
            if addict.eventID == event.eventID {
                like = 1
            }
        }
        
        
        let temp: NSMutableArray = NSMutableArray()
        
        if like == 0 {
            temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),attributedTitle: swipeCellTitle("Get Addicted"))
            cell.circAddicted.hidden = true
        } else if like == 1 {
            temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),attributedTitle: swipeCellTitle("Addicted!"))
            cell.circAddicted.hidden = false
        }
        
        cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
        cell.leftUtilityButtons = temp as [AnyObject]
        
        
        let temp2: NSMutableArray = NSMutableArray()
        
        temp2.sw_addUtilityButtonWithColor(UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1), attributedTitle: swipeCellTitle("Buy\nTickets"))
        temp2.sw_addUtilityButtonWithColor(UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1), attributedTitle: swipeCellTitle("Map"))
        temp2.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1), attributedTitle: swipeCellTitle("More\nInfo"))
        
        cell.rightUtilityButtons = nil
        cell.setRightUtilityButtons(temp2 as [AnyObject], withButtonWidth: 75)
        cell.rightUtilityButtons = temp2 as [AnyObject]
        
        cell.delegate = self
        cell.selectionStyle = .None
        
        return cell as EventTableViewCell
        
    }
    
    //Swipe Cells Actions
    func swipeableTableViewCell( cell : SWTableViewCell!,didTriggerLeftUtilityButtonWithIndex index:NSInteger){
        switch(index){
        case 0:
            //Like and get addicted
            // Check if user is logged in
            if GlobalVariables.loggedIn == true {
                let user = FetchData(context: managedObjectContext).fetchUserInfo()![0].userName
                
                var cellIndexPath = self.upComingTableView.indexPathForCell(cell)
                var selectedCell = self.upComingTableView.cellForRowAtIndexPath(cellIndexPath!) as! EventTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                
                let eventInfo = upcomingEvents
                for event in eventInfo{
                    if event.eventID == GlobalVariables.eventSelected {
                        //Like and Unlike
                        if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Addicted!"){
                            
                            let alertController = UIAlertController(title: "Are you no longer addicted?", message:nil, preferredStyle: .Alert)
                            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                            let unlikeAction = UIAlertAction(title: "I'm Over It", style: .Default) { (_) -> Void in
                                //print("my idddd \(event.subCategoryID)")
                                DeleteData(context: self.managedObjectContext).deleteAddictionsEvent(event.eventID, deleteUser: user)
                                print("Removed from addiction(event) \(event.eventID)")
                                print("REMOVED")
                                
                                self.updateAddictFetch()
                                
                                let eventService = EventService()
                                eventService.removeAddictedEvents(event.eventID) {
                                    (let removeInfo ) in
                                    print(removeInfo!)
                                }
                                
                                var temp: NSMutableArray = NSMutableArray()
                                temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),attributedTitle: self.swipeCellTitle("Get Addicted"))
                                cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
                                cell.leftUtilityButtons = temp as [AnyObject]
                                
                                selectedCell.circAddicted.hidden = true
                            }
                            alertController.addAction(unlikeAction)
                            alertController.addAction(cancelAction)
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                            
                        } else if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Get Addicted") {
                            
                            let addEvent = AddictionEvent(eventId: event.eventID, userId: user)
                            SaveData(context: managedObjectContext).saveAddictionEvent(addEvent)
                            print("Getting Addicted with event id \(event.eventID)")
                            print("ADDICTED")
                            
                            updateAddictFetch()
                            
                            let eventService = EventService()
                            
                            eventService.addAddictedEvents(event.eventID) {
                                (let addInfo ) in
                                print(addInfo!)
                            }
                            
                            var temp: NSMutableArray = NSMutableArray()
                            temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),attributedTitle: swipeCellTitle("Addicted!"))
                            cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
                            cell.leftUtilityButtons = temp as [AnyObject]
                            
                            selectedCell.circAddicted.hidden = false
                        }
                    }
                }
            } else {
                
                alertLogin()
                
            }
            
        default:
            break
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
    
    func swipeableTableViewCell( cell : SWTableViewCell!,didTriggerRightUtilityButtonWithIndex index:NSInteger){
        
        switch(index){
        case 0:
            //if GlobalVariables.addictedDisplay == "Event" {
                //event ticket
                print("event ticket")
            //}
            
            
        case 1:
            //Event Ticket
            //if GlobalVariables.addictedDisplay == "Event"{
                
                let cellIndexPath = self.upComingTableView.indexPathForCell(cell)
                let selectedCell = self.upComingTableView.cellForRowAtIndexPath(cellIndexPath!) as! EventTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                self.performSegueWithIdentifier("ShowOnMap", sender: self)
                
            //}
            
        case 2:
            
            //Event More info
            print("event more info")
            
            let cellIndexPath = self.upComingTableView.indexPathForCell(cell)
            
            let selectedCell = self.upComingTableView.cellForRowAtIndexPath(cellIndexPath!) as! EventTableViewCell
            
            GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
            self.performSegueWithIdentifier("MoreInfore", sender: self)
            break
        default:
            break
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MoreInfore" {
            let destinationController = segue.destinationViewController as! MoreInformationViewController
            destinationController.sourceForComingEvent = "event"
            destinationController.sourceID = GlobalVariables.eventSelected
        }
        
        if segue.identifier == "ShowOnMap" {
            let destinationController = segue.destinationViewController as! ShowOnMapViewController
            destinationController.sourceForMarker = "event"
            destinationController.sourceID = GlobalVariables.eventSelected
        }
    }
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell : SWTableViewCell ) -> Bool {
        return true
    }
    
    //Circ and Rect View changing
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        
        
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! EventTableViewCell;
            currentCell.tappedView();
            tableView.deselectRowAtIndexPath(indexPath!, animated: false)
            
        
    }
    
    
    func convertCircTimeFormat(date: String) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        if let ndate = dateFormatter.dateFromString(date) {
            
            dateFormatter.dateFormat = "MMM dd, yyyy"
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            let timeStamp = dateFormatter.stringFromDate(ndate)
            return timeStamp
        }
        else {return "nil or error times"}
    }
    
    func convertRectTimeFormat(date: String) -> String {
        
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
    
    func swipeCellTitle(title: String) -> NSAttributedString {
        
        let mAttribute = [NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        let aString = NSMutableAttributedString(string: title, attributes: mAttribute)
        
        return aString
    }
    
    func updateAddictFetch() {
        
        addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
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
