//
//  SignUpViewController.swift
//  Bruha
//
//  Created by lye on 15/7/17.
//  Copyright (c) 2015年 lye. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SignUpViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var emailaddress: UITextField!
    @IBOutlet weak var continueWithoutRegister: UIButton!
    
    // Retreive the managedObjectContext from AppDelegate
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var error: String = "true"
    
    let faceLoginButton = FBSDKLoginButton()
    
    func continueButtonTapped(){
        self.performSegueWithIdentifier("ProceedToDashBoard", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tgr = UITapGestureRecognizer(target:self , action: Selector("continueButtonTapped"))
        continueWithoutRegister.addGestureRecognizer(tgr)
        continueWithoutRegister.userInteractionEnabled = true

        self.username.delegate = self
        self.password.delegate = self
        self.emailaddress.delegate = self
        
        // FaceBook
        self.view.addSubview(faceLoginButton)
        faceLoginButton.delegate = self
        faceLoginButton.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: faceLoginButton, attribute: NSLayoutAttribute.TopMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.password, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1.2, constant: 20)
        let centerConstraint = NSLayoutConstraint(item: faceLoginButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.password, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        NSLayoutConstraint.activateConstraints([topConstraint, centerConstraint])
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if FBSDKAccessToken.currentAccessToken() != nil {
            faceLoginButton.hidden = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func registerButtonClick(sender: AnyObject) {
        
        let username:String = self.username.text!
        let password:String = self.password.text!
        let emailaddress:String = self.emailaddress.text!
        
        error = "true"
        
        error = CredentialCheck().internetCheck()
        
        if error == "true"{
            
            error = CredentialCheck().usernameCheck(username)
            
            if error == "true"{
                
                error = CredentialCheck().passwordCheck(password)
                
                if error == "true"{
                    
                    error = CredentialCheck().emailCheck(emailaddress)
                    
                    if error == "true"{
                        
                        print("Register conditions are checked!")
                        let registerService = RegisterService(context: managedObjectContext, username: username, password: password, emailaddress: emailaddress)
                        
                        // Running the login service, currently hard coded credentials, needs to take user input
                        
                        registerService.registerNewUser{
                            (let registerResponse) in
                            
                            dispatch_async(dispatch_get_main_queue()){
                                
                                let alertController = UIAlertController(title: "Register Successful", message:nil, preferredStyle: .Alert)
                                
                                let acceptAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
                                    self.performSegueWithIdentifier("ProceedToDashBoard", sender: self) // Replace SomeSegue with your segue identifier (name)
                                    
                                    let mUser = User(username: username, userEmail: emailaddress, userCity: "Not Set", userFName: "Not Set", userGender: "Not Set", userBirthdate: "Not Set")
                                    
                                    SaveData(context: self.managedObjectContext).saveUser(mUser)
                                    
                                    GlobalVariables.loggedIn = true
                                }
                                
                                alertController.addAction(acceptAction)
                                
                                self.presentViewController(alertController, animated: true, completion: nil)
                            }
                        }
                    }
                        
                    else{
                        
                        let alert = UIAlertView(title: "Email Address Error", message: error, delegate: nil, cancelButtonTitle: "OK")
                        alert.show()
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        //super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
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
