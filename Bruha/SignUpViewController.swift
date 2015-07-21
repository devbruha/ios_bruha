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
    
    @IBAction func registerButtonClick(sender: AnyObject) {
        
        var username:String = self.username.text
        var password:String = self.password.text
        var emailaddress:String = self.emailaddress.text
        
        // Creating an instance of the LoginService
        
        let registerService = RegisterService(context: managedObjectContext, username: username, password: password, emailaddress: emailaddress)
        
        // Running the login service, currently hard coded credentials, needs to take user input
        
        registerService.registerNewUser{
            (let registerResponse) in
            
            println(registerResponse!)
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
