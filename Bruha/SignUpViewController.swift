//
//  SignUpViewController.swift
//  Bruha
//
//  Created by lye on 15/7/17.
//  Copyright (c) 2015年 lye. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var emailaddress: UITextField!
    @IBOutlet weak var continueWithoutRegister: UIButton!
    
    // Retreive the managedObjectContext from AppDelegate
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var error: String = "true"
    
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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
