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
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
        } else {
            println("Internet connection FAILED")
        }
        return false
    }
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    

    
    @IBAction func registerButtonClick(sender: AnyObject) {
        
        var username:String = self.username.text
        var password:String = self.password.text
        var emailaddress:String = self.emailaddress.text
        
        // Creating an instance of the LoginService
        if usernameCheck(username) == true && passwordCheck(password) == true && internetCheck() == true && isValidEmail(emailaddress) == true {
            println("Register conditions are checked!")
            let registerService = RegisterService(context: managedObjectContext, username: username, password: password, emailaddress: emailaddress)
        
            // Running the login service, currently hard coded credentials, needs to take user input
        
            registerService.registerNewUser{
                (let registerResponse) in
            
                println(registerResponse!)
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
