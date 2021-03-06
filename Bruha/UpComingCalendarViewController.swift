//
//  UpComingCalendarViewController.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2016-01-26.
//  Copyright © 2016 Bruha. All rights reserved.
//

import UIKit

class UpComingCalendarViewController: UIViewController, JTCalendarDelegate, SWTableViewCellDelegate {
    
    @IBOutlet weak var calendarMenu: JTCalendarMenuView!
    @IBOutlet weak var calendarContentView: JTHorizontalCalendarView!
    
    @IBOutlet weak var calendarTableView: UITableView!
    
    @IBOutlet weak var upComingLegend: UIView!
    @IBOutlet weak var upComingLegendHeight: NSLayoutConstraint!
    @IBOutlet weak var upComingLegendWidth: NSLayoutConstraint!
    
    @IBOutlet weak var upComingLegendLabel: UILabel!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let calendarManager: JTCalendarManager = JTCalendarManager()
    let datesSelected = NSMutableArray()
    
    
    var upcomingEvents: [Event] = []
    var eventsToDisplay: [Event] = []
    
    var sourceForEvent: String?
    var sourceID: String?
    
    
    @IBAction func backButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func adjustLegendConstraint(constraint: NSLayoutConstraint) {
        
        let legendSize: CGRect = calendarContentView.layer.bounds
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        constraint.constant = screenSize.width / 14.0
    }
    
    func customStatusBar() {
        let barView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        barView.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
        //barView.alpha = 0.5
        self.view.addSubview(barView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customStatusBar()
        
        calendarManager.delegate = self
        
        calendarMenu.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
        calendarContentView.layer.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1).CGColor
        
        calendarManager.menuView = calendarMenu
        calendarManager.contentView = calendarContentView
        calendarManager.setDate(NSDate())
        
        
        
        upcomingEvents.removeAll()
        
        
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
        
        
        
        let nib = UINib(nibName: "MapDropTableViewCell", bundle: nil)
        calendarTableView.registerNib(nib, forCellReuseIdentifier: "DropCell")
        
        calendarTableView.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
        
        calendarTableView.indicatorStyle = UIScrollViewIndicatorStyle.White
        
        adjustLegendConstraint(upComingLegendHeight)
        adjustLegendConstraint(upComingLegendWidth)

        // Do any additional setup after loading the view.
    }
    
    func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        
        let newDayView = dayView as! JTCalendarDayView
        
        
        newDayView.hidden = false
        newDayView.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
        newDayView.textLabel.textColor = UIColor.whiteColor()
        
        newDayView.layer.borderColor = UIColor.grayColor().CGColor
        newDayView.layer.borderWidth = 0.5
        newDayView.circleView.hidden = true
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateToMatch = dateFormatter.stringFromDate(newDayView.date)
        
