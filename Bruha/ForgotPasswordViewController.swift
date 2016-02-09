//
//  ForgotPasswordViewController.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2016-02-08.
//  Copyright © 2016 Bruha. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var continueWithoutLogIn: UIButton!
    @IBOutlet weak var registerB: UIButton!
    @IBOutlet weak var bruhaFace: UIImageView!
    @IBOutlet weak var sendReset: UIButton!
    
    
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
        self.userEmail.delegate = self
        
        self.username.tag = 0
        self.userEmail.tag = 1
        
        let tgr = UITapGestureRecognizer(target:self , action: Selector("continueButtonTapped"))
        continueWithoutLogIn.addGestureRecognizer(tgr)
        continueWithoutLogIn.userInteractionEnabled = true
        
        registerB.layer.cornerRadius = 2
        registerB.clipsToBounds = true
        continueWithoutLogIn.layer.cornerRadius = 2
        continueWithoutLogIn.clipsToBounds = true
        sendReset.layer.cornerRadius = 2
        sendReset.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func resetPassword(completion: (NSString? -> Void)) {
        
        let bruhaBaseURL: NSURL? = NSURL(string: "http://bruha.com/mobile_php/CredentialsPHP/")
        
        if let resetPassURL = NSURL(string: "forgotPassword.php?", relativeToURL: bruhaBaseURL) {
            
            let networkOperation = NetworkOperation(url: resetPassURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                print("-\(self.username.text)-and-\(self.userEmail.text)-")
                networkOperation.stringFromURLPost("forget-username=\(self.username.text)&forget-email=\(self.userEmail.text)") {
                    
                    (let resetSignal) in
                    //print("-\(self.username.text)-and-\(self.userEmail.text)-")
                    completion(resetSignal)
                }
            }
        }
            
        else {
            print("Could not construct a valid URL")
        }
    }
    
    
    // Login Button Onclick logic
    
    
    @IBAction func loginPress(sender: AnyObject) {
        
        let username:String = self.username.text!
        let password:String = self.userEmail.text!
        
        resetPassword {
            (let resetResponse) in
            print(resetResponse, "is the returned value")
        }
        
        /*
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
                        
                        if (loginResponse! == "  1"){
                            
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
                            
                        else{
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                let alert = UIAlertView(title: "Login Failed", message: "Password and username pair does not exists", delegate: nil, cancelButtonTitle: "OK")
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
        }*/
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
        animateViewMoving(true, moveValue: 253)
        /*if textField.tag == 0 {
            animateViewMoving(true, moveValue: 253)
        }
        else if textField.tag == 1 {
            animateViewMoving(true, moveValue: 216)
        }*/
    }
    func textFieldDidEndEditing(textField: UITextField) {
        bruhaFace.hidden = false
        animateViewMoving(false, moveValue: 253)
        /*if textField.tag == 0 {
            animateViewMoving(false, moveValue: 253)
        }
        else if textField.tag == 1 {
            animateViewMoving(false, moveValue: 216)
        }*/
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
