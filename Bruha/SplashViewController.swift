//
//  SplashViewController.swift
//  Bruha
//
//  Created by lye on 15/7/17.
//  Copyright (c) 2015年 lye. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController,UIScrollViewDelegate {
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Clearing data from CoreDate to ensure up to date information
            
        DeleteData(context: self.managedObjectContext).deleteAll()
        
        // Retrieving all events/venues/artists/organizations and storing locally
            
        LoadScreenService(context: self.managedObjectContext).retrieveAll()

        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width-20
        let scrollViewHeight:CGFloat = self.scrollView.frame.height-168
        //2
        self.skipButton.layer.cornerRadius = 4.0
        //3
        let imgOne = SplashView.instanceFromNib1()
        imgOne.frame = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight)
        let imgTwo = SplashView.instanceFromNib2()
        imgTwo.frame = CGRectMake(scrollViewWidth, 0,scrollViewWidth+20, scrollViewHeight+168)
        let imgThree = SplashView.instanceFromNib3()
        imgThree.frame = CGRectMake(scrollViewWidth*2, 0,scrollViewWidth+20, scrollViewHeight+168)
        let imgFour = SplashView.instanceFromNib4()
        imgFour.frame = CGRectMake(scrollViewWidth*3, 0,scrollViewWidth+20, scrollViewHeight+168)
        let imgFive = SplashView.instanceFromNib5()
        imgFive.frame = CGRectMake(scrollViewWidth*4, 0,scrollViewWidth+20, scrollViewHeight+168)
        
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        self.scrollView.addSubview(imgFour)
        self.scrollView.addSubview(imgFive)
        //4
        //self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * 5, self.scrollView.frame.height)
        self.scrollView.contentSize = CGSizeMake(scrollViewWidth*5, scrollViewHeight)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = CGRectGetWidth(scrollView.frame)
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
