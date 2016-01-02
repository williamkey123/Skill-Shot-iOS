//
//  AppInfoViewController.swift
//  Skill Shot
//
//  Created by Will Clarke on 12/31/15.
//
//

import UIKit

class AppInfoViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    // MARK: - IBActions

    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func iconsButtonTapped(sender: AnyObject) {
        if let webURL = NSURL(string: "https://icons8.com") {
            UIApplication.sharedApplication().openURL(webURL)
        }
    }
    
    @IBAction func alamofireButtonTapped(sender: AnyObject) {
        if let webURL = NSURL(string: "https://github.com/Alamofire/Alamofire") {
            UIApplication.sharedApplication().openURL(webURL)
        }
    }
    
    @IBAction func willClarkeButtonTapped(sender: AnyObject) {
        if let willClarkeURL = NSURL(string: "fb://profile/12801403") {
            if UIApplication.sharedApplication().canOpenURL(willClarkeURL) {
                UIApplication.sharedApplication().openURL(willClarkeURL)
            } else if let willClarkeWebURL = NSURL(string: "http://facebook.com/willclarkedotnet") {
                UIApplication.sharedApplication().openURL(willClarkeWebURL)
            }
        }
    }
}
