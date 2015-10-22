//
//  ProfileViewController.swift
//  Bruha
//
//  Created by lye on 15/7/22.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var email: UILabel!
    
    func configureView(){
        
        myImage.layer.borderWidth = 1
        myImage.layer.masksToBounds = false
        myImage.layer.borderColor = UIColor.blackColor().CGColor
        myImage.layer.cornerRadius = myImage.frame.height/2
        myImage.clipsToBounds = true
    }
    
    func loadUserInfo(){
        
        let userInfo = FetchData(context: managedObjectContext).fetchUserInfo()
        
        name.text = (userInfo?.first?.userFirstName)!
        userName.text = (userInfo?.first?.userName)
        sex.text = (userInfo?.first?.userGender)!
        email.text = (userInfo?.first?.userEmail)!
        birthday.text = (userInfo?.first?.userBirthdate)!
        location.text = (userInfo?.first?.userCity)!
        
        myImage.image = UIImage(named: "Slide 3.png")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadUserInfo()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogoutPressed(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Are you sure you want to log out?", message:nil, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (_) -> Void in
            
            DeleteData(context: self.managedObjectContext).deleteUserInfo()
            DeleteData(context: self.managedObjectContext).deleteUser()
            self.performSegueWithIdentifier("logOutToSplashView", sender: self)
        }
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
