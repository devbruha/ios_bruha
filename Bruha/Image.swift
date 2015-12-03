//
//  Image.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-11-23.
//  Copyright © 2015 Bruha. All rights reserved.
//

import Foundation

struct Image {
    var ID: String?
    var Image: NSData?
    
    init(id: String, image: NSData) {
        ID = id
        Image = image
    }
    
    init(fetchResults: ImageDBModel){
        if let Id = fetchResults.id {
            ID = Id
        } else {
            ID = ""
        }
        
        if let image = fetchResults.imageData {
            Image = image
        } else {
            Image = nil
        }
        
    }
}