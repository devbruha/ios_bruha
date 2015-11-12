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
    
    var generalRetrieved = 0
    var loggedinRetrieved = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DeleteData(context: self.managedObjectContext).deleteAll()
        LoadScreenService(context: self.managedObjectContext).retrieveAll()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "segueSplash", name:"Event Categories", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "segueSplash", name:"Events", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "segueDashBoard", name:"User Events", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "segueDashBoard", name:"Addicted Events", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "segueSplash", name:"Venues", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "segueDashBoard", name:"User Venues", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "segueDashBoard", name:"Addicted Venues", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "segueSplash", name:"Organizations", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "segueDashBoard", name:"User Organizations", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "segueDashBoard", name:"Addicted Organizations", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if hasInternet() == "true" {
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "performSegue", name:"download complete", object: nil)
            
        } else {
            
            let alertController = UIAlertController(title: "No Internet Connection Detected!", message:hasInternet(), preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
                
                if (FetchData(context: self.managedObjectContext).fetchUserInfo()?.count != 0) {
                    
                    GlobalVariables.loggedIn = true
                }
                else{
                    
                    GlobalVariables.loggedIn = false
                }
                
                self.performSegue()
                
            }
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"Event Categories", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"Events", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"Venues", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"Organizations", object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"User Events", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"Addicted Events", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"User Venues", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"Addicted Venues", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"User Organizations", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"Addicted Organizations", object: nil)
        
        print("observer removed")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hasInternet() -> String {
        
        var error :String = "No Error"
        
        if Reachability.isConnectedToNetwork() == true{
            
            return "true"
        }
        else{
            
            error = "The Information displayed is not up to date and some of our features will not be available to you due to no internet connection being detected. Please turn on your internet connection and restart the app to get updated information."
        }
        
        return error
    }
    
    func segueSplash() {
        
        generalRetrieved = generalRetrieved + 1
        
        if generalRetrieved == 4 && FetchData(context: managedObjectContext).fetchUserInfo()?.count == 0 {
            
            print("should go to splash")
            NSNotificationCenter.defaultCenter().postNotificationName("download complete", object: nil)
            
        } else if generalRetrieved == 4 && loggedinRetrieved == 6 {
            
            print("should dashboard")
            NSNotificationCenter.defaultCenter().postNotificationName("download complete", object: nil)
        }
    }
    
    func segueDashBoard() {
        
        loggedinRetrieved = loggedinRetrieved + 1
        
        if loggedinRetrieved == 6 && FetchData(context: managedObjectContext).fetchUserInfo()?.count != 0 && generalRetrieved == 4 {
            
            print("should go to dashboard")
            NSNotificationCenter.defaultCenter().postNotificationName("download complete", object: nil)
        }
    }
    
    func performSegue() {
        
        if(FetchData(context: managedObjectContext).fetchUserInfo()?.count != 0) {
            
            print("DashBoard segue")
            self.performSegueWithIdentifier("toDashBoard", sender: self)
            
        } else {
            
            print("SplashView segue")
            self.performSegueWithIdentifier("toSplashView", sender: self)

        }
    }
}
