//
//  NetworkOperation.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-07.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

// Three types of network calls currently; one to retrieve JSON from URL request, another to retrieve retrieve from POST, and one to retrieve string response from
// URL request

class NetworkOperation {
    
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    
    let queryURL : NSURL
    
    typealias JSONArrayCompletion = (NSArray?) -> Void
    typealias stringCompletion = (NSString?) -> Void
    typealias JSONDictionaryCompletion = (NSDictionary?) -> Void
    
    init(url: NSURL){
        
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion: JSONArrayCompletion){
        
        let dataTask = session.dataTaskWithURL(queryURL) {
            (let data, let response, let error) in
            
            //1. CHeck http response for successful GET request
            
            if let httpResponse = response as? NSHTTPURLResponse{
                
                switch(httpResponse.statusCode){
                    
                case 200:
                    
                    let json = (try? NSJSONSerialization.JSONObjectWithData(data!, options: [])) as? NSArray
                    
                    completion(json)
                    
                    //2. Create JSON object with data
                default:
                    print("GET request not successful. HTTP status code: \(httpResponse.statusCode)")
                }
            }
            else{
                print("Error: Not a vaild HTTP response")
            }
        }
        
        dataTask.resume()
    }
    
    func stringFromURLPost(post: String, completion: stringCompletion){
        
        let request = NSMutableURLRequest(URL: queryURL)
        request.HTTPMethod = "POST"
        
        let postString = post
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            //1. CHeck http response for successful GET request
            
            if let httpResponse = response as? NSHTTPURLResponse{
                
                switch(httpResponse.statusCode){
                    
                case 200:
                    
                    completion(NSString(data: data!, encoding: NSUTF8StringEncoding))
                    
                    //2. Create JSON object with data
                default:
                    print("GET request not successful. HTTP status code: \(httpResponse.statusCode)")
                }
            }
            else{
                print("Error: Not a vaild HTTP response")
            }
        }
        
        dataTask.resume()
    }
    
    func downloadJSONFromURLPost(post: String, completion: JSONArrayCompletion){
        
        let request = NSMutableURLRequest(URL: queryURL)
        request.HTTPMethod = "POST"
        
        let postString = post
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            //1. CHeck http response for successful GET request
            
            if let httpResponse = response as? NSHTTPURLResponse{
                
                switch(httpResponse.statusCode){
                    
                case 200:
                    
                    let json = (try? NSJSONSerialization.JSONObjectWithData(data!, options: [])) as? NSArray
                    print(self.queryURL)
                    completion(json)
                    
                    //2. Create JSON object with data
                default:
                    print("GET request not successful. HTTP status code: \(httpResponse.statusCode)")
                    print(self.queryURL)
                }
            }
            else{
                print("Error: Not a vaild HTTP response")
            }
        }
        
        dataTask.resume()
    }
    
    func downloadJSONDictionaryFromURL(completion: JSONDictionaryCompletion){
        
        let dataTask = session.dataTaskWithURL(queryURL) {
            (let data, let response, let error) in
            
            //1. CHeck http response for successful GET request
            
            if let httpResponse = response as? NSHTTPURLResponse{
                
                switch(httpResponse.statusCode){
                    
                case 200:
                    
                    let json = (try? NSJSONSerialization.JSONObjectWithData(data!, options: [])) as? NSDictionary
                    
                    completion(json)
                    
                    //2. Create JSON object with data
                default:
                    print("GET request not successful. HTTP status code: \(httpResponse.statusCode)")
                }
            }
            else{
                print("Error: Not a vaild HTTP response")
            }
        }
        
        dataTask.resume()
    }
}