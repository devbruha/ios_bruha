//
//  ExplorePanelViewTableViewCell.swift
//  Bruha
//
//  Created by lye on 15/8/13.
//  Copyright (c) 2015年 Bruha. All rights reserved.
//

import UIKit

class ExplorePanelViewTableViewCell: UITableViewCell {
    @IBOutlet weak var picker: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    class var expandedHeight: CGFloat {get {return 450}}
    class var defaultHeight: CGFloat {get {return 35}}
    
    func checkHeight(){
        picker.hidden = (frame.size.height < ExplorePanelViewTableViewCell.expandedHeight)
    }
    func watchFrameChanges() {
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New|NSKeyValueObservingOptions.Initial, context: nil)
        checkHeight()
    }
    
    func ignoreFrameChanges() {
        removeObserver(self, forKeyPath: "frame")
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
}
