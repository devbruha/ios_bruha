//
//  LoadScreenViewController.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-10-16.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import UIKit


class LoadScreenViewController: UIViewController {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    override func viewDidAppear(animated: Bool) {
        
        LoadScreenService(context: self.managedObjectContext).retrieveAll()
        
        if(FetchData(context: managedObjectContext).fetchUserInfo()?.count != 0) {
            
            self.performSegueWithIdentifier("toDashBoard", sender: self)
            
        } else {
            
            self.performSegueWithIdentifier("toSplashView", sender: self)
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}