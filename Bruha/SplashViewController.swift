//
//  SplashViewController.swift
//  Bruha
//
//  Created by lye on 15/7/17.
//  Copyright (c) 2015年 lye. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SplashViewController: UIViewController,UIScrollViewDelegate, FBSDKLoginButtonDelegate{
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let faceLoginButton = FBSDKLoginButton()

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var loginB: UIButton!
    
    @IBOutlet weak var signupB: UIButton!
    
    func customStatusBar() {
        let barView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        barView.backgroundColor = UIColor.blackColor()
        
        self.view.addSubview(barView)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //customStatusBar()

        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width-20
        let scrollViewHeight:CGFloat = self.scrollView.frame.height-168
        //2
        self.skipButton.layer.cornerRadius = 4.0
        self.skipButton.layer.borderWidth = 1.0
        self.skipButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.skipButton.backgroundColor = UIColor.clearColor()
        self.skipButton.layer.borderColor = UIColor.orangeColor().CGColor
        //3
        let imgOne = SplashView.instanceFromNib1()
        imgOne.frame = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight+30)
        let imgTwo = SplashView.instanceFromNib2()
        imgTwo.frame = CGRectMake(scrollViewWidth, 0,scrollViewWidth+20, scrollViewHeight+168)
        let imgThree = SplashView.instanceFromNib3()
        imgThree.frame = CGRectMake(scrollViewWidth*2, 0,scrollViewWidth+20, scrollViewHeight+168)
        let imgFour = SplashView.instanceFromNib4()
        imgFour.frame = CGRectMake(scrollViewWidth*3, 0,scrollViewWidth+20, scrollViewHeight+168)
        let imgFive = SplashView.instanceFromNib5()
        imgFive.frame = CGRectMake(scrollViewWidth*4, 0,scrollViewWidth+20, scrollViewHeight+168)
        
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        self.scrollView.addSubview(imgFour)
        self.scrollView.addSubview(imgFive)
        //4
        //self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * 5, self.scrollView.frame.height)
        self.scrollView.contentSize = CGSizeMake(scrollViewWidth*5, scrollViewHeight)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        
        GlobalVariables.loggedIn = false
        
        loginB.layer.cornerRadius = 2
        loginB.clipsToBounds = true
        signupB.layer.cornerRadius = 2
        signupB.clipsToBounds = true
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        // FaceBook
        self.view.addSubview(faceLoginButton)
        faceLoginButton.delegate = self
        faceLoginButton.translatesAutoresizingMaskIntoConstraints = false
        faceLoginButton.alpha = 0.85
        
        let topConstraint = NSLayoutConstraint(item: faceLoginButton, attribute: NSLayoutAttribute.TopMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.loginB, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1, constant: 18)
        
        //let centerConstraint = NSLayoutConstraint(item: faceLoginButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let offSet = screenSize.width * 0.1
        let leadingConstraint = NSLayoutConstraint(item: faceLoginButton, attribute: NSLayoutAttribute.LeftMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.loginB, attribute: NSLayoutAttribute.LeftMargin, multiplier: 1, constant: offSet)
        
        let trailingConstraint = NSLayoutConstraint(item: faceLoginButton, attribute: NSLayoutAttribute.RightMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.signupB, attribute: NSLayoutAttribute.RightMargin, multiplier: 1, constant: -offSet)
        
        NSLayoutConstraint.activateConstraints([topConstraint, leadingConstraint, trailingConstraint])
        
        print("\(faceLoginButton.frame.size.height), \(faceLoginButton.frame.size.width) ~~~~~~~~~~~ splash")
        // Do any additional setup after loading the view.
    }
    /*override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if FBSDKAccessToken.currentAccessToken() != nil {
            faceLoginButton.hidden = true
        }
    }*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = CGRectGetWidth(scrollView.frame)
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            let alertController = UIAlertController(title: "FaceBook Login Failed", message: error.description, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return
            
        } else if result.isCancelled {
            print("Cancelled")
            
        } else {
            let accessToken = FBSDKAccessToken.currentAccessToken()
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,gender"], tokenString: accessToken.tokenString, version: nil, HTTPMethod: "GET")
            req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
                if(error == nil) {
                    /*
                    print("email \(result["email"]!!)")
                    print("name \(result["name"]!!)")
                    print("gender \(result["gender"]!!)")
                    print("id \(result["id"]!!)")*/
                    
                    print("ALL \(result)")
                    
                    var email = "Not Set"
                    var gender = "Not Set"
                    var name = "Not Set"
                    
                    if let e = result["email"] as! String? {
                        email = e
                    }
                    
                    if let g = result["gender"] as! String? {
                        gender = g
                    }
                    
                    if let n = result["name"] as! String? {
                        name = n
                    }
                    
                    let facebookService = FacebookService(context: self.managedObjectContext, username: result["id"]!! as! String, userfname: name, emailaddress: email, usergender: gender)
                    
                    facebookService.registerNewUser{
                        (let facebookResponse) in
                        
                        if facebookResponse! == " sign in success" {
                            
                            facebookService.getUserInformation{
                                (let userInfo) in
                            }
                            dispatch_async(dispatch_get_main_queue()){
                                
                                let alertController = UIAlertController(title: "Facebook Login Successful", message:nil, preferredStyle: .Alert)
                                let acceptAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
                                    self.performSegueWithIdentifier("toDash", sender: self) // Replace SomeSegue with your segue identifier (name)
                                    
                                    LoadScreenService(context: self.managedObjectContext).retrieveUser()
                                }
                                
                                alertController.addAction(acceptAction)
                                
                                self.presentViewController(alertController, animated: true, completion: nil)
                            }
                            
                            GlobalVariables.loggedIn = true
                        }
                            
                        else { //facebook is not in the database
                            dispatch_async(dispatch_get_main_queue()){
                                
                                let alertController = UIAlertController(title: "Facebook SignUp Successful", message:nil, preferredStyle: .Alert)
                                
                                let acceptAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
                                    self.performSegueWithIdentifier("toDash", sender: self)
                                    let user = User(username: "\(result["id"]!! as! String)_FB", userEmail: email, userCity: "Not Set", userFName: name, userGender: gender, userBirthdate: "Not Set")
                                    SaveData(context: self.managedObjectContext).saveUser(user)
                                    GlobalVariables.loggedIn = true
                                }
                                
                                alertController.addAction(acceptAction)
                                
                                self.presentViewController(alertController, animated: true, completion: nil)
                            }
                        }
                    }
                }
                else {
                    print("error getting user information(facebook): \(error)")
                }
            })
        }

    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("logged out")
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
