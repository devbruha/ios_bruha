//
//  CalendarViewController.swift
//  Bruha
//
//  Created by lye on 15/12/25.
//  Copyright © 2015年 Bruha. All rights reserved.
//

import UIKit
import Foundation

class CalendarViewController: UIViewController, JTCalendarDelegate, SWTableViewCellDelegate{

    @IBOutlet weak var calendarMenu: JTCalendarMenuView!
    @IBOutlet weak var calendarContentView: JTHorizontalCalendarView!
    
    @IBOutlet weak var calendarTableView: UITableView!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let calendarManager: JTCalendarManager = JTCalendarManager()
    let datesSelected = NSMutableArray()
    
    var eventInfo: [Event]! //All Events
    var addictionEventInfo: [AddictionEvent] = [] // user addicted ids
    var userEventInfo: [Event] = [] //user uploaded Events
    var addictedEvents: [Event] = [] // user addicted Events
    var eventsToDisplay: [Event] = [] // Events displayed on calendar click
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        calendarManager.delegate = self
        
        calendarMenu.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
        calendarContentView.layer.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1).CGColor
        
        calendarManager.menuView = calendarMenu
        calendarManager.contentView = calendarContentView
        calendarManager.setDate(NSDate())
        
        //calendarManager.contentView?.backgroundColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1.0)
        
        eventInfo = FetchData(context: managedObjectContext).fetchEvents()
        addictionEventInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()!
        userEventInfo = FetchData(context: managedObjectContext).fetchUserEvents()!
        
        let nib = UINib(nibName: "MapDropTableViewCell", bundle: nil)
        calendarTableView.registerNib(nib, forCellReuseIdentifier: "DropCell")
        
        
        for e in eventInfo {
            if addictionEventInfo.contains({$0.eventID == e.eventID}) {
                addictedEvents.append(e)
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarManager.reload()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        datesSelected.removeAllObjects()
    }
    
    
    func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        
        let newDayView = dayView as! JTCalendarDayView
        
        
        newDayView.hidden = false
        newDayView.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
        newDayView.textLabel.textColor = UIColor.whiteColor()
        
        newDayView.layer.borderColor = UIColor.grayColor().CGColor
        newDayView.layer.borderWidth = 0.5
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateToMatch = dateFormatter.stringFromDate(newDayView.date)
        
        if(newDayView.isFromAnotherMonth){
            newDayView.removeFromSuperview()
        }
        else {
            if addictedEvents.contains({$0.eventStartDate == dateToMatch}){
                newDayView.backgroundColor = UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1.0)
                newDayView.alpha = 0.5
                if !(datesSelected.containsObject(newDayView.date)){
                    datesSelected.addObject(newDayView.date)
                }
            }
            if userEventInfo.contains({$0.eventStartDate == dateToMatch}) {
                newDayView.backgroundColor = UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1.0)
                newDayView.alpha = 0.5
                if !(datesSelected.containsObject(newDayView.date)){
                    datesSelected.addObject(newDayView.date)
                }
            }
            for e in eventsToDisplay {
                if e.eventStartDate == dateToMatch {
                    newDayView.alpha = 1
                }
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
            
            if newDayView.backgroundColor == UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1.0) {
                
                eventsToDisplay.removeAll()
                newDayView.alpha = 1
                
                for u in userEventInfo {
                    if u.eventStartDate == dateToMatch {
                        eventsToDisplay.append(u)
                    }
                }
                print(eventsToDisplay.count, "upload")
                calendarTableView.reloadData()
            }
            if newDayView.backgroundColor == UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1.0){
                
                eventsToDisplay.removeAll()
                newDayView.alpha = 1
                
                for a in addictedEvents{
                    if a.eventStartDate == dateToMatch {
                        print("\(a.eventName)\n")
                        eventsToDisplay.append(a)
                    }
                }
                print(eventsToDisplay.count, "addict")
                calendarTableView.reloadData()
            }
            
            calendarManager.reload()
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
        
        //newMenuItemView.text = component as? String
        newMenuItemView.textColor = UIColor.whiteColor()
        newMenuItemView.text = monthSymbol + " " + String(component)
        //newMenuItemView.text = monthSymbol
        //newMenuItemView.backgroundColor = UIColor.cyanColor()
        //newMenuItemView.textColor = UIColor.blackColor()
        //newMenuItemView.scrollView
        
    }
    //
    //    func calendarBuildWeekDayView(calendar: JTCalendarManager!) -> UIView! {
    //
    //
    //    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(eventsToDisplay.count, "r in sec")
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
        if let price = Float(e.eventPrice!) {
            if price == 0.0 {cell.dropPrice.text = "Free!"}
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
            if addict.eventID == addictionEventInfo[indexPath.row].eventID {
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
}

