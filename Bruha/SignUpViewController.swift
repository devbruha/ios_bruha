//
//  SignUpViewController.swift
//  Bruha
//
//  Created by lye on 15/7/17.
//  Copyright (c) 2015年 lye. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    // Retreive the managedObjectContext from AppDelegate
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var emailaddress: UITextField!
    @IBOutlet weak var continueWithoutRegister: UIButton!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    func continueButtonTapped(){
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.performSegueWithIdentifier("ProceedToDashBoard", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var tgr = UITapGestureRecognizer(target:self , action: Selector("continueButtonTapped"))
        continueWithoutRegister.addGestureRecognizer(tgr)
        continueWithoutRegister.userInteractionEnabled = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Register Check
    var error :String = "No Error"
    func usernameCheck(username:String) -> String{
        if count(username) >= 6 && count(username) <= 20{
            let regex = NSRegularExpression(pattern: ".*[^A-Za-z0-9_].*", options: nil, error: nil)!
            if regex.firstMatchInString(username, options: nil, range: NSMakeRange(0, count(username))) == nil{
                return "true"
            }
            else{
                error = "SignUp failed. Username must use characters from A to Z, a to z, 0 to 9 or _"
            }
        }
        else{
            error = "SignUp faild. Username must have the length between 6 and 20"
        }
        return error
    }
    func passwordCheck(password:String) -> String{
        if count(password) >= 8 && count(password) <= 20 {
            let characters = NSRegularExpression(pattern: ".*[^A-Za-z0-9_].*", options: nil, error: nil)!
            if characters.firstMatchInString(password, options: nil, range: NSMakeRange(0, count(password))) == nil{
                let capitalLetterRegEx  = NSRegularExpression(pattern: ".*[A-Z]+.*", options: nil, error: nil)!
                if capitalLetterRegEx.firstMatchInString(password, options: nil, range: NSMakeRange(0,count(password))) != nil{
                    return "true"
                }
                else{
                    error = "SignUp failed. Password must contain at least one capital letter."
                }
                
            }
            else{
                error = "SignUp failed. Password must use characters from A to Z, a to z, 0 to 9 or _ "
            }
            
        }
        else{
            error = "SignUp failed. Password must has the length between 8 to 20"
        }
        return error
    }
    func internetCheck() -> String {
        if Reachability.isConnectedToNetwork() == true{
            return "true"
        }
        else{
            error = "No internet connection"
        }
        return error
    }
    func isValidEmail(testStr:String) -> String{
        
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluateWithObject(testStr) == true{
            return "true"
        }
        else{
            error = "Not a valid email."
        }
        return error
    }
    
    

    
    @IBAction func registerButtonClick(sender: AnyObject) {
        
        var username:String = self.username.text
        var password:String = self.password.text
        var emailaddress:String = self.emailaddress.text
        
        // Creating an instance of the LoginService
        if internetCheck() == "true"{
            if usernameCheck(username) == "true"{
                if passwordCheck(password) == "true"{
                    if isValidEmail(emailaddress) == "true"{
                        println("Register conditions are checked!")
                        let registerService = RegisterService(context: managedObjectContext, username: username, password: password, emailaddress: emailaddress)
                        
                        // Running the login service, currently hard coded credentials, needs to take user input
                        
                        registerService.registerNewUser{
                            (let registerResponse) in
                            
                            dispatch_async(dispatch_get_main_queue()){
                                let alertController = UIAlertController(title: "Register Successful", message:nil, preferredStyle: .Alert)
                                let acceptAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
                                    self.performSegueWithIdentifier("ProceedToDashBoard", sender: self) // Replace SomeSegue with your segue identifier (name)
                                }
                                alertController.addAction(acceptAction)
                                
                                self.presentViewController(alertController, animated: true, completion: nil)
                            }
                        }

                    }
                    else{
                        var alert = UIAlertView(title: "Email Address is not valid", message: error, delegate: nil, cancelButtonTitle: "OK")
                        alert.show()
                    }
                }
                else{
                    var alert = UIAlertView(title: "Password is not valid", message: error, delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
            }
            else{
                var alert = UIAlertView(title: "Username is not valid", message: error, delegate: nil, cancelButtonTitle: "OK")
                alert.show()

            }
            
        }
        else{
            var alert = UIAlertView(title: "No Internet Connection", message: error, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        
        
        
        /*if usernameCheck(username) == true && passwordCheck(password) == true && internetCheck() == true && isValidEmail(emailaddress) == true {
            println("Register conditions are checked!")
            let registerService = RegisterService(context: managedObjectContext, username: username, password: password, emailaddress: emailaddress)
        
            // Running the login service, currently hard coded credentials, needs to take user input
        
            registerService.registerNewUser{
                (let registerResponse) in
            
                println(registerResponse!)
            }

        }*/
        
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
