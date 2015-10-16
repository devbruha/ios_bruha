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
    @IBOutlet weak var artistSelectedB: UIButton!
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
    var backupArtistCategories: [String] = ["Artist Categories"]

    
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
        let screenHeight = screenSize.height
        scrollView.contentSize.width = screenWidth
        scrollView.contentSize.height = 600
        
        setupPanel()
        setupCategoryLists()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationSent", name: "itemDisplayChange", object: nil)
        
        var eventTgr = UITapGestureRecognizer(target: self, action: ("eventTapped"))
        eventSelectedB.addGestureRecognizer(eventTgr)
        
        var venueTgr = UITapGestureRecognizer(target: self, action: ("venueTapped"))
        venueSelectedB.addGestureRecognizer(venueTgr)
        
        var artistTgr = UITapGestureRecognizer(target: self, action: ("artistTapped"))
        artistSelectedB.addGestureRecognizer(artistTgr)
        
        var organizationTgr = UITapGestureRecognizer(target: self, action: ("organizationTapped"))
        organizationSelectedB.addGestureRecognizer(organizationTgr)
        
        let date = NSDate()
        let calendarView = CalendarView.instance(date, selectedDate: date)
        calendarView.delegate = self
        calendarView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        placeholder.addSubview(calendarView)
        placeholder.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[calendarView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["calendarView": calendarView]))
        placeholder.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[calendarView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["calendarView": calendarView]))
        placeholder.hidden = false
        
    }
    func didSelectDate(date: NSDate){
        
        if contains(GlobalVariables.UserCustomFilters.dateFilter, "\(date.year)-\(date.month)-\(date.day)"){
            
            if let index = find(GlobalVariables.UserCustomFilters.dateFilter,"\(date.year)-\(date.month)-\(date.day)"){
                
                GlobalVariables.UserCustomFilters.dateFilter.removeAtIndex(index)
            }
        }
        else{
            
            GlobalVariables.UserCustomFilters.dateFilter.append("\(date.year)-\(date.month)-\(date.day)")
        }
        
        println(GlobalVariables.UserCustomFilters.dateFilter)
    }
    
    func setupCategoryLists(){
        
        self.eventCategoriesTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.eventCategoriesTable.dataSource = self
        
        eventObject = [EventObjects(sectionName: "Event Categories", sectionObjectIDs: [], sectionObjects: [])]
        
        var f = GlobalVariables.categories
        
        for primaryCategory in f.eventCategories.keys{
            
            var newPrimary = EventObjects(sectionName: primaryCategory, sectionObjectIDs: f.eventCategories[primaryCategory]![0], sectionObjects: f.eventCategories[primaryCategory]![1])
            backupEventCategories.append(newPrimary)
        }
        
        for categories in f.artistCategories {
            artistObject = ["Artist Categories"]
            backupArtistCategories.append(categories)
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
        let screenWidth = screenSize.width
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

        
    }
    
    func venueTapped(){
        
        GlobalVariables.selectedDisplay = "Venue"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeEvent", object: self)
        clearBackupCategories()

    }
    
    func artistTapped(){
        
        GlobalVariables.selectedDisplay = "Artist"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeEvent", object: self)
        clearBackupCategories()

    }
    
    func organizationTapped(){
        
        GlobalVariables.selectedDisplay = "Organization"
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChangeEvent", object: self)
        clearBackupCategories()

    }
    
    // -------------------------------Category Table Logic-------------------------------
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = eventCategoriesTable.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell!
        
        cell.textLabel?.text = eventObject[indexPath.section].sectionObjects[indexPath.row]
        cell.textLabel?.tag = eventObject[indexPath.section].sectionObjectIDs[indexPath.row].toInt()!
        cell.backgroundColor = UIColor.blackColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel!.font = UIFont(name: cell.textLabel!.font.fontName, size: 18)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var selectedCell = self.eventCategoriesTable.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        
        var headerTitle = eventCategoriesTable.headerViewForSection(indexPath.section)?.textLabel.text!
        
        GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![0].append("\(selectedCell.textLabel!.tag)")
        GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle!]![1].append("\(selectedCell.textLabel!.text!)")
        
        println(selectedCell.textLabel?.tag)
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
            return artistObject.count
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
            return artistObject[section]
        }
        return "ERROR"

    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        var header = view as! UITableViewHeaderFooterView
        
        var sepFrame = CGRectMake(0,header.frame.size.height-1, 320, 1);
        var seperatorView = UIView(frame: sepFrame)
        seperatorView.backgroundColor = UIColor.whiteColor()
        
        if(section == 0){
            
            header.backgroundView?.backgroundColor = UIColor.orangeColor()
            
            header.textLabel.textColor = UIColor.whiteColor()
            header.detailTextLabel.text = "\(section)"
            
        }
        else{
            
            header.backgroundView?.backgroundColor = UIColor(red: 1.0, green: 0.710, blue: 0.071, alpha: 1.0)
            
            header.textLabel.textColor = UIColor.whiteColor()
            header.detailTextLabel.text = "\(section)"
            
            header.addSubview(seperatorView)
        }
        
        header.layer.borderColor = UIColor.whiteColor().CGColor
        header.textLabel.font = UIFont(name: header.textLabel.font.fontName, size: 18)
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("sectionTapped:"))
        
        view.addGestureRecognizer(tap)
    }
    
    func sectionTapped(sender: UITapGestureRecognizer){
        
        var header = sender.view as! UITableViewHeaderFooterView
        
        var index = header.detailTextLabel.text!.toInt()!
        
        var headerTitle = header.textLabel.text!
        
        
        if(headerTitle != "Event Categories"){
            
            if contains(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.keys, headerTitle){
                
                GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.removeValueForKey(headerTitle)
            }
            else{
                GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[headerTitle] = [[String]]()
            }
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
            case "Artist":
                if (artistObject.count > 1){
                    artistObject.removeAll(keepCapacity: false)
                    artistObject.append(backupArtistCategories[0])
                } else {
                    artistObject.removeAll(keepCapacity: false)
                    artistObject = backupArtistCategories
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
                println("SECTION TAPPED ERROR")
            }
        } else {
            switch (GlobalVariables.selectedDisplay) {
            case "Event":
                if (eventObject[index].sectionObjects.count == 0){
                    
                    eventObject[index].sectionObjects = (backupEventCategories[index].sectionObjects)
                }
                    
                else{
                    
                    eventObject[index].sectionObjects.removeAll(keepCapacity: false)
                }
                
            case "Artist":
                break
                
            case "Organization":
                break
                
            case "Venue":
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
        }
        else{
            eventCategoriesTable.alpha = 1;
        }
        
    }
    
    func adjustHeightOfTableView(uiTableView: UITableView, constraint: NSLayoutConstraint){
        
        var height: CGFloat = uiTableView.contentSize.height
        
        constraint.constant = height
        
        scrollView.contentSize.height = 500 + constraint.constant
        
        self.view.setNeedsUpdateConstraints()
        
        uiTableView.reloadData()
        
    }
    
    
    func clearBackupCategories() {
        backupEventCategories = [EventObjects(sectionName: "Event Categories", sectionObjectIDs: [], sectionObjects: [])]
        backupVenueCategories = ["Venue Categories"]
        backupOrganizationCategories = ["Organization Categories"]
        backupArtistCategories = ["Artist Categories"]
        setupCategoryLists()
        eventCategoriesTable.reloadData()
        adjustHeightOfTableView(eventCategoriesTable, constraint: eventCategoryTableHeight)
    }

    
}
