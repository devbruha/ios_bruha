//
//  InitialLoadViewController.swift
//  Bruha
//
//  Created by Ryan O'Neill on 2015-07-17.
//  Copyright (c) 2015 lye. All rights reserved.
//

import UIKit
import CoreData

class InitialLoadViewController: UIViewController {
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dispatch_async(dispatch_get_main_queue()) {
        
        DeleteData(context: self.managedObjectContext).deleteAll()
        
        LoadScreenService(context: self.managedObjectContext).retrieveAll()
            
            println("Hi")
            
            self.performSegueWithIdentifier("loadScreen", sender: self)
            
        }

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
