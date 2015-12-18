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
    
    @IBOutlet weak var bruhaButton: UIButton!
    @IBAction func backToExploreButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    
    
    func configureView(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        upComingTableView.rowHeight = screenHeight * 0.5
        
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
        
        backButton.setBackgroundImage(UIImage(named: "List"), forState: UIControlState.Normal)
        let heightContraint = NSLayoutConstraint(item: backButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.height/15.5)
        heightContraint.priority = UILayoutPriorityDefaultHigh
        
        let widthContraint = NSLayoutConstraint(item: backButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.width/9)
        widthContraint.priority = UILayoutPriorityDefaultHigh
        
        backButton.addConstraints([heightContraint, widthContraint])
        
        self.view.bringSubviewToFront(backButton)
        self.view.bringSubviewToFront(bruhaButton)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        customTopButtons()
        
        upComingTableView.backgroundColor = UIColor.blackColor()
        upComingTableView.separatorColor = UIColor.blackColor()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
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
        
        let addictedEventInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
        
        return (addictedEventInfo?.count)!
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let animatedCell = cell as? EventTableViewCell {
            animatedCell.animate()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let posterInfo = FetchData(context: managedObjectContext).fetchPosterImages()
        
        
            var cell : EventTableViewCell! = tableView.dequeueReusableCellWithIdentifier("eventTableViewCell") as! EventTableViewCell!
            
            if(cell == nil){
                
                cell = NSBundle.mainBundle().loadNibNamed("EventTableViewCell", owner: self, options: nil)[0] as! EventTableViewCell;
            }
            
            let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
            let addictedEventInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
            for event in eventInfo!{
                
                //download only addicted poster image
                if event.eventID == addictedEventInfo![indexPath.row].eventID  {
                    //println("Begin of code")
                    cell.ExploreImage.contentMode = UIViewContentMode.ScaleToFill
                    if let images = posterInfo {
                        for img in images {
                            if img.ID == event.eventID {
                                if img.Image?.length > 800 {
                                    cell.ExploreImage.image = UIImage(data: img.Image!)
                                } else {
                                    cell.ExploreImage.image = randomImage()
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
                    
                }
                
            }
            
            //println("End of code. The image will continue downloading in the background and it will be loaded when it ends.")
            //Synchronously:
            /*if let url = NSURL(string: event.url) {
            if let data = NSData(contentsOfURL: url){
            cell.ExploreImage.contentMode = UIViewContentMode.ScaleToFill
            cell.ExploreImage.image = UIImage(data: data)
            }
            }*/
            
            
            let temp: NSMutableArray = NSMutableArray()
            temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),title: "Addicted!")
            cell.leftUtilityButtons = temp as [AnyObject]
            
            
            let temp2: NSMutableArray = NSMutableArray()
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1), title: "Buy Tickets")
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1), title: "Map")
            temp2.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1), title: "More Info")
            cell.rightUtilityButtons = nil
            cell.rightUtilityButtons = temp2 as [AnyObject]
            
            cell.delegate = self
            cell.selectionStyle = .None
            
            return cell as EventTableViewCell
            
     
        
        
        
    }
    
    //Swipe Cells Actions
    func swipeableTableViewCell( cell : SWTableViewCell!,didTriggerLeftUtilityButtonWithIndex index:NSInteger){
        switch(index){
        case 0:
            if GlobalVariables.loggedIn == true {
                let user = FetchData(context: managedObjectContext).fetchUserInfo()![0].userName
                
                let cellIndexPath = self.upComingTableView.indexPathForCell(cell)
                let selectedCell = self.upComingTableView.cellForRowAtIndexPath(cellIndexPath!) as! EventTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                
                let addictedEventInfo = FetchData(context: managedObjectContext).fetchAddictionsEvent()
                for addicted in addictedEventInfo!{
                    if addicted.eventID == GlobalVariables.eventSelected {
                        
                        let alertController = UIAlertController(title: "Are you no longer addicted?", message:nil, preferredStyle: .Alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                        let unlikeAction = UIAlertAction(title: "I'm Over It", style: .Default) { (_) -> Void in
                            
                            //Unlike
                            DeleteData(context: self.managedObjectContext).deleteAddictionsEvent(addicted.eventID, deleteUser: GlobalVariables.username)
                            print("Removed from addiction(event) \(addicted.eventID), user \(GlobalVariables.username)")
                            print("REMOVED")
                            
                            let eventService = EventService()
                            eventService.removeAddictedEvents(addicted.eventID) {
                                (let removeInfo ) in
                                print(removeInfo!)
                            }
                            
                            /*
                            //Remove Cell
                            var cellToDelete: AnyObject = cellIndexPath as! AnyObject
                            self.addictionTableView.deleteRowsAtIndexPaths([cellToDelete], withRowAnimation: UITableViewRowAnimation.Fade)
                            */
                            
                            self.upComingTableView.reloadData()
                        }
                        alertController.addAction(unlikeAction)
                        alertController.addAction(cancelAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            } else {
                
                let alert = UIAlertView(title: "Please log in for this!!!", message: nil, delegate: nil, cancelButtonTitle: nil)
                alert.show()
                let delay = 1.0 * Double(NSEC_PER_SEC)
                var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    alert.dismissWithClickedButtonIndex(-1, animated: true)
                })
                
            }
            
        default:
            break
        }
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
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell : SWTableViewCell ) -> Bool {
        return true
    }
    
    //Circ and Rect View changing
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        
        if GlobalVariables.addictedDisplay == "Event"{
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! EventTableViewCell;
            currentCell.tappedView();
            tableView.deselectRowAtIndexPath(indexPath!, animated: false)
            
        }
    }
    
    
    func updateNotificationAddiction(){
        
        self.upComingTableView.reloadData()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
