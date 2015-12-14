//
//  LoadScreenViewController.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-10-16.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import UIKit

extension UIView {
    func startRotating(duration: Double = 1.5) {
        let kAnimationKey = "rotation"
        
        if self.layer.animationForKey(kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(M_PI * 2.0)
            self.layer.addAnimation(animate, forKey: kAnimationKey)
        }
    }
    func stopRotating() {
        let kAnimationKey = "rotation"
        
        if self.layer.animationForKey(kAnimationKey) != nil {
            self.layer.removeAnimationForKey(kAnimationKey)
        }
    }
}

class LoadScreenViewController: UIViewController {
    
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet weak var loading: UIImageView!
    var done: Bool = false
    var progressTimer: NSTimer = NSTimer()

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var generalRetrieved = 0
    var loggedinRetrieved = 0
    
    var userLog: Int = 0
    
    func customStatusBar() {
        let barView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        barView.backgroundColor = UIColor.blackColor()
        
        self.view.addSubview(barView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.alpha = 0
        //customStatusBar()

        progressView.progressViewStyle = UIProgressViewStyle.Bar
        progressView.trackTintColor = UIColor.orangeColor()
        progressView.progressTintColor = UIColor.purpleColor()
        
//        progressView.trackImage = UIImage(named: "Arena")
//        progressView.progressImage = UIImage(named: "Band")
        
        let heightContraints = NSLayoutConstraint(item: progressView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 30)
        progressView.addConstraint(heightContraints)
        
        
        userLog = (FetchData(context: managedObjectContext).fetchUserInfo()?.count)!
        
//        DeleteData(context: self.managedObjectContext).deleteAll()
//        LoadScreenService(context: self.managedObjectContext).retrieveAll()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if hasInternet() == "true" {
            
            DeleteData(context: self.managedObjectContext).deleteAll()
            
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
            
            LoadScreenService(context: self.managedObjectContext).retrieveAll()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if hasInternet() == "true" {
            startSpinning()
            startLoadingProgress()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveImages", name:"complete", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "performSegue", name:"complete", object: nil)
            let timer = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: "timeOutCheck", userInfo: nil, repeats: false)
            
        } else {
            
            let alertController = UIAlertController(title: "No Internet Connection Detected!", message:hasInternet(), preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
                
                if (self.userLog != 0) {
                    
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
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "complete", object: nil)
        
        print("observer removed")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Download Image
    func saveImages() {
        let eventInfo = FetchData(context: managedObjectContext).fetchEvents()
        let venueInfo = FetchData(context: managedObjectContext).fetchVenues()
        let organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()
        
        for event in eventInfo {
            if let checkedUrl = NSURL(string:event.posterUrl) {
                
                self.getDataFromUrl(checkedUrl) { data in
                    dispatch_async(dispatch_get_main_queue()) {
                        if let downloadImg = data {
                            //print("event")
                            let img: Image = Image(id: event.eventID, image: downloadImg)
                            SaveData(context: self.managedObjectContext).savePosterImages(img)
                        }
                        
                    }
                }
            }
        }
        for venue in venueInfo! {
            if let checkedUrl = NSURL(string:venue.posterUrl) {
                
                self.getDataFromUrl(checkedUrl) { data in
                    dispatch_async(dispatch_get_main_queue()) {
                        if let downloadImg = data {
                            let img: Image = Image(id: venue.venueID, image: downloadImg)
                            SaveData(context: self.managedObjectContext).savePosterImages(img)
                        }
                    }
                }
            }
        }
        for organization in organizationInfo! {
            if let checkedUrl = NSURL(string:organization.posterUrl) {
                
                self.getDataFromUrl(checkedUrl) { data in
                    dispatch_async(dispatch_get_main_queue()) {
                        if let downloadImg = data {
                            let img: Image = Image(id: organization.organizationID, image: downloadImg)
                            SaveData(context: self.managedObjectContext).savePosterImages(img)
                        }
                    }
                }
            }
        }
        
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
    // MARK: - Internet
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
    // MARK: - prepare segue
    func segueSplash() {
        
        generalRetrieved = generalRetrieved + 1
        
        if generalRetrieved == 4 && userLog == 0 {
            
            print("should go to splash")
            NSNotificationCenter.defaultCenter().postNotificationName("complete", object: nil)
            
        } else if generalRetrieved == 4 && loggedinRetrieved == 6 {
            
            print("should dashboard")
            NSNotificationCenter.defaultCenter().postNotificationName("complete", object: nil)
        }
    }
    
    func segueDashBoard() {
        
        loggedinRetrieved = loggedinRetrieved + 1
        
        if loggedinRetrieved == 6 && userLog != 0 && generalRetrieved == 4 {
            
            print("should go to dashboard")
            NSNotificationCenter.defaultCenter().postNotificationName("complete", object: nil)
        }
    }
    
    func performSegue() {
        
        finishesLoadingProgress()
        stopSpinning()
        if(userLog != 0) {
            
            delay(1.5){
                print("DashBoard segue")
                self.performSegueWithIdentifier("toDashBoard", sender: self)
            }
            
        } else {
            
            delay(1.5){
                print("SplashView segue")
                self.performSegueWithIdentifier("toSplashView", sender: self)
            }
        }
    }
    // MARK: - timing
    func startLoadingProgress() {
        self.progressView.progress = 0.0
        self.done = false
        self.progressTimer = NSTimer.scheduledTimerWithTimeInterval(0.1067, target: self, selector: "timerCallback", userInfo: nil, repeats: true)
    }
    func finishesLoadingProgress() {
        self.done = true
    }
    func timerCallback() {
        if self.done {
            if self.progressView.progress >= 1 {
                self.progressTimer.invalidate()
            } else {
                self.progressView.progress += 0.20
            }
        } else {
            self.progressView.progress += 0.05
            if self.progressView.progress >= 0.80 {
                self.progressView.progress = 0.80
            }
        }
    }
    
    func timeOutCheck() {
        
        if !(loggedinRetrieved == 6 && generalRetrieved == 4 || generalRetrieved == 4 && userLog == 0) {
            
            let alert = UIAlertView(title: "Error while loading, some functionality may not work, please restart the app to get full functionality", message: nil, delegate: nil, cancelButtonTitle: nil)
            alert.show()
            self.delay(5.0){
                alert.dismissWithClickedButtonIndex(-1, animated: true)
            }
//            let delay = 5.0 * Double(NSEC_PER_SEC)
//            var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//            dispatch_after(time, dispatch_get_main_queue(), {
//                alert.dismissWithClickedButtonIndex(-1, animated: true)
//                //self.performSegueWithIdentifier("toSplashView", sender: self)
//            })
            
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after( dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)) ), dispatch_get_main_queue(), closure )
    }
    
    func startSpinning() {
        loading.image = UIImage(named:"Events_Orange")
        loading.startRotating()
    }
    
    func stopSpinning() {
        loading.stopRotating()
        loading.image = UIImage(named:"Brüha_Face_Purple_Lrg")
    }
}
