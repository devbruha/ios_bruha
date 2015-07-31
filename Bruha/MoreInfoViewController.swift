//
//  MoreInfoViewController.swift
//  Bruha
//
//  Created by lye on 15/7/30.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

class MoreInfoViewController: UIViewController {

    @IBOutlet weak var verticalScroll: UIScrollView!
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var smallImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        verticalScroll.contentSize.width = screenWidth
        verticalScroll.contentSize.height = 800
        
        let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
        price.text = (eventInfo?.first?.price)!

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