        if(newDayView.isFromAnotherMonth){
            newDayView.removeFromSuperview()
        }
        else {
            
            if upcomingEvents.contains({$0.eventStartDate == dateToMatch}) {
            
                newDayView.backgroundColor = UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 0.75)
                
                if !(datesSelected.containsObject(newDayView.date)){
                    datesSelected.addObject(newDayView.date)
                }
                
                for e in eventsToDisplay {
                    if e.eventStartDate == dateToMatch {
                        newDayView.backgroundColor = UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1.0)
                    }
                }
            }
            
            if calendarManager.dateHelper.date(NSDate(), isTheSameDayThan: newDayView.date){
                print("today is", newDayView.date)
                
                newDayView.circleView.backgroundColor = UIColor.clearColor()
                newDayView.circleView.layer.borderWidth = 1
                newDayView.circleView.layer.borderColor = UIColor.whiteColor().CGColor
                newDayView.circleView.hidden = false
            }
            
        }
        
    }
    
    func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        
        let newDayView = dayView as! JTCalendarDayView
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateToMatch = dateFormatter.stringFromDate(newDayView.date)
        
        if(datesSelected.containsObject(newDayView.date)){
            print("on click")
            
            eventsToDisplay.removeAll()
            
            for e in upcomingEvents {
                if e.eventStartDate == dateToMatch {
                    eventsToDisplay.append(e)
                    newDayView.backgroundColor = UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1.0)
                }
            }
            print(eventsToDisplay.count, "up coming events")
            
            
            calendarTableView.reloadData()
            calendarTableView.flashScrollIndicators()
            
            calendarManager.reload()
            datesSelected.removeObject(newDayView.date)
        }
        
        else if !datesSelected.containsObject(newDayView.date) && newDayView.backgroundColor != UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1) {
            
            if newDayView.backgroundColor == UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1.0) {
                newDayView.backgroundColor = UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 0.75)
            }
            
            eventsToDisplay.removeAll()
            datesSelected.addObject(newDayView.date)
            calendarTableView.reloadData()
        }
        
        //        if(datesSelected.containsObject(newDayView.date)){
        //
        //            datesSelected.removeObject(newDayView.date)
        //            if (newDayView.isFromAnotherMonth) {
        //                newDayView.backgroundColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1.0)
        //            }
        //            else {
        //                newDayView.backgroundColor = UIColor.blackColor()
        //            }
        //
        //        }
        //        else{
        //            datesSelected.addObject(newDayView.date)
        //            newDayView.backgroundColor = UIColor.cyanColor()
        //        }
    }
    
    func calendar(calendar: JTCalendarManager!, prepareMenuItemView menuItemView: UIView!, date: NSDate!) {
        
        let newMenuItemView = menuItemView as! UILabel
        
        let calendar = NSCalendar.currentCalendar()
        let component = calendar.component(NSCalendarUnit.Year, fromDate: date)
        let month = calendar.component(NSCalendarUnit.Month, fromDate: date)
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        let months = dateFormatter.monthSymbols
        let monthSymbol = months[month-1]
        
        // Month title
        let attribute = [NSFontAttributeName: UIFont(name: "OpenSans", size: 18)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        let attributedMonth = NSMutableAttributedString(string: "\(monthSymbol) ", attributes: attribute)
        let attributedDay = NSMutableAttributedString(string: String(component), attributes: attribute)
        
        let arrowAttribute = [NSFontAttributeName: UIFont(name: "OpenSans", size: 18)!, NSForegroundColorAttributeName : UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1)]
        let leftArrowString = NSMutableAttributedString(string: "<<            ", attributes: arrowAttribute)
        let rightArrowString = NSMutableAttributedString(string: "            >>", attributes: arrowAttribute)
        
        let calendarTitle = NSMutableAttributedString()
        calendarTitle.appendAttributedString(leftArrowString)
        calendarTitle.appendAttributedString(attributedMonth)
        calendarTitle.appendAttributedString(attributedDay)
        calendarTitle.appendAttributedString(rightArrowString)
        
        newMenuItemView.attributedText = calendarTitle
        
        //newMenuItemView.text = component as? String
        //newMenuItemView.textColor = UIColor.whiteColor()
        //newMenuItemView.text = "<<            " + monthSymbol + " " + String(component) + "            >>"
        //newMenuItemView.text = monthSymbol
        //newMenuItemView.backgroundColor = UIColor.cyanColor()
        //newMenuItemView.textColor = UIColor.blackColor()
        //newMenuItemView.scrollView
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarManager.reload()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        datesSelected.removeAllObjects()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showHideLegend() {
        if eventsToDisplay.count == 0 {
            upComingLegend.hidden = false; calendarTableView.bringSubviewToFront(upComingLegend)
            upComingLegendLabel.hidden = false
            
        } else {
            upComingLegend.hidden = true
            upComingLegendLabel.hidden = true
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        showHideLegend()
        
        return eventsToDisplay.count
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let animatedCell = cell as? MapDropTableViewCell {
            animatedCell.swipeLeft.alpha = 1
            animatedCell.swipeRight.alpha = 1
            animatedCell.animate()
        }
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->   UITableViewCell {
        
        let cell: MapDropTableViewCell = self.calendarTableView.dequeueReusableCellWithIdentifier("DropCell") as! MapDropTableViewCell
        
        //let posterInfo = FetchData(context: managedObjectContext).fetchPosterImages()
        if GlobalVariables.eventImageCache.count >= 50 { GlobalVariables.eventImageCache.removeAtIndex(0) }
        if GlobalVariables.venueImageCache.count >= 50 { GlobalVariables.venueImageCache.removeAtIndex(0) }
        if GlobalVariables.organizationImageCache.count >= 50 { GlobalVariables.organizationImageCache.removeAtIndex(0) }
        
        
        let e = eventsToDisplay[indexPath.row]
        
        print("\(e.eventName), ")
        
        cell.dropImage.contentMode = UIViewContentMode.ScaleToFill
        if let img = GlobalVariables.eventImageCache[e.eventID] {
            cell.dropImage.image = img
        }
        else if let checkedUrl = NSURL(string:e.posterUrl) {
            
            self.getDataFromUrl(checkedUrl) { data in
                dispatch_async(dispatch_get_main_queue()) {
                    if let downloadImg = data {
                        if downloadImg.length > 800 {
                            
                            let image = UIImage(data: downloadImg)
                            GlobalVariables.eventImageCache[e.eventID] = image
                            
                            cell.dropImage.image = image
                            
                        } else {
                            cell.dropImage.image = self.randomImage()
                        }
                    }
                    else {
                        cell.dropImage.image = self.randomImage()
                    }
                }
            }
        }
        //Title
        cell.dropTitle.text = "\(e.eventName)"
        
        //Price
        if let price = e.eventPrice {
            if price == "0.00" {cell.dropPrice.text = "Free!"}
            else {cell.dropPrice.text = "$\(price)"}
        } else {cell.dropPrice.text = "No Price"}
        
        //Date
        cell.dropStartDate.text = convertTimeFormat("\(e.eventStartDate) \(e.eventStartTime)")
        
        //Venue Name and Address
        if e.eventVenueName == "" {
            cell.dropContent.text = "nil\n\(e.eventVenueAddress.componentsSeparatedByString(", ")[0])\n\(e.eventVenueCity)"
        } else {cell.dropContent.text = "\(e.eventVenueName)\n\(e.eventVenueAddress.componentsSeparatedByString(", ")[0])\n\(e.eventVenueCity)"}
        
        
        cell.dropHiddenID.text = "\(e.eventID)"
        
        // configure swipe cell
        let temp: NSMutableArray = NSMutableArray()
        var like = 0
        let addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
        for addict in addictionInfo! {
            if addict.eventID == eventsToDisplay[indexPath.row].eventID {
                like = 1
            }
        }
        
        if like == 0 {
            temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),attributedTitle: swipeCellTitle("Get Addicted"))
        } else if like == 1 {
            temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),attributedTitle: swipeCellTitle("Addicted!"))
        }
        cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
        cell.leftUtilityButtons = temp as [AnyObject]
        
        let temp2: NSMutableArray = NSMutableArray()
        temp2.sw_addUtilityButtonWithColor(UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1), attributedTitle: swipeCellTitle("Buy Tickets"))
        temp2.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1), attributedTitle: swipeCellTitle("More\nInfo"))
        
        
        cell.rightUtilityButtons = nil
        cell.setRightUtilityButtons(temp2 as [AnyObject], withButtonWidth: 75)
        cell.rightUtilityButtons = temp2 as [AnyObject]
        
        cell.delegate = self
        cell.selectionStyle = .None
        
        
        print("-----------------------")
        return cell
    }
    
    
    func convertTimeFormat(date: String) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        if let ndate = dateFormatter.dateFromString(date) {
            
            dateFormatter.dateFormat = "EEE, MMM dd, yyyy 'at' h:mma"
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            let timeStamp = dateFormatter.stringFromDate(ndate)
            return timeStamp
        }
        else {return "nil or error times"}
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
    
    //Swipe Cells Actions
    func swipeableTableViewCell( cell : SWTableViewCell!,didTriggerLeftUtilityButtonWithIndex index:NSInteger){
        
        switch(index){
        case 0:
            
            let user = FetchData(context: managedObjectContext).fetchUserInfo()![0].userName
            
            var cellIndexPath = self.calendarTableView.indexPathForCell(cell)
            var selectedCell = self.calendarTableView.cellForRowAtIndexPath(cellIndexPath!) as! MapDropTableViewCell
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
                            
                            var temp: NSMutableArray = NSMutableArray()
                            temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),attributedTitle: self.swipeCellTitle("Get Addicted"))
                            cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
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
                        
                        var temp: NSMutableArray = NSMutableArray()
                        temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),attributedTitle: swipeCellTitle("Addicted!"))
                        cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
                        cell.leftUtilityButtons = temp as [AnyObject]
                        
                        
                    }
                }
            }
            break
        default:
            break
        }
        
    }
    
    func swipeableTableViewCell( cell : SWTableViewCell!,didTriggerRightUtilityButtonWithIndex index:NSInteger){
        
        switch(index){
        case 0:
            
            print("event ticket")
            
            let alert = UIAlertView(title: "Tickets Coming Soon", message: nil, delegate: nil, cancelButtonTitle: nil)
            alert.show()
            let delay = 1.0 * Double(NSEC_PER_SEC)
            var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                alert.dismissWithClickedButtonIndex(-1, animated: true)
            })
            
            break
        case 1:
            //More Info
            let cellIndexPath = self.calendarTableView.indexPathForCell(cell)
            let selectedCell = self.calendarTableView.cellForRowAtIndexPath(cellIndexPath!) as! MapDropTableViewCell
            GlobalVariables.eventSelected = selectedCell.dropHiddenID.text!
            
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
