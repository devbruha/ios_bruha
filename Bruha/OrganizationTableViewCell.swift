//
//  OrganizationTableViewCell.swift
//  Bruha
//
//  Created by Ryan O'Neill on 2015-08-10.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import UIKit

class OrganizationTableViewCell: SWTableViewCell {
    
    @IBOutlet weak var organizationLabel: UILabel!
    
    let tapRec = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userInteractionEnabled = true
        
        tapRec.addTarget(self, action: "tappedView:")
        self.addGestureRecognizer(tapRec)
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    
}