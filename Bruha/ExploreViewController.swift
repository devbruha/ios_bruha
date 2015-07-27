//
//  ExploreViewController.swift
//  Bruha
//
//  Created by lye on 15/7/27.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {
    
    @IBOutlet weak var exploreTableView: UITableView!
    var item = ["Slide 1.jpg","Slide 2.jpg","Slide 3.jpg","Slide 4.jpg","Slide 5.jpg","Slide 6.jpg","Slide 7.jpg","Slide 8.jpg"]
    //var itemName = ["Lamborghini", "Drift", "Ferrari", "Hyundai","Mercedes Benz","Mitsubishi","Nissan","Volkswagen"]

    override func viewDidLoad() {
        super.viewDidLoad()
        exploreTableView.rowHeight = 297

        // Do any additional setup after loading the view.
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
        return item.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : ExploreTableViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as! ExploreTableViewCell!
        if(cell == nil)
        {
            cell = NSBundle.mainBundle().loadNibNamed("Cell", owner: self, options: nil)[0] as! ExploreTableViewCell;
        }
        //let stringTitle = itemName[indexPath.row] as String //NOT NSString
        let strCarName = item[indexPath.row] as String
        //cell.lblTitle.text=stringTitle
        cell.ExploreImage.image = UIImage(named: strCarName)
        
        
        // Configure the cell...
        
        return cell as ExploreTableViewCell
    }
    


}
