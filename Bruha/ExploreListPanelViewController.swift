//
//  EventFilterPanelViewController.swift
//  Bruha
//
//  Created by lye on 15/7/31.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit
import Foundation

class ExploreListPanelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, JTCalendarDelegate{
    
    @IBOutlet weak var eventSelectedB: UIButton!
    @IBOutlet weak var eventButtonIcon: UIImageView!
    @IBOutlet weak var venueSelectedB: UIButton!
    @IBOutlet weak var venueButtonIcon: UIImageView!
    @IBOutlet weak var discoverableSelectedB: UIButton!
    @IBOutlet weak var discoverableButtonIcon: UIImageView!
    @IBOutlet weak var organizationSelectedB: UIButton!
    @IBOutlet weak var organizationButtonIcon: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var eventCategoriesTable: UITableView!
    
    @IBOutlet weak var eventCategoryTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var calendarMenu: JTCalendarMenuView!
    @IBOutlet weak var calendarContentView: JTHorizontalCalendarView!
    
    

    
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var panelControllerContainer: ARSPContainerController!
    var swipeZoneHeight: CGFloat = 74
    var visibleZoneHeight: CGFloat = 74
    
    var backupEventCategories = [EventObjects(sectionName: "Event Categories", sectionObjectIDs: [], sectionObjects: [])]
    var backupVenueCategories: [String] = ["Venue Categories"]
    var backupOrganizationCategories: [String] = ["Organization Categories"]
    //Calendar
    let calendarManager: JTCalendarManager = JTCalendarManager()
    //let GlobalVariables.datesSelected = NSMutableArray()


    let priceLabelTitle = UILabel()
    let priceLabel = UILabel()
    let slider = UISlider()
    let clearFilter = UIButton()
    
    struct EventObjects {
        
        var sectionName : String!
        var sectionObjectIDs: [String] = []
        var sectionObjects : [String] = []
    }
    
