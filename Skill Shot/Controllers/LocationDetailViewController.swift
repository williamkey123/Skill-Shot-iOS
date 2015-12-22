//
//  LocationDetailViewController.swift
//  Skill Shot
//
//  Created by Will Clarke on 12/21/15.
//
//

import UIKit

class LocationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var allAgesLabel: UILabel!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var webButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var displayedLocation: Location? {
        didSet {
            if let validLocation = displayedLocation {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationDetailsLoaded:", name: "LocationDetailsLoaded", object: validLocation)
            }
            if let validOldLocation = oldValue {
                NSNotificationCenter.defaultCenter().removeObserver(self, name: "LocationDetailsLoaded", object: validOldLocation)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let validLocation = displayedLocation {
            venueNameLabel.text = validLocation.name
            allAgesLabel.text = validLocation.allAges ? "All Ages" : "21+"
            streetAddressLabel.text = validLocation.address
            phoneNumberLabel.text = validLocation.phone
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationDetailsLoaded(notification: NSNotification) {
        tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UITableViewDelegate and UITableViewDataSource functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Games"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let validLocation = displayedLocation {
            if let validMachines = validLocation.machines {
                return validMachines.count
            } else {
                return 1
            }
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let validLocation = displayedLocation else {
            return UITableViewCell()
        }
        var validIdentifier = "LoadingCell"
        if let _ = validLocation.machines {
            validIdentifier = "GameCell"
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(validIdentifier, forIndexPath: indexPath)
        if validIdentifier == "GameCell" {
            if indexPath.row < validLocation.machines?.count {
                cell.textLabel!.text = validLocation.machines![indexPath.row].title.name
                cell.detailTextLabel!.text = ""
            }
        }
        return cell
    }
}