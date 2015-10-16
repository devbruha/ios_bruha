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
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.performSegueWithIdentifier("GoToProfile", sender: self)
        }
    }
    
    func exploreImageTapped(){
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.performSegueWithIdentifier("GoToExplore", sender: self)
    }
    
    func calendarImageTapped(){
        if GlobalVariables.loggedIn == false{
            alert()
        }
        else{
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.performSegueWithIdentifier("GoToCalendar", sender: self)
        }
    }
    
    func addictionImageTapped(){
        if GlobalVariables.loggedIn == false{
            alert()
        }
        else{
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.performSegueWithIdentifier("GoToAddiction", sender: self)
            //GoToAddiction
        }
    }
    
    func uploadImageTapped(){
        if GlobalVariables.loggedIn == false{
            alert()
        }
        else{
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.performSegueWithIdentifier("GoToUpload", sender: self)
        }
    }
    
    func performImageSegue(){
        var tgr1 = UITapGestureRecognizer(target:self , action: Selector("profileImageTapped"))
        profileImage.addGestureRecognizer(tgr1)
        profileImage.userInteractionEnabled = true
        
        var tgr2 = UITapGestureRecognizer(target:self , action: Selector("exploreImageTapped"))
        exploreImage.addGestureRecognizer(tgr2)
        exploreImage.userInteractionEnabled = true
        
        var tgr3 = UITapGestureRecognizer(target:self , action: Selector("calendarImageTapped"))
        calendarImage.addGestureRecognizer(tgr3)
        calendarImage.userInteractionEnabled = true
    
        var tgr4 = UITapGestureRecognizer(target:self , action: Selector("addictionImageTapped"))
        addictionImage.addGestureRecognizer(tgr4)
        addictionImage.userInteractionEnabled = true
        
        var tgr5 = UITapGestureRecognizer(target:self , action: Selector("uploadImageTapped"))
        uploadImage.addGestureRecognizer(tgr5)
        uploadImage.userInteractionEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var s = FetchData(context: managedObjectContext).fetchCategories()
    
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
        
        // Do any additional setup after loading the view.
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
