//
//  AffiliatedOrgViewController.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2016-01-04.
//  Copyright © 2016 Bruha. All rights reserved.
//

import UIKit

class AffiliatedOrgViewController: UIViewController, SWTableViewCellDelegate {
    
    @IBOutlet weak var affiliatedOrgTable: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var bruhaButton: UIButton!
    
    @IBOutlet weak var affiliatedOrgLabel: UILabel!
    
    @IBOutlet weak var affiliatedOrgHeightLabel: NSLayoutConstraint!
    
    @IBOutlet weak var affiliatedOrgWidthLabel: NSLayoutConstraint!
    
    @IBOutlet weak var affiliatedOrgImage: UIImageView!

    @IBOutlet weak var affiliatedOrgWidthImage: NSLayoutConstraint!
    
    @IBOutlet weak var affiliatedOrgHeightImage: NSLayoutConstraint!
    
    
    @IBAction func backToExploreButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    
    var affiliatedOrg: [Organization] = []
    var sourceID: [String] = []
    
    var addictionInfo: [AddictionOrganization]?
    
    func configureView(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        affiliatedOrgTable.rowHeight = ( screenHeight - screenHeight * 70 / 568 ) * 0.5
        
        self.affiliatedOrgTable!.allowsMultipleSelection = false
    }
    
    func customTopButtons() {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        bruhaButton.setBackgroundImage(UIImage(named: "Bruha_White"), forState: UIControlState.Normal)
        let heightContraints = NSLayoutConstraint(item: bruhaButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.height/15.5)
        heightContraints.priority = UILayoutPriorityDefaultHigh
        
        let widthContraints = NSLayoutConstraint(item: bruhaButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.width/9)
        widthContraints.priority = UILayoutPriorityDefaultHigh
        
        bruhaButton.addConstraints([heightContraints, widthContraints])
        
        backButton.setBackgroundImage(UIImage(named: "arrow-left"), forState: UIControlState.Normal)
        let heightContraint = NSLayoutConstraint(item: backButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.height/15.5)
        heightContraint.priority = UILayoutPriorityDefaultHigh
        
        let widthContraint = NSLayoutConstraint(item: backButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenSize.width/9)
        widthContraint.priority = UILayoutPriorityDefaultHigh
        
        backButton.addConstraints([heightContraint, widthContraint])
        
        self.view.bringSubviewToFront(backButton)
        self.view.bringSubviewToFront(bruhaButton)
        
        
        adjustLabelConstraint(affiliatedOrgWidthLabel)
        adjustImageConstraint(affiliatedOrgHeightLabel)
        adjustImageConstraint(affiliatedOrgHeightImage)
        adjustImageConstraint(affiliatedOrgWidthImage)
        
        affiliatedOrgLabel.adjustsFontSizeToFitWidth = true
    }
    
    func adjustLabelConstraint(constraint: NSLayoutConstraint) {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        constraint.constant = screenSize.height * 0.3
    }
    func adjustImageConstraint(constraint: NSLayoutConstraint) {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        constraint.constant = screenSize.height/15.5
    }

    func animateHeader() {
        UIView.animateWithDuration(1.5, delay: 0.0, options: [.TransitionFlipFromLeft], animations: { () -> Void in
            self.affiliatedOrgLabel.alpha = 1
            self.affiliatedOrgImage.alpha = 1
            }) {(finished) -> Void in
                
                UIView.animateWithDuration(2.5, delay: 0.3, options: [.TransitionFlipFromRight], animations: { () -> Void in
                    self.affiliatedOrgLabel.alpha = 0.0
                    self.affiliatedOrgImage.alpha = 0.0
                    }) {(finished) -> Void in
                }
        }
    }
    
