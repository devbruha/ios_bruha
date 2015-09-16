//
//  EventFilterPanelViewController.swift
//  Bruha
//
//  Created by lye on 15/7/31.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

class ExploreListPanelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var eventSelectedB: UIButton!
    @IBOutlet weak var venueSelectedB: UIButton!
    @IBOutlet weak var artistSelectedB: UIButton!
    @IBOutlet weak var organizationSelectedB: UIButton!
    
    @IBOutlet weak var eventCategoriesTable: UITableView!
    @IBOutlet weak var eventCategoryHeightConstraint: NSLayoutConstraint!
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var panelControllerContainer: ARSPContainerController!
    var swipeZoneHeight: CGFloat = 74
    var visibleZoneHeight: CGFloat = 74
    
    var backupPrimary = [Objects(sectionName: "Event Categories", sectionObjects: []),Objects(sectionName: "Arts", sectionObjects: ["1", "2", "3"]),Objects(sectionName: "Business", sectionObjects: ["1", "2", "3"]),Objects(sectionName: "Ceremony", sectionObjects: ["1", "2", "3"]),Objects(sectionName: "Club", sectionObjects: ["1", "2", "3"]),Objects(sectionName: "Comedy", sectionObjects: ["1", "2", "3"]),Objects(sectionName: "Fashion", sectionObjects: ["1", "2", "3"]),Objects(sectionName: "Festivals", sectionObjects: ["1", "2", "3"])]
    
    struct Objects {
        
        var sectionName : String!
        var sectionObjects : [String] = []
    }
    
    var eventObject = [Objects()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //eventCategoriesTable.
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        panelControllerContainer.visibleZoneHeight = visibleZoneHeight
        panelControllerContainer.shouldOverlapMainViewController = true
        panelControllerContainer.maxPanelHeight = screenHeight*0.66
        
        self.eventCategoriesTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.eventCategoriesTable.dataSource = self
        
        eventObject = [Objects(sectionName: "Event Categories", sectionObjects: [])]
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationSent", name: "itemDisplayChange", object: nil)
        
        var f = FetchData(context: managedObjectContext).fetchCategories()
        
        var eventTgr = UITapGestureRecognizer(target: self, action: ("eventTapped"))
        eventSelectedB.addGestureRecognizer(eventTgr)

        var venueTgr = UITapGestureRecognizer(target: self, action: ("venueTapped"))
        venueSelectedB.addGestureRecognizer(venueTgr)
        
        var artistTgr = UITapGestureRecognizer(target: self, action: ("artistTapped"))
        artistSelectedB.addGestureRecognizer(artistTgr)
        
        var organizationTgr = UITapGestureRecognizer(target: self, action: ("organizationTapped"))
        organizationSelectedB.addGestureRecognizer(organizationTgr)
    
    }
    
    func updateNotificationSent(){
        
        if(GlobalVariables.selectedDisplay == "Event"){
            eventCategoriesTable.alpha = 1;
        }
        else{
            eventCategoriesTable.alpha = 0;
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.swipeZoneHeight = self.panelControllerContainer.swipableZoneHeight
        self.visibleZoneHeight = self.panelControllerContainer.visibleZoneHeight
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func eventTapped(){
        
        GlobalVariables.selectedDisplay = "Event"
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
        
    }
    
    func venueTapped(){
        
        GlobalVariables.selectedDisplay = "Venue"
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
    }
    
    func artistTapped(){
        
        GlobalVariables.selectedDisplay = "Artist"
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
    }
    
    func organizationTapped(){
        
        GlobalVariables.selectedDisplay = "Organization"
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = eventCategoriesTable.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell!
        
        cell.textLabel?.text = eventObject[indexPath.section].sectionObjects[indexPath.row]
        cell.backgroundColor = UIColor.blackColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel!.font = UIFont(name: cell.textLabel!.font.fontName, size: 18)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eventObject[section].sectionObjects.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return eventObject.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return eventObject[section].sectionName
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
        
        if(index == 0){
            
            if(eventObject.count > 1){
                
                eventObject.removeAll(keepCapacity: false)
                eventObject.append(backupPrimary[0])
            }
            else{
                
                eventObject.removeAll(keepCapacity: false)
                eventObject = (backupPrimary)
                
                for(var i = 0 ; i < eventObject.count ; ++i){
                    
                    eventObject[i].sectionObjects.removeAll(keepCapacity: false)
                }
            }
        }
        else{
            
            if (eventObject[index].sectionObjects.count == 0){
                
                eventObject[index].sectionObjects = (backupPrimary[index].sectionObjects)
            }
                
            else{
                
                eventObject[index].sectionObjects.removeAll(keepCapacity: false)
            }
        }
        
        eventCategoriesTable.reloadData()
        
        //adjustHeightOfTableView(self.eventCategoriesTable, constraint: self.eventCategoryHeightConstraint)
        
    }
    
    func adjustHeightOfTableView(uiTableView: UITableView, constraint: NSLayoutConstraint){
        
        var height: CGFloat = uiTableView.contentSize.height
        
        constraint.constant = height
        
        println(height)
        
        self.view.setNeedsUpdateConstraints()
        
        uiTableView.reloadData()
        
    }


}
