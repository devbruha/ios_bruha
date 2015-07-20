//
//  LoginViewController.swift
//  Bruha
//
//  Created by lye on 15/7/17.
//  Copyright (c) 2015年 lye. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
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
    
    @IBAction func loginPress(sender: AnyObject) {
        
        // Creating an instance of the LoginService
        
        let loginService = LoginService(context: managedObjectContext)
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
