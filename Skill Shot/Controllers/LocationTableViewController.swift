//
//  LocationTableViewController.swift
//  Skill Shot
//
//  Created by Will Clarke on 12/21/15.
//
//

import UIKit
import CoreLocation

class LocationTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var locationSearchBar: UISearchBar!

    var listData: LocationList? {
        didSet {
            if let validList = listData {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "listDataLoaded:", name: "LocationListLoaded", object: validList)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "listDataReordered:", name: "LocationListReordered", object: validList)
            }
            if let oldList = oldValue {
                NSNotificationCenter.defaultCenter().removeObserver(self, name: "LocationListLoaded", object: oldList)
                NSNotificationCenter.defaultCenter().removeObserver(self, name: "LocationListReordered", object: oldList)
            }
        }
    }
    var filteredList = [Location]()
    
    var hasSearchTerm: Bool {
        if let searchText = self.locationSearchBar.text {
            if searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "" {
                return true
            }
        }
        return false
    }
    
    var searchTerm: String? {
        if let searchText = self.locationSearchBar.text {
            if searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "" {
                return searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            }
        }
        return nil
    }

    weak var containingViewController: MapAndListContainerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applyFilters:", name: "FiltersChosen", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hasSearchTerm {
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
            if self.hasSearchTerm {
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
        if self.hasSearchTerm {
            if indexPath.row < self.filteredList.count {
                selectedLocation = self.filteredList[indexPath.row]
            } else {
                return
            }
        }
        
        if let validParentVC = containingViewController {
            validParentVC.selectedLocation = selectedLocation
            validParentVC.performSegueWithIdentifier("showLocationDetails", sender: nil)
        }
    }
    
    func listDataLoaded(notification: NSNotification) {
        tableView.reloadData()
    }
    
    func listDataReordered(notification: NSNotification) {
        guard let validUserInfo = notification.userInfo else {
            return
        }
        guard let initialLocations = validUserInfo["Initial"] as? [String : Int], finalLocations = validUserInfo["Final"] as? [String : Int] else {
            return
        }
        if self.hasSearchTerm {
            self.tableView.reloadData()
        } else {
            self.tableView.beginUpdates()
            
            var indexPathsToRemove = [NSIndexPath]()
            var indexPathsToAdd = [NSIndexPath]()
            for (locationIdentifier, initialRow) in initialLocations {
                if let validEndRow = finalLocations[locationIdentifier] {
                    self.tableView.moveRowAtIndexPath(NSIndexPath(forRow: initialRow, inSection: 0), toIndexPath: NSIndexPath(forRow: validEndRow, inSection: 0))
                } else {
                    indexPathsToRemove.append(NSIndexPath(forRow: initialRow, inSection: 0))
                }
            }
            for (locationIdentifier, finalRow) in finalLocations {
                if initialLocations[locationIdentifier] == nil {
                    indexPathsToAdd.append(NSIndexPath(forRow: finalRow, inSection: 0))
                }
            }
            if indexPathsToRemove.count > 0 {
                self.tableView.deleteRowsAtIndexPaths(indexPathsToRemove, withRowAnimation: UITableViewRowAnimation.Right)
            }
            if indexPathsToAdd.count > 0 {
                self.tableView.insertRowsAtIndexPaths(indexPathsToAdd, withRowAnimation: UITableViewRowAnimation.Middle)
            }
            
            self.tableView.endUpdates()
        }
    }

    func applyFilters(notification: NSNotification) {
        if self.hasSearchTerm {
            //the search is active and we have new filters, so reapply the search to the new results
            self.updateSearchResults()
        }
    }
    
    func updateSearchResults() {
        guard let validListData = listData else {
            return
        }
        self.filteredList = [Location]()
        if let searchedText = self.searchTerm {
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
    

    // MARK: UISearchBarDelegate functions

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.updateSearchResults()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        self.updateSearchResults()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.updateSearchResults()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        self.updateSearchResults()
    }
}