    func customStatusBar() {
        let barView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        barView.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
        //barView.alpha = 0.5
        self.view.addSubview(barView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        //customTopButtons()
        customStatusBar()
        
        //affiliatedOrgTable.backgroundColor = UIColor(red: 36/255, green: 22/255, blue: 63/255, alpha: 1)
        affiliatedOrgTable.separatorColor = UIColor.clearColor()
        
        self.affiliatedOrgLabel.alpha = 0.0
        self.affiliatedOrgImage.alpha = 0.0
        
        backgroundGradient()
        
        affiliatedOrg.removeAll()
        
        let organizationInfo = FetchData(context: managedObjectContext).fetchOrganizations()!
        
        for orgID in sourceID {
            if organizationInfo.contains({$0.organizationID == orgID}) {
                let idx = organizationInfo.indexOf({$0.organizationID == orgID})!
                affiliatedOrg.append(organizationInfo[idx])
            }
        }

        // Do any additional setup after loading the view.
        addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsOrganization()
    }
    
    func backgroundGradient() {
        let background = CAGradientLayer().gradientColor()
        background.frame = self.view.bounds
        self.affiliatedOrgTable.layer.insertSublayer(background, atIndex: 0)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        animateHeader()
        affiliatedOrgTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        print("no. of aff org is:", affiliatedOrg.count)
        return (affiliatedOrg.count)
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let animatedCell = cell as? OrganizationTableViewCell {
            animatedCell.animate()
        }
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let posterInfo = FetchData(context: managedObjectContext).fetchPosterImages()
        if GlobalVariables.eventImageCache.count >= 50 { GlobalVariables.eventImageCache.removeAtIndex(0) }
        if GlobalVariables.venueImageCache.count >= 50 { GlobalVariables.venueImageCache.removeAtIndex(0) }
        if GlobalVariables.organizationImageCache.count >= 50 { GlobalVariables.organizationImageCache.removeAtIndex(0) }
        
        var cell : OrganizationTableViewCell! = tableView.dequeueReusableCellWithIdentifier("organizationTableViewCell") as! OrganizationTableViewCell!
        
        if(cell == nil){
            
            cell = NSBundle.mainBundle().loadNibNamed("OrganizationTableViewCell", owner: self, options: nil)[0] as! OrganizationTableViewCell;
        }
        
        let organization = affiliatedOrg[indexPath.row]
        
        cell.organizationImage.contentMode = UIViewContentMode.ScaleToFill
        if let img = GlobalVariables.organizationImageCache[organization.organizationID] {
            cell.organizationImage.image = img
        }
        else if let checkedUrl = NSURL(string:organization.posterUrl) {
            
            self.getDataFromUrl(checkedUrl) { data in
                dispatch_async(dispatch_get_main_queue()) {
                    if let downloadImg = data {
                        if downloadImg.length > 800 {
                            
                            let image = UIImage(data: downloadImg)
                            GlobalVariables.venueImageCache[organization.organizationID] = image
                            cell.organizationImage.image = image
                        } else {
                            cell.organizationImage.image = self.randomImage()
                        }
                    }
                    else {
                        cell.organizationImage.image = self.randomImage()
                    }
                }
            }
        }
        
        cell.organizationName.text = organization.organizationName
        cell.organizationDescription.text = organization.organizationName
        cell.address.text = "\(organization.organizationAddress.componentsSeparatedByString(", ")[0])"
        cell.circOrgName.text = organization.organizationName
        cell.circHiddenID.text = organization.organizationID
        
        cell.circAddicted.contentMode = UIViewContentMode.ScaleAspectFit
        cell.circAddicted.image = UIImage(named: "MyAddictions_Sm")
        cell.circCategory.contentMode = UIViewContentMode.ScaleAspectFit
        cell.circCategory.image = UIImage(named: organization.primaryCategory)
        
        cell.rectCategory.contentMode = UIViewContentMode.ScaleAspectFill
        cell.rectCategory.image = UIImage(named: organization.primaryCategory)
        cell.rectCategoryName.text = organization.primaryCategory
        // Configure the cell...
        
        
        var like = 0
        
        for addict in addictionInfo! {
            if addict.organizationID == organization.organizationID {
                like = 1
            }
        }
        
        
        let temp: NSMutableArray = NSMutableArray()
        
        if like == 0 {
            temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),attributedTitle: swipeCellTitle("Get Addicted"))
            cell.circAddicted.hidden = true
        } else if like == 1 {
            temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),attributedTitle: swipeCellTitle("Addicted!"))
            cell.circAddicted.hidden = false
        }
        
        cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
        cell.leftUtilityButtons = temp as [AnyObject]
        
        
        let temp2: NSMutableArray = NSMutableArray()
        
        temp2.sw_addUtilityButtonWithColor(UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1), attributedTitle: swipeCellTitle("Map"))
        temp2.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1), attributedTitle: swipeCellTitle("More\nInfo"))
        
        cell.rightUtilityButtons = nil
        cell.setRightUtilityButtons(temp2 as [AnyObject], withButtonWidth: 75)
        cell.rightUtilityButtons = temp2 as [AnyObject]
        
        cell.delegate = self
        cell.selectionStyle = .None
        
        return cell as OrganizationTableViewCell
        
    }
    
    //Swipe Cells Actions
    func swipeableTableViewCell( cell : SWTableViewCell!,didTriggerLeftUtilityButtonWithIndex index:NSInteger){
        switch(index){
        case 0:
            //Like and get addicted
            // Check if user is logged in
            if GlobalVariables.loggedIn == true {
                let user = FetchData(context: managedObjectContext).fetchUserInfo()![0].userName
                
                var cellIndexPath = self.affiliatedOrgTable.indexPathForCell(cell)
                var selectedCell = self.affiliatedOrgTable.cellForRowAtIndexPath(cellIndexPath!) as! OrganizationTableViewCell
                GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
                
                let organizationInfo = affiliatedOrg
                for organization in organizationInfo{
                    if organization.organizationID == GlobalVariables.eventSelected {
                        //Like and Unlike
                        if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Addicted!"){
                            
                            let alertController = UIAlertController(title: "Are you no longer addicted?", message:nil, preferredStyle: .Alert)
                            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                            let unlikeAction = UIAlertAction(title: "I'm Over It", style: .Default) { (_) -> Void in
                                
                                DeleteData(context: self.managedObjectContext).deleteAddictionsOrgainzation(organization.organizationID, deleteUser: user)
                                print("Removed from addiction(event) \(organization.organizationID)")
                                print("REMOVED")
                                
                                self.updateAddictFetch()
                                
                                let organizationService = OrganizationService()
                                
                                organizationService.removeAddictedOrganizations(organization.organizationID) {
                                    (let removeInfo ) in
                                    print(removeInfo!)
                                }
                                
                                let temp: NSMutableArray = NSMutableArray()
                                temp.sw_addUtilityButtonWithColor(UIColor(red: 70/255, green: 190/255, blue: 194/255, alpha: 1),attributedTitle: self.swipeCellTitle("Get Addicted"))
                                cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
                                cell.leftUtilityButtons = temp as [AnyObject]
                                
                                selectedCell.circAddicted.hidden = true
                                
                            }
                            alertController.addAction(unlikeAction)
                            alertController.addAction(cancelAction)
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                            
                        } else if(cell.leftUtilityButtons[0].titleLabel!!.text! == "Get Addicted") {
                            
                            let addOrgainzation = AddictionOrganization(organizationId: organization.organizationID, userId: user)
                            SaveData(context: managedObjectContext).saveAddictionOrganization(addOrgainzation)
                            print("Getting Addicted with event id \(organization.organizationID)")
                            print("ADDICTED")
                            
                            updateAddictFetch()
                            
                            let organizationService = OrganizationService()
                            
                            organizationService.addAddictedOrganizations(organization.organizationID) {
                                (let addInfo ) in
                                print(addInfo!)
                            }
                            
                            let temp: NSMutableArray = NSMutableArray()
                            temp.sw_addUtilityButtonWithColor(UIColor(red: 244/255, green: 117/255, blue: 33/255, alpha: 1),attributedTitle: swipeCellTitle("Addicted!"))
                            cell.setLeftUtilityButtons(temp as [AnyObject], withButtonWidth: 75)
                            cell.leftUtilityButtons = temp as [AnyObject]
                            
                            selectedCell.circAddicted.hidden = false
                        }
                    }
                }
            
            } else {
                
                alertLogin()
                
            }
            
        default:
            break
        }
    }
    
    func alertLogin() {
        let alertController = UIAlertController(title: "You are not logged in!", message:nil, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        let loginAction = UIAlertAction(title: "Login", style: .Default) { (_) -> Void in
            self.performSegueWithIdentifier("GoToLogin", sender: self) // Replace SomeSegue with your segue identifier (name)
        }
        let signupAction = UIAlertAction(title: "Signup", style: .Default) { (_) -> Void in
            self.performSegueWithIdentifier("GoToSignup", sender: self) // Replace SomeSegue with your segue identifier (name)
        }
        alertController.addAction(signupAction)
        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func swipeableTableViewCell( cell : SWTableViewCell!,didTriggerRightUtilityButtonWithIndex index:NSInteger){
        
        switch(index){
        case 0:
            
            let cellIndexPath = self.affiliatedOrgTable.indexPathForCell(cell)
            let selectedCell = self.affiliatedOrgTable.cellForRowAtIndexPath(cellIndexPath!) as! OrganizationTableViewCell
            GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
            self.performSegueWithIdentifier("ShowOnMap", sender: self)
        case 1:
            
            let cellIndexPath = self.affiliatedOrgTable.indexPathForCell(cell)
            
            let selectedCell = self.affiliatedOrgTable.cellForRowAtIndexPath(cellIndexPath!) as! OrganizationTableViewCell
            
            GlobalVariables.eventSelected = selectedCell.circHiddenID.text!
            self.performSegueWithIdentifier("MoreInfore", sender: self)
        
        default:
            break
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MoreInfore" {
            let destinationController = segue.destinationViewController as! MoreInformationViewController
            destinationController.sourceForComingEvent = "organization"
            destinationController.sourceID = GlobalVariables.eventSelected
        }
        if segue.identifier == "ShowOnMap" {
            let destinationController = segue.destinationViewController as! ShowOnMapViewController
            destinationController.sourceForMarker = "organization"
            destinationController.sourceID = GlobalVariables.eventSelected
        }
        
    }
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell : SWTableViewCell ) -> Bool {
        return true
    }
    
    //Circ and Rect View changing
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        
        
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! OrganizationTableViewCell;
            currentCell.tappedView();
            tableView.deselectRowAtIndexPath(indexPath!, animated: false)
            
        
    }
    
    
    func convertCircTimeFormat(date: String) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        if let ndate = dateFormatter.dateFromString(date) {
            
            dateFormatter.dateFormat = "MMM dd, yyyy"
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            let timeStamp = dateFormatter.stringFromDate(ndate)
            return timeStamp
        }
        else {return "nil or error times"}
    }
    
    func convertRectTimeFormat(date: String) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        if let ndate = dateFormatter.dateFromString(date) {
            
            dateFormatter.dateFormat = "EEEE, MMMM dd 'at' h:mma"
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            let timeStamp = dateFormatter.stringFromDate(ndate)
            return timeStamp
        }
        else {return "nil,error times"}
    }
    
    func randomImage() -> UIImage {
        let imgNo = Int(arc4random_uniform(6) + 1)
        
        switch(imgNo){
            
        case 1:
            return UIImage(named: "Background1")!
            
        case 2:
            return UIImage(named: "Background2")!
            
        case 3:
            return UIImage(named: "Background3")!
            
        case 4:
            return UIImage(named: "Background4")!
            
        case 5:
            return UIImage(named: "Background5")!
            
        case 6:
            return UIImage(named: "Background6")!
            
        default:
            return UIImage(named: "Background1")!
        }
        
    }
    
    func swipeCellTitle(title: String) -> NSAttributedString {
        
        let mAttribute = [NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        let aString = NSMutableAttributedString(string: title, attributes: mAttribute)
        
        return aString
    }
    
    func updateAddictFetch() {
        
        addictionInfo = FetchData(context: managedObjectContext).fetchAddictionsOrganization()
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
