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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
