//
//  VenueTableViewCell.swift
//  Bruha
//
//  Created by Ryan O'Neill on 2015-08-10.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import UIKit

class VenueTableViewCell: SWTableViewCell {
    
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var rectView: EventRectangleView!
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var venueAddress: UILabel!
    @IBOutlet weak var venueDescription: UILabel!
    @IBOutlet weak var circVenueName: UILabel!
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