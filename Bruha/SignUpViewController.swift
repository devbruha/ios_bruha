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
    @IBOutlet weak var verifyPassword: UITextField!
    @IBOutlet weak var emailaddress: UITextField!
    @IBOutlet weak var continueWithoutRegister: UIButton!
    
    @IBOutlet weak var loginB: UIButton!
    @IBOutlet weak var bruhaFace: UIImageView!
    @IBOutlet weak var signupB: UIButton!
    
    @IBOutlet weak var textBottomSpace: NSLayoutConstraint!
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var error: String = "true"
    
    let faceLoginButton = FBSDKLoginButton()
    
    func continueButtonTapped(){
        self.performSegueWithIdentifier("ProceedToDashBoard", sender: self)
    }
    
    func customStatusBar() {
        let barView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        barView.backgroundColor = UIColor.grayColor()
        
        self.view.addSubview(barView)
    }

    override func viewDidLoad() {
        faceLoginButton.hidden = true
        super.viewDidLoad()
        
        //customStatusBar()
        
        let tgr = UITapGestureRecognizer(target:self , action: Selector("continueButtonTapped"))
        continueWithoutRegister.addGestureRecognizer(tgr)
        continueWithoutRegister.userInteractionEnabled = true

        self.username.delegate = self
        self.password.delegate = self
        self.verifyPassword.delegate = self
        self.emailaddress.delegate = self
        
        self.username.tag = 0
        self.password.tag = 0
        self.verifyPassword.tag = 0
        self.emailaddress.tag = 0
        
        self.emailaddress.keyboardType = .EmailAddress
        
        signupB.layer.cornerRadius = 2
        signupB.clipsToBounds = true
        continueWithoutRegister.layer.cornerRadius = 2
        continueWithoutRegister.clipsToBounds = true
        loginB.layer.cornerRadius = 2
        loginB.clipsToBounds = true
        
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        // FaceBook
        self.view.addSubview(faceLoginButton)
        faceLoginButton.delegate = self
        faceLoginButton.translatesAutoresizingMaskIntoConstraints = false
        faceLoginButton.alpha = 0.85
        
        let topConstraint = NSLayoutConstraint(item: faceLoginButton, attribute: NSLayoutAttribute.TopMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.continueWithoutRegister, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1, constant: 18)
        
        let offSet = screenSize.width * 0.1
        let leadingConstraint = NSLayoutConstraint(item: faceLoginButton, attribute: NSLayoutAttribute.LeftMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.continueWithoutRegister, attribute: NSLayoutAttribute.LeftMargin, multiplier: 1, constant: offSet)
        
        let trailingConstraint = NSLayoutConstraint(item: faceLoginButton, attribute: NSLayoutAttribute.RightMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.signupB, attribute: NSLayoutAttribute.RightMargin, multiplier: 1, constant: -offSet)
        
        NSLayoutConstraint.activateConstraints([topConstraint, leadingConstraint, trailingConstraint])
        
        // Do any additional setup after loading the view.
    }
    /*override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if FBSDKAccessToken.currentAccessToken() != nil {
            faceLoginButton.hidden = true
        }
    }*/
    
    func adjustTextfiledPosition(constraint: NSLayoutConstraint){
        
        let spacing: CGFloat = -160
        
        constraint.constant = spacing
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let imgWidthHeight: CGFloat = 120
        
        if screenSize.height == 480 { //update constraint for ipad
            
            bruhaFace.frame = CGRectMake((self.view.frame.width*0.5)-(imgWidthHeight*0.5), self.bruhaFace.frame.origin.y, imgWidthHeight, imgWidthHeight)
            
            adjustTextfiledPosition(textBottomSpace)
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
        
        //error = "true" means that there is no error
        error = "true"
        
        error = CredentialCheck().internetCheck()
        
        if error == "true"{
            
            error = CredentialCheck().usernameCheck(username)
            
            if error == "true"{
                
                error = CredentialCheck().passwordCheck(password)
                
                if error == "true" {
                    
                    if verifyPassword.text == self.password.text {
                        
                        error = CredentialCheck().emailCheck(emailaddress)
                        
                        if error == "true"{
                            
                            print("Register conditions are checked!")
                            let registerService = RegisterService(context: managedObjectContext, username: username, password: password, emailaddress: emailaddress)
                            
                            // Running the login service, currently hard coded credentials, needs to take user input
                            
                            registerService.registerNewUser{
                                (let registerResponse) in
                                
                                let mRegisterResponse = registerResponse?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                                //print("the sign up returned value is \(mRegisterResponse)")
                                
                                if mRegisterResponse == "1" {
                                    
                                    dispatch_async(dispatch_get_main_queue()){
                                        let alertController = UIAlertController(title: "Register Successful", message:"Please confirm registration through your Email", preferredStyle: .Alert)
                                        let acceptAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
                                            self.performSegueWithIdentifier("goToSplash", sender: self)
                                        }
                                        alertController.addAction(acceptAction)
                                        self.presentViewController(alertController, animated: true, completion: nil)
                                    }
                                    
                                }
                                else {
                                    dispatch_async(dispatch_get_main_queue()){
                                        let alert = UIAlertView(title: "Resgister Fail", message: mRegisterResponse, delegate: nil, cancelButtonTitle: "OK")
                                        alert.show()
                                    }
                                }
                                
                                /*dispatch_async(dispatch_get_main_queue()){
                                    
                                    let alertController = UIAlertController(title: "Register Successful", message:nil, preferredStyle: .Alert)
                                    
                                    let acceptAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
                                        //self.performSegueWithIdentifier("ProceedToDashBoard", sender: self) // Replace SomeSegue with your segue identifier (name)
                                        
                                        let mUser = User(username: username, userEmail: emailaddress, userCity: "Not Set", userFName: "Not Set", userGender: "Not Set", userBirthdate: "Not Set")
                                        
                                        SaveData(context: self.managedObjectContext).saveUser(mUser)
                                        
                                        GlobalVariables.loggedIn = true
                                    }
                                    
                                    alertController.addAction(acceptAction)
                                    
                                    self.presentViewController(alertController, animated: true, completion: nil)
                                }*/
                                }
                        }
                            
                        else{
                            
                            let alert = UIAlertView(title: "Email Address Error", message: error, delegate: nil, cancelButtonTitle: "OK")
                            alert.show()
                        }
                        
                    } else {
                        let alert = UIAlertView(title: "Password Verification Error", message: "Please verify password match.", delegate: nil, cancelButtonTitle: "OK")
                        alert.show()}
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        bruhaFace.hidden = true
        
        switch textField.tag {
        case 0...3:
            animateViewMoving(true, moveValue: 200)
            
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        bruhaFace.hidden = false
        
        switch textField.tag {
        case 0...3:
            animateViewMoving(false, moveValue: 200)
            
        default:
            break
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
