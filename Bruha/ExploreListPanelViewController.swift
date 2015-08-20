//
//  EventFilterPanelViewController.swift
//  Bruha
//
//  Created by lye on 15/7/31.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

class ExploreListPanelViewController: UIViewController {

    @IBOutlet weak var eventSelectedB: UIButton!
    @IBOutlet weak var venueSelectedB: UIButton!
    @IBOutlet weak var artistSelectedB: UIButton!
    @IBOutlet weak var organizationSelectedB: UIButton!
    
    @IBOutlet weak var venueTable: UITableView!
    @IBOutlet weak var artistTable: UITableView!
    @IBOutlet weak var organizationTable: UITableView!
    
    
    
    var panelControllerContainer: ARSPContainerController!
    var swipeZoneHeight: CGFloat = 74
    var visibleZoneHeight: CGFloat = 74
    
    func eventTapped(){
        
        venueTable.alpha = 0
        artistTable.alpha = 0
        organizationTable.alpha = 0
        /*eventCategories.alpha = 1
        venueCategories.alpha = 0
        artistCategories.alpha = 0
        organizationCategories.alpha = 0*/
        
        GlobalVariables.selectedDisplay = "Event"
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
        
    }
    
    func venueTapped(){
        
        venueTable.alpha = 1
        artistTable.alpha = 0
        organizationTable.alpha = 0
        /*eventCategories.alpha = 0
        venueCategories.alpha = 1
        artistCategories.alpha = 0
        organizationCategories.alpha = 0*/
        
        GlobalVariables.selectedDisplay = "Venue"
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
    }
    
    func artistTapped(){
        
        venueTable.alpha = 0
        artistTable.alpha = 1
        organizationTable.alpha = 0
        
        GlobalVariables.selectedDisplay = "Artist"
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
    }
    
    func organizationTapped(){
        
        venueTable.alpha = 0
        artistTable.alpha = 0
        organizationTable.alpha = 1
        
        GlobalVariables.selectedDisplay = "Organization"
        
        NSNotificationCenter.defaultCenter().postNotificationName("itemDisplayChange", object: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.panelControllerContainer = self.parentViewController as! ARSPContainerController
        panelControllerContainer.visibleZoneHeight = visibleZoneHeight
        panelControllerContainer.shouldOverlapMainViewController = true
        //println(panelControllerContainer.visibilityState)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationSent", name: "itemDisplayChange", object: nil)
        
        var eventTgr = UITapGestureRecognizer(target: self, action: ("eventTapped"))
        eventSelectedB.addGestureRecognizer(eventTgr)

        var venueTgr = UITapGestureRecognizer(target: self, action: ("venueTapped"))
        venueSelectedB.addGestureRecognizer(venueTgr)
        
        var artistTgr = UITapGestureRecognizer(target: self, action: ("artistTapped"))
        artistSelectedB.addGestureRecognizer(artistTgr)
        
        var organizationTgr = UITapGestureRecognizer(target: self, action: ("organizationTapped"))
        organizationSelectedB.addGestureRecognizer(organizationTgr)
        
        self.venueTable.tableFooterView = UIView()
        self.artistTable.tableFooterView = UIView()
        self.organizationTable.tableFooterView = UIView()
        
    }
    
    func updateNotificationSent(){
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.swipeZoneHeight = self.panelControllerContainer.swipableZoneHeight
        self.visibleZoneHeight = self.panelControllerContainer.visibleZoneHeight
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var selectedIndexPath : NSIndexPath?
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ExplorePanelViewTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
        
        
        // Configure the cell...
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        }
        else{
            selectedIndexPath = indexPath
        }
        var indexPaths: Array<NSIndexPath> = []
        if let previous = previousIndexPath{
            indexPaths += [previous]
            
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! ExplorePanelViewTableViewCell).watchFrameChanges()
    }
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! ExplorePanelViewTableViewCell).ignoreFrameChanges()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return ExplorePanelViewTableViewCell.expandedHeight
        } else {
            return ExplorePanelViewTableViewCell.defaultHeight
        }
    }


}
