//
//  ExploreTableViewCell.swift
//  Bruha
//
//  Created by lye on 15/7/27.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

class EventTableViewCell: SWTableViewCell {
    
    @IBOutlet weak var ExploreImage: UIImageView!
    @IBOutlet weak var circView: EventCircleView!
    @IBOutlet weak var rectView: EventRectangleView!
    @IBOutlet weak var circAddicted: UIImageView!
    @IBOutlet weak var circCategory: UIImageView!
    
    @IBOutlet weak var circTitle: UILabel!
    @IBOutlet weak var circDate: UILabel!
    @IBOutlet weak var circPrice: UILabel!
    @IBOutlet weak var circHiddenID: UILabel!
    
    @IBOutlet weak var rectTitle: UILabel!
    @IBOutlet weak var rectPrice: UILabel!
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var venueAddress: UILabel!
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var rectCategory: UIImageView!
    @IBOutlet weak var rectCategoryName: UILabel!
    
    @IBOutlet weak var swipeRight: UIImageView!
    @IBOutlet weak var swipeLeft: UIImageView!
   
   
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

    func animate() {
       
        UIView.animateWithDuration(1.5, delay: 0, options: [.Autoreverse, .Repeat], animations: { () -> Void in
            self.swipeRight.alpha = 0
            self.swipeLeft.alpha = 0
            }, completion: nil)
    }

}