    var eventObject = [EventObjects()]
    var venueObject = [""]
    var organizationObject = [""]
    var artistObject = [""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        _ = screenSize.height
        scrollView.contentSize.width = screenWidth
        scrollView.contentSize.height = 500
        
        setupPanel()
        setupCategoryLists()
        setupEVOD()
        
        let nib = UINib(nibName: "CategoryHeaderCellTableViewCell", bundle: nil)
        eventCategoriesTable.registerNib(nib, forCellReuseIdentifier: "HeaderCell")
        
        priceLabelTitle.frame = CGRectMake(10,330, screenSize.width - 20, 30)
        priceLabelTitle.textAlignment = NSTextAlignment.Left
        priceLabelTitle.backgroundColor = UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1)
        priceLabelTitle.textColor = UIColor.whiteColor()
        priceLabelTitle.font = UIFont(name: "OpenSans-Semibold", size: 18)
        priceLabelTitle.text = "   Admission Price"
        self.scrollView.addSubview(priceLabelTitle)
        
        
        priceLabel.frame = CGRectMake(10, 360, screenSize.width - 20, 20)
        priceLabel.textAlignment = NSTextAlignment.Center
        priceLabel.backgroundColor = UIColor.clearColor()
        priceLabel.textColor = UIColor.whiteColor()
        priceLabel.text = "No Price Filter"
        self.scrollView.addSubview(priceLabel)
        
        
        slider.minimumValue = -1
        slider.maximumValue = 99
        slider.continuous = true
        slider.tintColor = UIColor.whiteColor()
        slider.backgroundColor = UIColor.whiteColor()
        slider.frame = CGRectMake(10, 380, screenSize.width - 20, 20)
        slider.value = -1
        slider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        self.scrollView.addSubview(slider)
        
        
        //clearFilter.frame = CGRectMake(10, 300, screenSize.width - 20, 30)
        clearFilter.setTitle("Clear Filter", forState: UIControlState.Normal)
        clearFilter.backgroundColor = UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1)
        clearFilter.addTarget(self, action: "clearFilters:", forControlEvents: UIControlEvents.TouchUpInside)
        self.scrollView.addSubview(clearFilter)
        
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationSent", name: "itemDisplayChangeEvent", object: nil)
        
        let eventTgr = UITapGestureRecognizer(target: self, action: ("eventTapped"))
        eventSelectedB.addGestureRecognizer(eventTgr)
        
        let venueTgr = UITapGestureRecognizer(target: self, action: ("venueTapped"))
        venueSelectedB.addGestureRecognizer(venueTgr)
        
        let discoverableTgr = UITapGestureRecognizer(target: self, action: ("discoverableTapped"))
        discoverableSelectedB.addGestureRecognizer(discoverableTgr)
        
        let organizationTgr = UITapGestureRecognizer(target: self, action: ("organizationTapped"))
        organizationSelectedB.addGestureRecognizer(organizationTgr)
        
        calendarManager.delegate = self
        
        calendarMenu.backgroundColor = UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1)
        calendarContentView.layer.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1).CGColor
        
        calendarManager.menuView = calendarMenu
        calendarManager.contentView = calendarContentView
        
        if GlobalVariables.datesSelected.count != 0 {
            calendarManager.setDate(GlobalVariables.datesSelected.lastObject as! NSDate)
        } else {
            calendarManager.setDate(NSDate())
        }
        
        switch(GlobalVariables.selectedDisplay){
            
        case "Event":
            eventTapped()
            
        case "Venue":
            venueTapped()
            
        case "Organization":
            organizationTapped()
            
        default:
            eventTapped()
        }
    }
    
    func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        
        let newDayView = dayView as! JTCalendarDayView
        
        
        newDayView.hidden = false
        newDayView.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
        newDayView.textLabel.textColor = UIColor.whiteColor()
        
        newDayView.layer.borderColor = UIColor.grayColor().CGColor
        newDayView.layer.borderWidth = 0.5
        newDayView.circleView.hidden = true
        
        
        if(newDayView.isFromAnotherMonth){
            newDayView.removeFromSuperview()
        }
        else if(GlobalVariables.datesSelected.containsObject(newDayView.date)){
            newDayView.backgroundColor = UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1)
        }
        
        if calendarManager.dateHelper.date(NSDate(), isTheSameDayThan: newDayView.date){
            
            newDayView.circleView.backgroundColor = UIColor.clearColor()
            newDayView.circleView.layer.borderWidth = 1
            newDayView.circleView.layer.borderColor = UIColor.whiteColor().CGColor
            newDayView.circleView.hidden = false
        }
    }
    
    func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        
        let newDayView = dayView as! JTCalendarDayView
        
        if(GlobalVariables.datesSelected.containsObject(newDayView.date)){
            
            GlobalVariables.datesSelected.removeObject(newDayView.date)
            newDayView.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateToRemove = dateFormatter.stringFromDate(newDayView.date)
            
            if let index = GlobalVariables.UserCustomFilters.dateFilter.indexOf("\(dateToRemove)"){
                
                GlobalVariables.UserCustomFilters.dateFilter.removeAtIndex(index)
            }
            
        }
        else{
            GlobalVariables.datesSelected.addObject(newDayView.date)
            newDayView.backgroundColor = UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateToStore = dateFormatter.stringFromDate(newDayView.date)
            
            GlobalVariables.UserCustomFilters.dateFilter.append("\(dateToStore)")
            
        }
        print(GlobalVariables.UserCustomFilters.dateFilter)
        Filtering().filterEvents()
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
        newMenuItemView.text = "<                 " + monthSymbol + " " + String(component) + "                 >"
        //newMenuItemView.text = monthSymbol
        //newMenuItemView.backgroundColor = UIColor.cyanColor()
        newMenuItemView.textColor = UIColor.whiteColor()
        //newMenuItemView.scrollView
        
    }
    
    func clearFilters(sender: UIButton) {
        
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = NSNumber(float: 0.7)
        pulseAnimation.toValue = NSNumber(float: 1.0)
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = false
        pulseAnimation.repeatCount = 1  //FLT_MAX
        sender.layer.addAnimation(pulseAnimation, forKey: nil)
        
        Filtering().clearFilter()
        resetSliderValue()
        GlobalVariables.datesSelected.removeAllObjects()
        calendarManager.reload()
        switch(GlobalVariables.selectedDisplay){
            
        case "Event":
            eventTapped()
            
        case "Venue":
            venueTapped()
            
        case "Organization":
            organizationTapped()
            
        default:
            eventTapped()
        }
    }
    
    func sliderValueDidChange(sender:UISlider!) {
        
        GlobalVariables.UserCustomFilters.priceFilter = Int(sender.value)
        
        if Int(sender.value) == 0 {
            priceLabel.text = "Free"
        } else if Int(sender.value) == -1 {
            priceLabel.text = "No Price Filter"
        } else {
            priceLabel.text = "\(Int(sender.value))$"
        }
        
        print(GlobalVariables.UserCustomFilters.priceFilter)
        
        Filtering().filterEvents()
    }
    
    func didSelectDate(date: NSDate){
        /*
        var mDay = String(date.day)
        var mMonth = String(date.month)
        
        if date.day < 10 {
            mDay = "0\(date.day)"
        }
        
        if date.month < 10 {
            mMonth = "0\(date.month)"
        }
        print(mMonth)
        
        if GlobalVariables.UserCustomFilters.dateFilter.contains("\(date.year)-\(mMonth)-\(mDay)"){
            
            if let index = GlobalVariables.UserCustomFilters.dateFilter.indexOf("\(date.year)-\(mMonth)-\(mDay)"){
                
                GlobalVariables.UserCustomFilters.dateFilter.removeAtIndex(index)
            }
        }
        else{
            
            GlobalVariables.UserCustomFilters.dateFilter.append("\(date.year)-\(mMonth)-\(mDay)")
        }
        
        print(GlobalVariables.UserCustomFilters.dateFilter)
        Filtering().filterEvents()*/
    }
    
    func setupCategoryLists(){
        
        self.eventCategoriesTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.eventCategoriesTable.dataSource = self
        
        eventObject = [EventObjects(sectionName: "Event Categories", sectionObjectIDs: [], sectionObjects: [])]
        
        var f = GlobalVariables.categories
        
        for primaryCategory in f.eventCategories.keys{
            
            let newPrimary = EventObjects(sectionName: primaryCategory, sectionObjectIDs: f.eventCategories[primaryCategory]![0], sectionObjects: f.eventCategories[primaryCategory]![1])
            backupEventCategories.append(newPrimary)
        }
        
        for categories in f.organizationCategories {
            organizationObject = ["Organization Categories"]
            backupOrganizationCategories.append(categories)
        }
        
        for categories in f.venueCategories {
            venueObject = ["Venue Categories"]
            backupVenueCategories.append(categories)
        }
    }
    
    func setupPanel(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        _ = screenSize.width
        let screenHeight = screenSize.height
        
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        panelControllerContainer.visibleZoneHeight = visibleZoneHeight
        panelControllerContainer.shouldOverlapMainViewController = true
        panelControllerContainer.maxPanelHeight = screenHeight*0.66
    }
    
    func setupEVOD() {
        
        eventButtonIcon.contentMode = UIViewContentMode.ScaleAspectFit
        eventButtonIcon.image = UIImage(named: "Events_White")
        eventSelectedB.setTitle("Event", forState: UIControlState.Normal)
        eventSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        eventSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        eventSelectedB.layer.borderWidth = CGFloat(1.5)
        //eventSelectedB.titleEdgeInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        
        venueButtonIcon.contentMode = UIViewContentMode.ScaleAspectFit
        venueButtonIcon.image = UIImage(named: "Venue_White")
        venueSelectedB.setTitle("Venue", forState: UIControlState.Normal)
        venueSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        venueSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        venueSelectedB.layer.borderWidth = CGFloat(1.5)
        
        organizationButtonIcon.contentMode = UIViewContentMode.ScaleAspectFit
        organizationButtonIcon.image = UIImage(named: "Organization_White")
        organizationSelectedB.setTitle("Organization", forState: UIControlState.Normal)
        organizationSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        organizationSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        organizationSelectedB.layer.borderWidth = CGFloat(1.5)
        
        discoverableButtonIcon.contentMode = UIViewContentMode.ScaleAspectFit
        discoverableButtonIcon.image = UIImage(named: "Bruha_White")
        discoverableSelectedB.setTitle("Discoverable", forState: UIControlState.Normal)
        discoverableSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        discoverableSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        discoverableSelectedB.layer.borderWidth = CGFloat(1.5)
    
    }
    
    func updateEVOD() {
        
        eventButtonIcon.image = UIImage(named: "Events_White")
        eventSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        eventSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        
        venueButtonIcon.image = UIImage(named: "Venue_White")
        venueSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        venueSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        
        organizationButtonIcon.image = UIImage(named: "Organization_White")
        organizationSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        organizationSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        
        discoverableButtonIcon.image = UIImage(named: "Bruha_White")
        discoverableSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        discoverableSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        
        switch(GlobalVariables.selectedDisplay){
            
        case "Event":
            
            eventButtonIcon.image = UIImage(named: "Events_Orange")
            eventSelectedB.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            eventSelectedB.layer.borderColor = UIColor.orangeColor().CGColor
            
        case "Venue":
            
            venueButtonIcon.image = UIImage(named: "Venue_Orange")
            venueSelectedB.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            venueSelectedB.layer.borderColor = UIColor.orangeColor().CGColor
            
        case "Organization":
            
            organizationButtonIcon.image = UIImage(named: "Organization_Orange")
            organizationSelectedB.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            organizationSelectedB.layer.borderColor = UIColor.orangeColor().CGColor
            
        case "Discoverable":
            
            discoverableButtonIcon.image = UIImage(named: "Bruha_White")
            discoverableSelectedB.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            discoverableSelectedB.layer.borderColor = UIColor.orangeColor().CGColor
            
        default:
            
            eventButtonIcon.image = UIImage(named: "Events_White")
            eventSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            eventSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
            
            venueButtonIcon.image = UIImage(named: "Venue_White")
            venueSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            venueSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
            
            organizationButtonIcon.image = UIImage(named: "Organization_White")
            organizationSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            organizationSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
            
            discoverableButtonIcon.image = UIImage(named: "Bruha_White")
            discoverableSelectedB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            discoverableSelectedB.layer.borderColor = UIColor.whiteColor().CGColor
        }
        
    }
    
    func animatePanelJump() {
        self.view.center.y = self.view.center.y - 5
        
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: CGFloat(1), initialSpringVelocity: CGFloat(1), options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            self.view.center.y = self.view.center.y + 5
            }) { (finished) -> Void in
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.swipeZoneHeight = self.panelControllerContainer.swipableZoneHeight
        self.visibleZoneHeight = self.panelControllerContainer.visibleZoneHeight
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        uiPriceFilter()
        animatePanelJump()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // -------------------------------Onclick Logic-------------------------------
    
    func eventTapped(){
        
        GlobalVariables.selectedDisplay = "Event"
        
        if(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.keys.count > 0){
            
            eventObject.removeAll(keepCapacity: false)
            
            for category in backupEventCategories{
                
                var temp = category
                
                if(category.sectionName != "Event Categories"){
                    
                    if(!GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.keys.contains(category.sectionName)){
                        //temp.sectionObjectIDs = []
                        temp.sectionObjects = []
                    }
                }
                
                eventObject.append(temp)
            }
        }
        else{
            //eventObject = [EventObjects(sectionName: "Event Categories", sectionObjectIDs: [], sectionObjects: [])]
            
            eventObject.removeAll(keepCapacity: false)
            eventObject = (backupEventCategories)
            
            for(var i = 0 ; i < eventObject.count ; ++i){
                
                eventObject[i].sectionObjects.removeAll(keepCapacity: false)
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeEvent", object: self)
        //clearBackupCategories()
        //resetSliderValue()
        updateEVOD()
        eventCategoriesTable.reloadData()
        adjustHeightOfTableView(eventCategoriesTable, constraint: eventCategoryTableHeight)
        updateNotificationSent()
        
    }
    
    func venueTapped(){
        
        GlobalVariables.selectedDisplay = "Venue"
        
        venueObject = backupVenueCategories
//        if(GlobalVariables.UserCustomFilters.categoryFilter.venueCategories.count != 0){
//            venueObject = backupVenueCategories
//        }
//        else{
//            venueObject = ["Venue Categories"]
//        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeEvent", object: self)
        //clearBackupCategories()
        //resetSliderValue()
        updateEVOD()
        eventCategoriesTable.reloadData()
        adjustHeightOfTableView(eventCategoriesTable, constraint: eventCategoryTableHeight)
        updateNotificationSent()
    }
    
    func discoverableTapped(){
        
//        GlobalVariables.selectedDisplay = "Discoverable"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeEvent", object: self)
        
        let alert = UIAlertView(title: "Discoverable Coming Soon", message: nil, delegate: nil, cancelButtonTitle: nil)
        alert.show()
        let delay = 1.5 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissWithClickedButtonIndex(-1, animated: true)
        })
        
        updateEVOD()
    }
    
    func organizationTapped(){
        
        GlobalVariables.selectedDisplay = "Organization"
        
        organizationObject = backupOrganizationCategories
//        if(GlobalVariables.UserCustomFilters.categoryFilter.organizationCategories.count != 0){
//            organizationObject = backupOrganizationCategories
//        }
//        else{
//            organizationObject = ["Organization Categories"]
//        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeEvent", object: self)
        //clearBackupCategories()
        //resetSliderValue()
        updateEVOD()
        eventCategoriesTable.reloadData()
        adjustHeightOfTableView(eventCategoriesTable, constraint: eventCategoryTableHeight)
        updateNotificationSent()
    }
    
    // -------------------------------Category Table Logic-------------------------------
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = NSBundle.mainBundle().loadNibNamed("CategoryHeaderCellTableViewCell", owner: self, options: nil)[0] as! CategoryHeaderCellTableViewCell
        
        cell.categoryName?.text = eventObject[indexPath.section].sectionObjects[indexPath.row]
        cell.categoryName?.tag = Int(eventObject[indexPath.section].sectionObjectIDs[indexPath.row])!
        cell.backgroundColor = UIColor.blackColor()
        cell.categoryName?.textColor = UIColor.whiteColor()
        cell.categoryName!.font = UIFont(name: cell.textLabel!.font.fontName, size: 18)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        //print(cell.textLabel!.font.fontName)
        if(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.keys.contains(eventObject[indexPath.section].sectionName)){
            
            if(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[eventObject[indexPath.section].sectionName]![0].contains(eventObject[indexPath.section].sectionObjectIDs[indexPath.row])){
                
                cell.backgroundColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = self.eventCategoriesTable.cellForRowAtIndexPath(indexPath) as! CategoryHeaderCellTableViewCell!
        
        selectedCell.backgroundColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
    
        let headerTitle = eventObject[indexPath.section].sectionName
        
        // Header title is the primary category
        
        let subCategoryID = String(selectedCell.categoryName!.tag)
        let subCategoryName = selectedCell.categoryName!.text!
        
        if GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].contains(subCategoryID){
            
            selectedCell.backgroundColor = UIColor.blackColor()
            
            //Handled in didDeselectRowAtIndexPath
        
            let index = GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].indexOf(subCategoryID)
            
            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].removeAtIndex(index!)
            
            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![1].removeAtIndex(index!)
            
            print("after removed filter \(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories)")
        
        }
        else{
            
            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].append(subCategoryID)
            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![1].append(subCategoryName)
            print("after added filter \(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories)")
        }
        
        Filtering().filterEvents()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = self.eventCategoriesTable.cellForRowAtIndexPath(indexPath) as! CategoryHeaderCellTableViewCell!
        
         selectedCell.backgroundColor = UIColor.blackColor()
        
        let headerTitle = eventObject[indexPath.section].sectionName
        
        // Header title is the primary category
        
        let subCategoryID = String(selectedCell.categoryName!.tag)
        let subCategoryName = selectedCell.categoryName!.text!
        
        if GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].contains(subCategoryID){
            
            let index = GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].indexOf(subCategoryID)
            
            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].removeAtIndex(index!)
            
            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![1].removeAtIndex(index!)
            
            print("after removed filter \(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories)")
        }
        else{
            
            selectedCell.backgroundColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
            
            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].append(subCategoryID)
            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![1].append(subCategoryName)
            print("after added filter \(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories)")
        }
        
        Filtering().filterEvents()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if GlobalVariables.selectedDisplay == "Event" {
            return 0
            //return eventObject[section].sectionObjects.count
        }
        else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if GlobalVariables.selectedDisplay == "Event" {
            return eventObject.count
        } else if GlobalVariables.selectedDisplay == "Venue" {
            return venueObject.count
        } else if GlobalVariables.selectedDisplay == "Organization" {
            return organizationObject.count
        }
        return 0
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! CategoryHeaderCellTableViewCell
        
        if GlobalVariables.selectedDisplay == "Event" {
            headerCell.categoryName.text = eventObject[section].sectionName
        } else if GlobalVariables.selectedDisplay == "Venue" {
            headerCell.categoryName.text = venueObject[section]
        } else if GlobalVariables.selectedDisplay == "Organization" {
            headerCell.categoryName.text = organizationObject[section]
        }
        
        
        let sepFrame = CGRectMake(0,headerCell.frame.size.height-1, headerCell.frame.size.width, 1);
        let seperatorView = UIView(frame: sepFrame)
        seperatorView.backgroundColor = UIColor.whiteColor()
        
        if(section == 0){
            
            headerCell.backgroundColor = UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1)
            headerCell.categoryName!.textColor = UIColor.whiteColor()
            headerCell.detailTextLabel?.text = "\(section)"
            headerCell.categoryName?.font = UIFont(name: "OpenSans-Semibold", size: 18)
            
            headerCell.categoryImage.image = UIImage(named: "arrow-down")
            
        }
        else{
            
            if GlobalVariables.selectedDisplay == "Event" {
                
                headerCell.categoryImage.image = UIImage(named: eventObject[section].sectionName)
                
                if(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.keys.contains((headerCell.categoryName?.text)!)){
                    headerCell.backgroundColor = UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1.0)
                    //headerCell.arrowimage.image = UIImage(named: "arrow-down")
                }
                else{
                    headerCell.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1.0)
                    //headerCell.arrowimage.image = UIImage(named: "arrow-up")
                }
                
            } else if GlobalVariables.selectedDisplay == "Venue" {
                
                headerCell.categoryImage.image = UIImage(named: venueObject[section])
                
                if(GlobalVariables.UserCustomFilters.categoryFilter.venueCategories.contains((headerCell.categoryName?.text)!)){
                    headerCell.backgroundColor = UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1)
                }
                else{
                    headerCell.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1.0)
                }
                
            } else if GlobalVariables.selectedDisplay == "Organization" {
                
                headerCell.categoryImage.image = UIImage(named: organizationObject[section])
                
                if(GlobalVariables.UserCustomFilters.categoryFilter.organizationCategories.contains((headerCell.categoryName?.text)!)){
                    headerCell.backgroundColor = UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1)
                }
                else{
                    headerCell.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1.0)
                }
            }
            
            headerCell.categoryName!.textColor = UIColor.whiteColor()
            headerCell.detailTextLabel?.text = "\(section)"
            
            headerCell.addSubview(seperatorView)
        }
        
        headerCell.layer.borderColor = UIColor.whiteColor().CGColor
        headerCell.categoryName!.font = UIFont(name: headerCell.textLabel!.font.fontName, size: 18)
        //print(headerCell.textLabel!.font.fontName)
        // Send section
        headerCell.headerCellSection = section
        
        // Add gesture
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: "sectionTapped:")
        headerCell.addGestureRecognizer(headerTapGesture)
        
        tableView.allowsMultipleSelection = true
        
        return headerCell
    }
    
    func sectionTapped(sender: UITapGestureRecognizer){
        
        let header = sender.view as! CategoryHeaderCellTableViewCell
        
        let index = header.headerCellSection
        let headerTitle = header.categoryName.text!
        
        switch (GlobalVariables.selectedDisplay) {
            
        case "Event":
            if(headerTitle != "Event Categories"){
            
                if GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.keys.contains(headerTitle){
                
                    GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.removeValueForKey(headerTitle)
                }
                else{
                    GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle] = [[String]]()
                    GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle] = [[],[]]
                }
            }
            else{
            
            }
            print(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories)
        
        case "Venue":
            if(headerTitle != "Venue Categories"){
                
                if GlobalVariables.UserCustomFilters.categoryFilter.venueCategories.contains(headerTitle){
                    
                    let idx = GlobalVariables.UserCustomFilters.categoryFilter.venueCategories.indexOf(headerTitle)
                    GlobalVariables.UserCustomFilters.categoryFilter.venueCategories.removeAtIndex(idx!)
                }
                else{
                    GlobalVariables.UserCustomFilters.categoryFilter.venueCategories.append(headerTitle)
                }
            }
            else{
                
            }
            print(GlobalVariables.UserCustomFilters.categoryFilter.venueCategories)
            
        case "Organization":
            if(headerTitle != "Organization Categories"){
                
                if GlobalVariables.UserCustomFilters.categoryFilter.organizationCategories.contains(headerTitle){
                    
                    let idx = GlobalVariables.UserCustomFilters.categoryFilter.organizationCategories.indexOf(headerTitle)
                    GlobalVariables.UserCustomFilters.categoryFilter.organizationCategories.removeAtIndex(idx!)
                }
                else{
                    GlobalVariables.UserCustomFilters.categoryFilter.organizationCategories.append(headerTitle)
                }
            }
            else{
                
            }
            print(GlobalVariables.UserCustomFilters.categoryFilter.organizationCategories)
            
        default:
            break
        }
    
    
        if(index == 0){
            switch (GlobalVariables.selectedDisplay) {
            case "Event":
                if(eventObject.count > 1){
                    
                    eventObject.removeAll(keepCapacity: false)
                    eventObject.append(backupEventCategories[0])
                }
                else{
                    
                    eventObject.removeAll(keepCapacity: false)
                    eventObject = (backupEventCategories)
                    
                    for(var i = 0 ; i < eventObject.count ; ++i){
                        
                        if(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.keys.contains(eventObject[i].sectionName)){
                            
                        }
                        else{
                            eventObject[i].sectionObjects.removeAll(keepCapacity: false)
                        }
                    }
                }
            case "Organization":
                if (organizationObject.count > 1){
                    organizationObject.removeAll(keepCapacity: false)
                    organizationObject.append(backupOrganizationCategories[0])
                } else {
                    organizationObject.removeAll(keepCapacity: false)
                    organizationObject = backupOrganizationCategories
                }
            case "Venue":
                if (venueObject.count > 1){
                    venueObject.removeAll(keepCapacity: false)
                    venueObject.append(backupVenueCategories[0])
                } else {
                    venueObject.removeAll(keepCapacity: false)
                    venueObject = backupVenueCategories
                }
            default:
                print("SECTION TAPPED ERROR")
            }
            
        } else {
            
            switch (GlobalVariables.selectedDisplay) {
            case "Event":
                if (eventObject[index!].sectionObjects.count == 0){
                    
                    eventObject[index!].sectionObjects = (backupEventCategories[index!].sectionObjects)
                }
                    
                else{
                    
                    eventObject[index!].sectionObjects.removeAll(keepCapacity: false)
                }
            case "Organization":
                
                break
                
            case "Venue":
                
                break
                
            default:
                break
            }
        }
        
        Filtering().filterEvents()
        Filtering().filterVenues()
        Filtering().filterOrganizations()
        
        eventCategoriesTable.reloadData()
        
        adjustHeightOfTableView(self.eventCategoriesTable, constraint: self.eventCategoryTableHeight)
    }
    
    
    func updateNotificationSent(){
        
        if(GlobalVariables.selectedDisplay == "Event"){
            eventCategoriesTable.alpha = 1;
            calendarMenu.alpha = 1
            calendarContentView.alpha = 1
            priceLabelTitle.alpha = 1
            priceLabel.alpha = 1
            slider.alpha = 1
        }
        else{
            eventCategoriesTable.alpha = 1;
            calendarMenu.alpha = 0
            calendarContentView.alpha = 0
            priceLabelTitle.alpha = 0
            priceLabel.alpha = 0
            slider.alpha = 0
        }
        
    }
    
    func adjustHeightOfTableView(uiTableView: UITableView, constraint: NSLayoutConstraint){
        
        let height: CGFloat = uiTableView.contentSize.height
        
        constraint.constant = height
        
        //scrollView.contentSize.height = 500 + constraint.constant
        
        priceLabelTitle.frame = CGRectMake(10, 320 + constraint.constant, UIScreen.mainScreen().bounds.width - 20, 30)
        priceLabel.frame = CGRectMake(10, 350 + constraint.constant, UIScreen.mainScreen().bounds.width - 20, 20)
        slider.frame = CGRectMake(10, 370 + constraint.constant, UIScreen.mainScreen().bounds.width - 20, 20)
        
        if GlobalVariables.selectedDisplay == "Event" {
            scrollView.contentInset.bottom = 110
            clearFilter.frame = CGRectMake(UIScreen.mainScreen().bounds.width * 0.7 - 10, 400 + constraint.constant, UIScreen.mainScreen().bounds.width * 0.3, 30)
        } else {
            scrollView.contentInset.bottom = -270
            clearFilter.frame = CGRectMake(UIScreen.mainScreen().bounds.width * 0.7 - 10, 20 + constraint.constant, UIScreen.mainScreen().bounds.width * 0.3, 30)
        }
        
        
        self.view.setNeedsUpdateConstraints()
        
        uiTableView.reloadData()
        
    }
    
    
    func clearBackupCategories() {
        backupEventCategories = [EventObjects(sectionName: "Event Categories", sectionObjectIDs: [], sectionObjects: [])]
        backupVenueCategories = ["Venue Categories"]
        backupOrganizationCategories = ["Organization Categories"]
        setupCategoryLists()
        eventCategoriesTable.reloadData()
        adjustHeightOfTableView(eventCategoriesTable, constraint: eventCategoryTableHeight)
    }
    
    func resetSliderValue() {
        GlobalVariables.UserCustomFilters.priceFilter = -1
        slider.value = -1
        sliderValueDidChange(slider)
    }
    
    //MARK: Load Custom UI Selection
    func uiPriceFilter() {
        
        // Price Filter
        slider.value = Float(GlobalVariables.UserCustomFilters.priceFilter)
        if GlobalVariables.UserCustomFilters.priceFilter == 0 {
            priceLabel.text = "Free"
        } else if GlobalVariables.UserCustomFilters.priceFilter == -1 {
            priceLabel.text = "No Price Filter"
        } else {
            priceLabel.text = "\(GlobalVariables.UserCustomFilters.priceFilter)$"
        }
        
        /* //the NSDate is get only
        // Date Filter
        let filterDate: NSDate
        for date in GlobalVariables.UserCustomFilters.dateFilter {
        print("DDDddDD------------------------", date)
        let dateArray = date.componentsSeparatedByString("-")
        filterDate.day = dateArray[2]
        }
        //didSelectDate(<#T##date: NSDate##NSDate#>)*/
        
        
        // Category filter
    }
    

}
