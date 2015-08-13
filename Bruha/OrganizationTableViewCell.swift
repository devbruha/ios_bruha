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
    @IBOutlet weak var organizationImage: UIImageView!
    @IBOutlet weak var organizationName: UILabel!
    @IBOutlet weak var organizationDescription: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var circOrgName: UILabel!
    @IBOutlet weak var rectView: EventRectangleView!
    
    @IBOutlet weak var circView: EventCircleView!
    
    let tapRec = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userInteractionEnabled = true
        rectView.hidden = true
        tapRec.addTarget(self, action: "tappedView:")
        self.addGestureRecognizer(tapRec)
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    func tappedView(){
        
        if(!circView.hidden && !rectView.hidden){
            circView.hidden = true
        }else if(circView.hidden){
            circView.hidden = false
            rectView.hidden = true
        }else{
            circView.hidden = true
            rectView.hidden = false
        }
    }

    
}