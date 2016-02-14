//
//  LoginViewController.swift
//  Bruha
//
//  Created by lye on 15/7/17.
//  Copyright (c) 2015年 lye. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var continueWithoutLogIn: UIButton!
    @IBOutlet weak var registerB: UIButton!
    @IBOutlet weak var bruhaFace: UIImageView!
    @IBOutlet weak var loginB: UIButton!
    
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var error: String = "true"
    
    func continueButtonTapped(){
        self.performSegueWithIdentifier("ProceedToDashBoard", sender: self)
    }
    
    func customStatusBar() {
        let barView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        barView.backgroundColor = UIColor.grayColor()
        
        self.view.addSubview(barView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //customStatusBar()
        
        self.username.delegate = self
        self.password.delegate = self
        
        self.username.tag = 0
        self.password.tag = 1
    
        let tgr = UITapGestureRecognizer(target:self , action: Selector("continueButtonTapped"))
        continueWithoutLogIn.addGestureRecognizer(tgr)
        continueWithoutLogIn.userInteractionEnabled = true
        
        registerB.layer.cornerRadius = 2
        registerB.clipsToBounds = true
        continueWithoutLogIn.layer.cornerRadius = 2
        continueWithoutLogIn.clipsToBounds = true
        loginB.layer.cornerRadius = 2
        loginB.clipsToBounds = true
        
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        // FaceBook
        let faceLoginButton = FBSDKLoginButton()
        self.view.addSubview(faceLoginButton)
        faceLoginButton.delegate = self
        faceLoginButton.translatesAutoresizingMaskIntoConstraints = false
        faceLoginButton.alpha = 0.85
        
        let topConstraint = NSLayoutConstraint(item: faceLoginButton, attribute: NSLayoutAttribute.TopMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.continueWithoutLogIn, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1, constant: 18)
        
        let offSet = screenSize.width * 0.1
        let leadingConstraint = NSLayoutConstraint(item: faceLoginButton, attribute: NSLayoutAttribute.LeftMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.continueWithoutLogIn, attribute: NSLayoutAttribute.LeftMargin, multiplier: 1, constant: offSet)
        
        let trailingConstraint = NSLayoutConstraint(item: faceLoginButton, attribute: NSLayoutAttribute.RightMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.loginB, attribute: NSLayoutAttribute.RightMargin, multiplier: 1, constant: -offSet)
        
        NSLayoutConstraint.activateConstraints([topConstraint, leadingConstraint, trailingConstraint])
        
        print("\(faceLoginButton.frame.size.height), \(faceLoginButton.frame.size.width) ~~~~~~~~~~~ login")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Facebook Login
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
                                    self.performSegueWithIdentifier("ProceedToDashBoard", sender: self) // Replace SomeSegue with your segue identifier (name)
                                    
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
                                    self.performSegueWithIdentifier("ProceedToDashBoard", sender: self)
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
    
    
    // Login Button Onclick logic
   
    
    @IBAction func loginPress(sender: AnyObject) {
        
        let username:String = self.username.text!
        let password:String = self.password.text!
        
        error = "true"
        
        error = CredentialCheck().internetCheck()
        
        if error == "true"{
            
            error = CredentialCheck().usernameCheck(username)
            
            if error == "true"{
                
                error = CredentialCheck().passwordCheck(password)
                
                if error == "true"{
                    
                    let loginService = LoginService(context: managedObjectContext, username: username, password: password)
                    
                    // Running the login service, currently hard coded credentials, needs to take user input
                    
                    loginService.loginCheck {
                        (let loginResponse) in
                        
                        // If server response from credential check = "1", procede with downloading user info
                        let mLoginResponse = loginResponse?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                        print("-the returned---\(mLoginResponse)---")
                        if (mLoginResponse! == "1"){
                            
                            loginService.getUserInformation{
                                (let userInfo) in
                                
                            }
                            dispatch_async(dispatch_get_main_queue()){
                                
                                let alertController = UIAlertController(title: "Login Successful", message:nil, preferredStyle: .Alert)
                                let acceptAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
                                self.performSegueWithIdentifier("ProceedToDashBoard", sender: self) // Replace SomeSegue with your segue identifier (name)
                                    
                                    LoadScreenService(context: self.managedObjectContext).retrieveUser()
                                }
                                
                                alertController.addAction(acceptAction)
                                
                                
                                
                                self.presentViewController(alertController, animated: true, completion: nil)
                            }
                        
                            GlobalVariables.loggedIn = true
                        }
                            
                        else if (mLoginResponse! == "2"){
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                let alert = UIAlertView(title: "Login Failed", message: "Please check your Email and confirm sign up with Bruha", delegate: nil, cancelButtonTitle: "OK")
                                alert.show()
                            }
                        }
                            
                        else if (mLoginResponse! == "3"){
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                let alert = UIAlertView(title: "Login Failed", message: "Please try again. The username you have entered does not exist", delegate: nil, cancelButtonTitle: "OK")
                                alert.show()
                            }
                        }
                            
                        else if (mLoginResponse! == "4"){
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                let alert = UIAlertView(title: "Login Failed", message: "Please try again. You have entered incorrect password", delegate: nil, cancelButtonTitle: "OK")
                                alert.show()
                            }
                        }
                            
                        else{
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                let alert = UIAlertView(title: "Login Failed", message: "Sorry, Someting strange happened", delegate: nil, cancelButtonTitle: "OK")
                                alert.show()
                            }
                        }
                    }

                }
                else{
                    let alert = UIAlertView(title: "Password Error", message: error, delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
            }
                
            else{
                let alert = UIAlertView(title: "Username Error", message: error, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        }
            
        else{
            let alert = UIAlertView(title: "No Internet Connection", message: error, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    
    @IBAction func forgotPasswordPressed(sender: UIButton) {
        
        self.performSegueWithIdentifier("forgotPassword", sender: self)
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        //super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        bruhaFace.hidden = true
        if textField.tag == 0 {
            animateViewMoving(true, moveValue: 253)
        }
        else if textField.tag == 1 {
            animateViewMoving(true, moveValue: 216)
        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        bruhaFace.hidden = false
        if textField.tag == 0 {
            animateViewMoving(false, moveValue: 253)
        }
        else if textField.tag == 1 {
            animateViewMoving(false, moveValue: 216)
        }
    }
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.1
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
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
