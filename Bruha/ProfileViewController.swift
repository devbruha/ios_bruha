//
//  ProfileViewController.swift
//  Bruha
//
//  Created by lye on 15/7/22.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let gradientLayer = CAGradientLayer()

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var bruhaButton: UIButton!
    
    
    func configureView(){
       
        
        myImage.layer.borderWidth = 3
        myImage.layer.masksToBounds = false
        myImage.layer.borderColor = UIColor.whiteColor().CGColor
        myImage.layer.cornerRadius = myImage.frame.height/2
        myImage.clipsToBounds = true
    }
    
    func loadUserInfo(){
        
        let userInfo = FetchData(context: managedObjectContext).fetchUserInfo()
        
        name.text = (userInfo?.first?.userFirstName)!
        email.text = (userInfo?.first?.userEmail)!
        
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            
            getFacebookProfilePic()
            
        } else {
            
            getProfilePicLink((userInfo?.first?.userName)!) {
                (let response) in
                
                let mResponse = response?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                
                if mResponse == "1" {
                    print("User does not have profile picture")
                }
                else if mResponse == "2" {
                    print("php query fails")
                }
                else if mResponse == "3" {
                    print("username is nil, printing username \(userInfo?.first?.userName)")
                }
                    
                else {
                    
                    let urlString = "http://temp.bruha.com/\(mResponse!)"
                    let url = NSURL(string: urlString)
                    
                    self.getDataFromUrl(url!) {
                        (let data) in
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            self.myImage.contentMode = UIViewContentMode.ScaleAspectFill
                            self.myImage.image = UIImage(data: data!)
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
    
    func getProfilePicLink(username: String, completion: (NSString? -> Void)) {
        
        let bruhaBaseURL: NSURL? = NSURL(string: "http://temp.bruha.com/mobile_php/RetrieveMyPHP/")
        
        if let loginURL = NSURL(string: "getuserPicLink.php?", relativeToURL: bruhaBaseURL) {
            
            let networkOperation = NetworkOperation(url: loginURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                networkOperation.stringFromURLPost("username=\(username)") {
                    
                    (let picSignal) in
                    
                    completion(picSignal)
                }
            }
        }
            
        else {
            print("Could not construct a valid URL")
        }
    }
    
    func customTopButtons() {
        
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
        barView.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
        
        self.view.addSubview(barView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadUserInfo()
        backgroundGradient()
        //customTopButtons()
        customStatusBar()
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
    
    @IBAction func LogoutPressed(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Are you sure you want to log out?", message:nil, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (_) -> Void in
            
            DeleteData(context: self.managedObjectContext).deleteUserInfo()
            DeleteData(context: self.managedObjectContext).deleteUser()
            
            if FBSDKAccessToken.currentAccessToken() != nil {
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
            }
            
            self.performSegueWithIdentifier("logOutToSplashView", sender: self)
        }
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("logged in using facebook")
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("facebook logged out")
    }
    
    func getFacebookProfilePic() {
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id"])
        graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            if error == nil {
                
                let url = "http://graph.facebook.com/\(result["id"]!! as! NSString)/picture?type=large"
                
                if let data = NSData(contentsOfURL: NSURL(string: url)!) {
                    
                    self.myImage.contentMode = UIViewContentMode.ScaleAspectFill
                    self.myImage.image = UIImage(data: data)
                }
                
            }
        }
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
