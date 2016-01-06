//
//  DashBoardViewController.swift
//  Bruha
//
//  Created by lye on 15/7/21.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

class DashBoardViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var exploreImage: UIImageView!
    @IBOutlet weak var calendarImage: UIImageView!
    @IBOutlet weak var addictionImage: UIImageView!
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var ticketImage: UIImageView!
    @IBOutlet weak var bruhaButton: UIButton!
    
    @IBAction func Bruha(sender: UIButton) {
        
        let alert = UIAlertView(title: "You are already in dashboard!!!", message: nil, delegate: nil, cancelButtonTitle: nil)
        alert.show()
        let delay = 1.0 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissWithClickedButtonIndex(-1, animated: true)
        })
    }
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func alert() {
        let alertController = UIAlertController(title: "You are not logged in!", message:nil, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        let loginAction = UIAlertAction(title: "Login", style: .Default) { (_) -> Void in
            self.performSegueWithIdentifier("GoToLogin", sender: self) // Replace SomeSegue with your segue identifier (name)
        }
        let signupAction = UIAlertAction(title: "Signup", style: .Default) { (_) -> Void in
            self.performSegueWithIdentifier("GoToSignup", sender: self) // Replace SomeSegue with your segue identifier (name)
        }
        alertController.addAction(signupAction)
        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    func profileImageTapped(){
        if GlobalVariables.loggedIn == false{
            alert()
        }
        else{
            self.performSegueWithIdentifier("GoToProfile", sender: self)
        }
    }
    
    func exploreImageTapped(){
        self.performSegueWithIdentifier("GoToExplore", sender: self)
    }
    
    func calendarImageTapped(){
        if GlobalVariables.loggedIn == false{
            alert()
        }
        else{
            self.performSegueWithIdentifier("GoToCalendar", sender: self)
        }
    }
    
    func addictionImageTapped(){
        if GlobalVariables.loggedIn == false{
            alert()
        }
        else{
            self.performSegueWithIdentifier("GoToAddiction", sender: self)
            //GoToAddiction
        }
    }
    
    func uploadImageTapped(){
        if GlobalVariables.loggedIn == false{
            alert()
        }
        else{
            self.performSegueWithIdentifier("GoToUpload", sender: self)
        }
    }
    
    func performImageSegue(){
        let tgr1 = UITapGestureRecognizer(target:self , action: Selector("profileImageTapped"))
        profileImage.addGestureRecognizer(tgr1)
        profileImage.userInteractionEnabled = true
        
        let tgr2 = UITapGestureRecognizer(target:self , action: Selector("exploreImageTapped"))
        exploreImage.addGestureRecognizer(tgr2)
        exploreImage.userInteractionEnabled = true
        
        let tgr3 = UITapGestureRecognizer(target:self , action: Selector("calendarImageTapped"))
        calendarImage.addGestureRecognizer(tgr3)
        calendarImage.userInteractionEnabled = true
    
        let tgr4 = UITapGestureRecognizer(target:self , action: Selector("addictionImageTapped"))
        addictionImage.addGestureRecognizer(tgr4)
        addictionImage.userInteractionEnabled = true
        
        let tgr5 = UITapGestureRecognizer(target:self , action: Selector("uploadImageTapped"))
        uploadImage.addGestureRecognizer(tgr5)
        uploadImage.userInteractionEnabled = true
    }
    
    func setConstraint(uiimageview: [UIImageView!]) {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        print(screenSize.height)
        let height = screenSize.height / 10.0
        
        let width = screenSize.width / 5.0
        
        print("\(width), \(height)")
        
        
        for mView in uiimageview {
            
            let heightContraints = NSLayoutConstraint(item: mView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: height)
            heightContraints.priority = UILayoutPriorityDefaultHigh
            
            let widthContraints = NSLayoutConstraint(item: mView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: width)
            widthContraints.priority = UILayoutPriorityDefaultHigh
            
            mView.addConstraints([heightContraints, widthContraints])
        }
    }
    
    func customBruhaButton() {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        bruhaButton.setBackgroundImage(UIImage(named: "Bruha_White"), forState: UIControlState.Normal)
        let heightContraints = NSLayoutConstraint(item: bruhaButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.height/15.5)
        heightContraints.priority = UILayoutPriorityDefaultHigh
        
        let widthContraints = NSLayoutConstraint(item: bruhaButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.width/9)
        widthContraints.priority = UILayoutPriorityDefaultHigh
        
        bruhaButton.addConstraints([heightContraints, widthContraints])
    }
    
    func customStatusBar() {
        let barView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        barView.backgroundColor = UIColor.grayColor()
        
        self.view.addSubview(barView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //let imgViews = [exploreImage, addictionImage, ticketImage, calendarImage, uploadImage, profileImage]
        //setConstraint(imgViews)
        
        customBruhaButton()
        //customStatusBar()
        
        if GlobalVariables.loggedIn == false{
            addictionImage.alpha = 0.5
            ticketImage.alpha = 0.5
            calendarImage.alpha = 0.5
            uploadImage.alpha = 0.5
            profileImage.alpha = 0.5
        }
        else{
            addictionImage.alpha = 1
            ticketImage.alpha = 1
            calendarImage.alpha = 1
            uploadImage.alpha = 1
            profileImage.alpha = 1
        }
        performImageSegue()
        backgroundGradient()
        FetchData(context: managedObjectContext).fetchCategories()
        Filtering().clearAllFilter()
        GlobalVariables.datesSelected.removeAllObjects()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if GlobalVariables.loggedIn == false{
            addictionImage.alpha = 0.5
            ticketImage.alpha = 0.5
            calendarImage.alpha = 0.5
            uploadImage.alpha = 0.5
            profileImage.alpha = 0.5
        }
        else{
            addictionImage.alpha = 1
            ticketImage.alpha = 1
            calendarImage.alpha = 1
            uploadImage.alpha = 1
            profileImage.alpha = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backgroundGradient() {
        let background = CAGradientLayer().gradientColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
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
