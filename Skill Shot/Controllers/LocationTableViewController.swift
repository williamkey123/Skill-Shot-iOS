//
//  LocationTableViewController.swift
//  Skill Shot
//
//  Created by Will Clarke on 12/21/15.
//
//

import UIKit

class LocationTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var listData: LocationList? {
        didSet {
            if let validList = listData {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "listDataLoaded:", name: "LocationListLoaded", object: validList)
            }
            if let oldList = oldValue {
                NSNotificationCenter.defaultCenter().removeObserver(self, name: "LocationListLoaded", object: oldList)
            }
        }
    }
    var filteredList = [Location]()

    weak var containingViewController: MapAndListContainerViewController?
    
    var resultSearchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultSearchController.searchResultsUpdater = self
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = resultSearchController.searchBar
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        resultSearchController.searchBar.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        resultSearchController.searchBar.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.active {
            return filteredList.count
        }
        if let validLocationList = listData {
            if validLocationList.loadedData {
                return validLocationList.locations.count
            } else {
                return 1
            }
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let validLocationList = listData else {
            return UITableViewCell()
        }
        
        var defaultIdentifier = "LoadingCell"
        if validLocationList.loadedData {
            defaultIdentifier = "LocationCell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(defaultIdentifier, forIndexPath: indexPath)

        if let validLocationCell = cell as? LocationTableViewCell {
            var validLocation = validLocationList.locations[indexPath.row]
            if self.resultSearchController.active {
                if indexPath.row < filteredList.count {
                    validLocation = filteredList[indexPath.row]
                }
            }
            let gameCountString = (validLocation.numGames == 1) ? "1 game" : "\(validLocation.numGames) games"
            validLocationCell.locationNameLabel.text = validLocation.name
            if let validDistance = validLocation.distanceAwayInMiles {
                let distanceStr = NSString(format: "%.2f", validDistance)
                validLocationCell.distanceLabel.text = "\(distanceStr) mi"
            } else {
                validLocationCell.distanceLabel.text = ""
            }
            validLocationCell.gameCountLabel.text = "\(gameCountString)"
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard let validData = self.listData  else {
            return
        }
        var selectedLocation = validData.locations[indexPath.row]
        if self.resultSearchController.active {
            if indexPath.row < self.filteredList.count {
                selectedLocation = self.filteredList[indexPath.row]
            } else {
                return
            }
        }
//        resultSearchController.active = false
        
        if let validParentVC = containingViewController {
            validParentVC.selectedLocation = selectedLocation
            validParentVC.performSegueWithIdentifier("showLocationDetails", sender: nil)
        }
    }
    
    func listDataLoaded(notification: NSNotification) {
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UISearchResultsUpdating functions
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let validListData = listData else {
            return
        }
        self.filteredList = [Location]()
        if let searchedText = searchController.searchBar.text {
            if searchedText != "" {
                for location in validListData.locations {
                    if location.matchesSearchString(searchedText) {
                        self.filteredList.append(location)
                    }
                }
            }
        }
        tableView.reloadData()
        return
    }

}
