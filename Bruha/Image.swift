//
//  Image.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-11-23.
//  Copyright © 2015 Bruha. All rights reserved.
//

import Foundation

struct Image {
    var ID: String
    var Image: UIImage
    
    init(id: String, image: UIImage) {
        ID = id
        Image = image
    }
}