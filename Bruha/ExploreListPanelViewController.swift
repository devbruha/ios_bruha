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
    @IBOutlet weak var venueSelectedB: UIButton!
    @IBOutlet weak var discoverableSelectedB: UIButton!
    @IBOutlet weak var organizationSelectedB: UIButton!
    
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
    //var backupArtistCategories: [String] = ["Artist Categories"]

    let priceLabelTitle = UILabel()
    let priceLabel = UILabel()
    let slider = UISlider()
    
    struct EventObjects {
        
        var sectionName : String!
        var sectionObjectIDs: [String] = []
        var sectionObjects : [String] = []
    }
    
    var eventObject = [EventObjects()]
    var venueObject = [""]
    var organizationObject = [""]
    //var artistObject = [""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        _ = screenSize.height
        scrollView.contentSize.width = screenWidth
        scrollView.contentSize.height = 500
        
        setupPanel()
        setupCategoryLists()
        
        
        priceLabelTitle.frame = CGRectMake(10,220, screenSize.width - 20, 22)
        priceLabelTitle.textAlignment = NSTextAlignment.Left
        priceLabelTitle.backgroundColor = UIColor.orangeColor()
        priceLabelTitle.textColor = UIColor.whiteColor()
        priceLabelTitle.font = UIFont(name: ".SFUIText-Semibold", size: 18)
        priceLabelTitle.text = "   Admission Price"
        self.scrollView.addSubview(priceLabelTitle)
        
        
        priceLabel.frame = CGRectMake(10, 242, screenSize.width - 20, 22)
        priceLabel.textAlignment = NSTextAlignment.Center
        priceLabel.backgroundColor = UIColor.clearColor()
        priceLabel.textColor = UIColor.whiteColor()
        priceLabel.text = "No Price Filter"
        self.scrollView.addSubview(priceLabel)
        
        
        slider.minimumValue = 0
        slider.maximumValue = 99
        slider.continuous = true
        slider.tintColor = UIColor.whiteColor()
        slider.backgroundColor = UIColor.whiteColor()
        slider.frame = CGRectMake(10, 264, screenSize.width - 20, 22)
        slider.value = 0
        slider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        self.scrollView.addSubview(slider)
        
        
        
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
        
    }
    
    func sliderValueDidChange(sender:UISlider!) {
        
        GlobalVariables.UserCustomFilters.priceFilter = Int(sender.value)
        
        if Int(sender.value) == 0 {
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
        
//        for categories in f.artistCategories {
//            artistObject = ["Artist Categories"]
//            backupArtistCategories.append(categories)
//        }
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.swipeZoneHeight = self.panelControllerContainer.swipableZoneHeight
        self.visibleZoneHeight = self.panelControllerContainer.visibleZoneHeight
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // -------------------------------Onclick Logic-------------------------------
    
    func eventTapped(){
        
        GlobalVariables.selectedDisplay = "Event"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeEvent", object: self)
        clearBackupCategories()
        GlobalVariables.UserCustomFilters.categoryFilter.venueCategories.removeAll()
        GlobalVariables.UserCustomFilters.categoryFilter.organizationCategories.removeAll()
        resetSliderValue()
        
    }
    
    func venueTapped(){
        
        GlobalVariables.selectedDisplay = "Venue"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeEvent", object: self)
        clearBackupCategories()
        GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.removeAll()
        GlobalVariables.UserCustomFilters.categoryFilter.organizationCategories.removeAll()
        resetSliderValue()
        
    }
    
    func discoverableTapped(){
        
        GlobalVariables.selectedDisplay = ""
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeEvent", object: self)
        clearBackupCategories()
        resetSliderValue()
        
    }
    
    func organizationTapped(){
        
        GlobalVariables.selectedDisplay = "Organization"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeEvent", object: self)
        clearBackupCategories()
        GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.removeAll()
        GlobalVariables.UserCustomFilters.categoryFilter.venueCategories.removeAll()
        resetSliderValue()
        
    }
    
    // -------------------------------Category Table Logic-------------------------------
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = eventCategoriesTable.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        
        cell.textLabel?.text = eventObject[indexPath.section].sectionObjects[indexPath.row]
        cell.textLabel?.tag = Int(eventObject[indexPath.section].sectionObjectIDs[indexPath.row])!
        cell.backgroundColor = UIColor.blackColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel!.font = UIFont(name: cell.textLabel!.font.fontName, size: 18)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = self.eventCategoriesTable.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        
        let headerTitle = eventCategoriesTable.headerViewForSection(indexPath.section)?.textLabel!.text!
        
        // Header title is the primary category
        
        let subCategoryID = String(selectedCell.textLabel!.tag)
        let subCategoryName = selectedCell.textLabel!.text!
        
        if GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].contains(subCategoryID){
            
            //Handled in didDeselectRowAtIndexPath
        /*
            let index = GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].indexOf(subCategoryID)
            
            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].removeAtIndex(index!)
            
            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![1].removeAtIndex(index!)
            
            
//            for mValue in GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.values {
//                for value in mValue{
//                    for item in value{
//                        if item == subCategoryID {
//
//                            let index = GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].indexOf(item)
//
//                            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].removeAtIndex(index!)
//
//                            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![1].removeAtIndex(index!)
//
//                        }
//                    }
//                }
//            }
            print("after removed filter \(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories)")
        */
        }
        else{
            
            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].append(subCategoryID)
            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![1].append(subCategoryName)
            print("after added filter \(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories)")
            Filtering().filterEvents()
        }
        
        //print(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.keys.elements)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = self.eventCategoriesTable.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        
        let headerTitle = eventCategoriesTable.headerViewForSection(indexPath.section)?.textLabel!.text!
        
        // Header title is the primary category
        
        let subCategoryID = String(selectedCell.textLabel!.tag)
        let subCategoryName = selectedCell.textLabel!.text!
        
        if GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].contains(subCategoryID){
            
            let index = GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].indexOf(subCategoryID)
            
            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].removeAtIndex(index!)
            
            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![1].removeAtIndex(index!)
            
            print("after removed filter \(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories)")
            
            Filtering().filterEvents()
            
        }
        else{
            
            //Handled in didSelectRowAtIndexPath
            /*
            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].append(subCategoryID)
            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![1].append(subCategoryName)
            print("after added filter \(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories)")
            */
        }
        
        //print(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.keys.elements)
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
        } else if GlobalVariables.selectedDisplay == "Artist" {
//            return artistObject.count
        }
        return 0
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if GlobalVariables.selectedDisplay == "Event" {
            return eventObject[section].sectionName
        } else if GlobalVariables.selectedDisplay == "Venue" {
            return venueObject[section]
        } else if GlobalVariables.selectedDisplay == "Organization" {
            return organizationObject[section]
        } else if GlobalVariables.selectedDisplay == "Artist" {
//            return artistObject[section]
        }
        return "ERROR"
        
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        
        let sepFrame = CGRectMake(0,header.frame.size.height-1, 320, 1);
        let seperatorView = UIView(frame: sepFrame)
        seperatorView.backgroundColor = UIColor.whiteColor()
        
        if(section == 0){
            
            header.backgroundView?.backgroundColor = UIColor.orangeColor()
            
            header.textLabel!.textColor = UIColor.whiteColor()
            header.detailTextLabel!.text = "\(section)"
            
        }
        else{
            
            header.backgroundView?.backgroundColor = UIColor(red: 1.0, green: 0.710, blue: 0.071, alpha: 1.0)
            
            header.textLabel!.textColor = UIColor.whiteColor()
            header.detailTextLabel!.text = "\(section)"
            
            header.addSubview(seperatorView)
        }
        
        header.layer.borderColor = UIColor.whiteColor().CGColor
        header.textLabel!.font = UIFont(name: header.textLabel!.font.fontName, size: 18)
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("sectionTapped:"))
        
        view.addGestureRecognizer(tap)
        
        tableView.allowsMultipleSelection = true
        
        Filtering().filterEvents()
        Filtering().filterVenues()
        Filtering().filterOrganizations()
    }
    
    func sectionTapped(sender: UITapGestureRecognizer){
        
        let header = sender.view as! UITableViewHeaderFooterView
        
        let index = Int(header.detailTextLabel!.text!)
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
            
                GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.removeAll(keepCapacity: false)
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
                
                GlobalVariables.UserCustomFilters.categoryFilter.venueCategories.removeAll(keepCapacity: false)
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
                
                GlobalVariables.UserCustomFilters.categoryFilter.organizationCategories.removeAll(keepCapacity: false)
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
                        
                        eventObject[i].sectionObjects.removeAll(keepCapacity: false)
                    }
                }
