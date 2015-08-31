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
        if FetchData(context: managedObjectContext).fetchUserInfo()?.count == 0{
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
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.performSegueWithIdentifier("GoToCalendar", sender: self)
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var s = FetchData(context: managedObjectContext).fetchCategories()
    
        if FetchData(context: managedObjectContext).fetchUserInfo()?.count == 0{
            profileImage.alpha = 0.5
        }
        performImageSegue()
        
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
