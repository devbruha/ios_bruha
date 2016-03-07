//
//  Reachability.swift
//  Bruha
//
//  Created by lye on 15/7/21.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import Foundation
public class Reachability {
    
    class func isConnectedToNetwork()->Bool{
        
        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        var data = (try? NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        return Status
    }
    
    class func internetCheck(controller: UIViewController) {
        
        if !isConnectedToNetwork() {
            let error = "The Information displayed is not up to date and some of our features will not be available to you due to no internet connection being detected. Please turn on your internet connection and restart the app to get updated information."
            let alertController = UIAlertController(title: "No Internet Connection Detected!", message:error, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            controller.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}