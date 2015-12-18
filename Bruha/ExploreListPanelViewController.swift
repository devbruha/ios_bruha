//
//  EventFilterPanelViewController.swift
//  Bruha
//
//  Created by lye on 15/7/31.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

class ExploreListPanelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CalendarViewDelegate {
    
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
    @IBOutlet weak var placeholder: UIView!
    
    @IBOutlet weak var eventCategoryTableHeight: NSLayoutConstraint!
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var panelControllerContainer: ARSPContainerController!
    var swipeZoneHeight: CGFloat = 74
    var visibleZoneHeight: CGFloat = 74
    
    var backupEventCategories = [EventObjects(sectionName: "Event Categories", sectionObjectIDs: [], sectionObjects: [])]
    var backupVenueCategories: [String] = ["Venue Categories"]
    var backupOrganizationCategories: [String] = ["Organization Categories"]

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
        
        priceLabelTitle.frame = CGRectMake(10,230, screenSize.width - 20, 30)
        priceLabelTitle.textAlignment = NSTextAlignment.Left
        priceLabelTitle.backgroundColor = UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1)
        priceLabelTitle.textColor = UIColor.whiteColor()
        priceLabelTitle.font = UIFont(name: "OpenSans-Semibold", size: 18)
        priceLabelTitle.text = "   Admission Price"
        self.scrollView.addSubview(priceLabelTitle)
        
        
        priceLabel.frame = CGRectMake(10, 260, screenSize.width - 20, 20)
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
        slider.frame = CGRectMake(10, 280, screenSize.width - 20, 20)
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
        
        let date = NSDate()
        let calendarView = CalendarView.instance(date, selectedDate: date)
        calendarView.delegate = self
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        //calendarView.selectedDate = date
        
        placeholder.addSubview(calendarView)
        placeholder.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
        placeholder.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
        placeholder.hidden = false
        
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
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeEvent", object: self)
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
        Filtering().filterEvents()
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
            
            discoverableButtonIcon.image = UIImage(named: "Venue_Orange")
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.swipeZoneHeight = self.panelControllerContainer.swipableZoneHeight
        self.visibleZoneHeight = self.panelControllerContainer.visibleZoneHeight
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        uiPriceFilter()
        
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
            eventObject = [EventObjects(sectionName: "Event Categories", sectionObjectIDs: [], sectionObjects: [])]
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
        
        GlobalVariables.selectedDisplay = "Discoverable"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeEvent", object: self)
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
        
        cell.textLabel?.text = eventObject[indexPath.section].sectionObjects[indexPath.row]
        cell.textLabel?.tag = Int(eventObject[indexPath.section].sectionObjectIDs[indexPath.row])!
        cell.backgroundColor = UIColor.blackColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel!.font = UIFont(name: cell.textLabel!.font.fontName, size: 18)
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
        
        let selectedCell = self.eventCategoriesTable.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        
        selectedCell.backgroundColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
    
        let headerTitle = eventObject[indexPath.section].sectionName
        
        // Header title is the primary category
        
        let subCategoryID = String(selectedCell.textLabel!.tag)
        let subCategoryName = selectedCell.textLabel!.text!
        
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
        
        let selectedCell = self.eventCategoriesTable.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        
         selectedCell.backgroundColor = UIColor.blackColor()
        
        let headerTitle = eventObject[indexPath.section].sectionName
        
        // Header title is the primary category
        
        let subCategoryID = String(selectedCell.textLabel!.tag)
        let subCategoryName = selectedCell.textLabel!.text!
        
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
            return eventObject[section].sectionObjects.count
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
            headerCell.textLabel?.text = eventObject[section].sectionName
        } else if GlobalVariables.selectedDisplay == "Venue" {
            headerCell.textLabel?.text = venueObject[section]
        } else if GlobalVariables.selectedDisplay == "Organization" {
            headerCell.textLabel?.text = organizationObject[section]
        }
        
        
        let sepFrame = CGRectMake(0,headerCell.frame.size.height-1, headerCell.frame.size.width, 1);
        let seperatorView = UIView(frame: sepFrame)
        seperatorView.backgroundColor = UIColor.whiteColor()
        
        if(section == 0){
            
            headerCell.backgroundColor = UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1)
            headerCell.textLabel!.textColor = UIColor.whiteColor()
            headerCell.detailTextLabel?.text = "\(section)"
            headerCell.textLabel?.font = UIFont(name: "OpenSans-Semibold", size: 18)
        }
        else{
            
            if GlobalVariables.selectedDisplay == "Event" {
                if(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.keys.contains((headerCell.textLabel?.text)!)){
                    headerCell.backgroundColor = UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1.0)
                }
                else{
                    headerCell.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1.0)
                }
                
            } else if GlobalVariables.selectedDisplay == "Venue" {
                
                if(GlobalVariables.UserCustomFilters.categoryFilter.venueCategories.contains((headerCell.textLabel?.text)!)){
                    headerCell.backgroundColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
                }
                else{
                    headerCell.backgroundColor = UIColor.blackColor()
                }
                
            } else if GlobalVariables.selectedDisplay == "Organization" {
                if(GlobalVariables.UserCustomFilters.categoryFilter.organizationCategories.contains((headerCell.textLabel?.text)!)){
                    headerCell.backgroundColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
                }
                else{
                    headerCell.backgroundColor = UIColor.blackColor()
                }
            }
            
            headerCell.textLabel!.textColor = UIColor.whiteColor()
            headerCell.detailTextLabel?.text = "\(section)"
            
            headerCell.addSubview(seperatorView)
        }
        
        headerCell.layer.borderColor = UIColor.whiteColor().CGColor
        headerCell.textLabel!.font = UIFont(name: headerCell.textLabel!.font.fontName, size: 18)
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
        let headerTitle = header.textLabel!.text!
        
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
            placeholder.alpha = 1
            priceLabelTitle.alpha = 1
            priceLabel.alpha = 1
            slider.alpha = 1
        }
        else{
            eventCategoriesTable.alpha = 1;
            placeholder.alpha = 0
            priceLabelTitle.alpha = 0
            priceLabel.alpha = 0
            slider.alpha = 0
        }
        
    }
    
    func adjustHeightOfTableView(uiTableView: UITableView, constraint: NSLayoutConstraint){
        
        let height: CGFloat = uiTableView.contentSize.height
        
        constraint.constant = height
        
        //scrollView.contentSize.height = 500 + constraint.constant
        
        priceLabelTitle.frame = CGRectMake(10, 200 + constraint.constant, UIScreen.mainScreen().bounds.width - 20, 30)
        priceLabel.frame = CGRectMake(10, 230 + constraint.constant, UIScreen.mainScreen().bounds.width - 20, 20)
        slider.frame = CGRectMake(10, 250 + constraint.constant, UIScreen.mainScreen().bounds.width - 20, 20)
        
        if GlobalVariables.selectedDisplay == "Event" {
            scrollView.contentInset.bottom = 100
            clearFilter.frame = CGRectMake(UIScreen.mainScreen().bounds.width * 0.7 - 10, 280 + constraint.constant, UIScreen.mainScreen().bounds.width * 0.3, 30)
        } else {
            scrollView.contentInset.bottom = -150
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
