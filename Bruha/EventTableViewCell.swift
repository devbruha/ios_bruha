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
    
    @IBOutlet weak var circTitle: UILabel!
    @IBOutlet weak var circDate: UILabel!
    @IBOutlet weak var circPrice: UILabel!
    
    @IBOutlet weak var rectTitle: UILabel!
    @IBOutlet weak var rectPrice: UILabel!
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var venueAddress: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
   
    let tapRec = UITapGestureRecognizer()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.userInteractionEnabled = true
        
        rectView.hidden = true
        tapRec.addTarget(self, action: "tappedView:")
        self.addGestureRecognizer(tapRec)
        
        /*println("Begin of code")
        ExploreImage.contentMode = UIViewContentMode.ScaleToFill
        if let checkedUrl = NSURL(string: "http://www.bruha.com/WorkingWebsite/assets/uploads/Events/0/cat.jpg") {
            downloadImage(checkedUrl)
        }
        println("End of code. The image will continue downloading in the background and it will be loaded when it ends.")*/
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
    /*func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    func downloadImage(url:NSURL){
        println("Started downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                println("Finished downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
                self.ExploreImage.image = UIImage(data: data!)
            }
        }
    }*/


}
