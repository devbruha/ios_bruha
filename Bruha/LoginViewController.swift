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
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Login Button Onclick logic
    func usernameCheck(username:String) -> Bool{
        if count(username) >= 6 && count(username) <= 20{
            println("Username Length Checked")
            let regex = NSRegularExpression(pattern: ".*[^A-Za-z0-9_].*", options: nil, error: nil)!
            if regex.firstMatchInString(username, options: nil, range: NSMakeRange(0, count(username))) == nil {
                //println("could not handle special characters")
                println("Username Characters are checked")
                return true
            }
        }
        return false
    }
    func passwordCheck(password:String) -> Bool{
        if count(password) >= 8 && count(password) <= 20{
            println("Password Length checked")
            let characters = NSRegularExpression(pattern: ".*[^A-Za-z0-9_].*", options: nil, error: nil)!
            if characters.firstMatchInString(password, options: nil, range: NSMakeRange(0, count(password))) == nil{
                println("password characters are valid")
                let capitalLetterRegEx  = NSRegularExpression(pattern: ".*[A-Z]+.*", options: nil, error: nil)!
                if capitalLetterRegEx.firstMatchInString(password, options: nil, range: NSMakeRange(0,count(password))) != nil {
                println("capitalized")
                return true
                }
            }
        }
        return false
    }
    func internetCheck() -> Bool{
        
        if Reachability.isConnectedToNetwork() == true {
            println("Internet connection OK")
            
            return true
        }
        return false
    }
    
    @IBAction func loginPress(sender: AnyObject) {
        
        var username:String = self.username.text
        var password:String = self.password.text
/*
        var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
*/
        
        if usernameCheck(username) == true && passwordCheck(password) == true && internetCheck() == true {
            println("ALL CONDITIONS ARE OKOKOK")
            
            let loginService = LoginService(context: managedObjectContext, username: username, password: password)
        
            // Running the login service, currently hard coded credentials, needs to take user input
            
            loginService.loginCheck {
                (let loginResponse) in
                
                println(loginResponse!)
                
                // If server response from credential check = "1", procede with downloading user info
                
                if (loginResponse! == "  1"){
                    
                    loginService.getUserInformation{
                        (let userInfo) in
                        
                     }
                }
                    
                else{
                    
                    println("Failed Login")
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
