//
//  AppInfoViewController.swift
//  Skill Shot
//
//  Created by Will Clarke on 12/31/15.
//
//

import UIKit

class AppInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
