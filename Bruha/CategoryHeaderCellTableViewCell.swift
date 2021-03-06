//
//  CategoryHeaderCellTableViewCell.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-11-19.
//  Copyright © 2015 Bruha. All rights reserved.
//

import UIKit

class CategoryHeaderCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var arrowimage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    var headerCellSection: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.categoryName?.font = UIFont(name: "OpenSans", size: 18)
        
        //printAllFonts()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        if selected {
//            self.backgroundColor = UIColor.cyanColor()
//            //self.textLabel?.textColor = UIColor.cyanColor()
//        } else {
//            self.backgroundColor = UIColor(red: 1.0, green: 0.710, blue: 0.071, alpha: 1.0)
//        }
        
        
//        let selectedBackgroundView: UIView = UIView()
//        selectedBackgroundView.backgroundColor = UIColor.cyanColor()
        
        // Configure the view for the selected state
    }

    func printAllFonts() {
        let fontFamilyNames = UIFont.familyNames()
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNamesForFamilyName(familyName)
            print("Font Names = [\(names)]")
        }
    }
}
