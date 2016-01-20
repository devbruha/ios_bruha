//
//  MapDropTableViewCell.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-11-06.
//  Copyright © 2015 Bruha. All rights reserved.
//

import UIKit

class MapDropTableViewCell: SWTableViewCell {
    
    @IBOutlet var dropTitle: UILabel!
    @IBOutlet var dropPrice: UILabel!
    @IBOutlet var dropContent: UILabel!
    @IBOutlet var dropStartDate: UILabel!
    @IBOutlet var dropImage: UIImageView!
    @IBOutlet var dropHiddenID: UILabel!
    @IBOutlet weak var swipeRight: UIImageView!
    @IBOutlet weak var swipeLeft: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let verticleLine = UIView.init(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width - 0.25, 0, 0.25, self.contentView.layer.bounds.height))
        
        verticleLine.backgroundColor = UIColor.whiteColor()
        
        self.contentView.addSubview(verticleLine)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func animate() {
        
        UIView.animateWithDuration(1.5, delay: 0, options: [.Autoreverse, .Repeat], animations: { () -> Void in
            self.swipeRight.alpha = 0
            self.swipeLeft.alpha = 0
            }, completion: nil)
    }

}