//            case "Artist":
//                if (artistObject.count > 1){
//                    artistObject.removeAll(keepCapacity: false)
//                    artistObject.append(backupArtistCategories[0])
//                } else {
//                    artistObject.removeAll(keepCapacity: false)
//                    artistObject = backupArtistCategories
//                }
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
                
            case "Artist":
                break
                
            case "Organization":
                break
                
            case "Venue":
//                if venueObject[index!] == header.textLabel!.text {
//                    
//                    venueObject[index!] = (backupVenueCategories[index!])
//
//                    header.contentView.backgroundColor = UIColor.blueColor()
//                }
//                //header.contentView.backgroundColor = UIColor.blueColor()
                break
                
            default:
                break
            }
        }
        
        
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
        
        scrollView.contentSize.height = 500 + constraint.constant
        
        priceLabelTitle.frame = CGRectMake(10, 198 + constraint.constant, UIScreen.mainScreen().bounds.width - 20, 22)
        priceLabel.frame = CGRectMake(10, 220 + constraint.constant, UIScreen.mainScreen().bounds.width - 20, 22)
        slider.frame = CGRectMake(10, 242 + constraint.constant, UIScreen.mainScreen().bounds.width - 20, 22)
        
        self.view.setNeedsUpdateConstraints()
        
        uiTableView.reloadData()
        
    }
    
    
    func clearBackupCategories() {
        backupEventCategories = [EventObjects(sectionName: "Event Categories", sectionObjectIDs: [], sectionObjects: [])]
        backupVenueCategories = ["Venue Categories"]
        backupOrganizationCategories = ["Organization Categories"]
//        backupArtistCategories = ["Artist Categories"]
        setupCategoryLists()
        eventCategoriesTable.reloadData()
        adjustHeightOfTableView(eventCategoriesTable, constraint: eventCategoryTableHeight)
    }
    
    func resetSliderValue() {
        GlobalVariables.UserCustomFilters.priceFilter = 0
        slider.value = 0
        sliderValueDidChange(slider)
    }
    
    
}
