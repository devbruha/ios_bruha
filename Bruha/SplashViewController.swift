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

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width-20
        let scrollViewHeight:CGFloat = self.scrollView.frame.height-168
        //2
        self.skipButton.layer.cornerRadius = 4.0
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
        
        
        // FaceBook
        let faceLoginButton = FBSDKLoginButton()
        self.view.addSubview(faceLoginButton)
        faceLoginButton.delegate = self
        faceLoginButton.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: faceLoginButton, attribute: NSLayoutAttribute.TopMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1, constant: 100)
        let centerConstraint = NSLayoutConstraint(item: faceLoginButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        NSLayoutConstraint.activateConstraints([topConstraint, centerConstraint])
        // Do any additional setup after loading the view.
    }
    
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
                    if let e = result["email"] as! String? {
                        email = e
                    }
                    
                    let user = User(username: result["name"]!! as! String, userEmail: email, userCity: "Not Set", userFName: "Not Set", userGender: "Not Set", userBirthdate: "Not Set")
                    SaveData(context: self.managedObjectContext).saveUser(user)
                    GlobalVariables.loggedIn = true
                    
                    self.performSegueWithIdentifier("toDash", sender: self)
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
