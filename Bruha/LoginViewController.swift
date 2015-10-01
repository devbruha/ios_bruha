//
//  LoginViewController.swift
//  Bruha
//
//  Created by lye on 15/7/17.
//  Copyright (c) 2015年 lye. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var continueWithoutLogIn: UIButton!
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var error: String = "true"
    
    func continueButtonTapped(){
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.performSegueWithIdentifier("ProceedToDashBoard", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tgr = UITapGestureRecognizer(target:self , action: Selector("continueButtonTapped"))
        continueWithoutLogIn.addGestureRecognizer(tgr)
        continueWithoutLogIn.userInteractionEnabled = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Login Button Onclick logic
   
    
    @IBAction func loginPress(sender: AnyObject) {
        
        var username:String = self.username.text!
        var password:String = self.password.text!
        
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
                                    
                                    GlobalVariables.loggedIn = true
                                }
                                
                                alertController.addAction(acceptAction)
                                
                                self.presentViewController(alertController, animated: true, completion: nil)
                            }
                        }
                            
                        else{
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                var alert = UIAlertView(title: "Login Failed", message: "Password and username pair does not exists", delegate: nil, cancelButtonTitle: "OK")
                                alert.show()
                            }
                        }
                    }

                }
                else{
                    var alert = UIAlertView(title: "Password Error", message: error, delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
            }
                
            else{
                var alert = UIAlertView(title: "Username Error", message: error, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        }
            
        else{
            var alert = UIAlertView(title: "No Internet Connection", message: error, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
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
