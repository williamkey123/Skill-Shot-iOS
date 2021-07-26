//
//  LocationTableViewController.swift
//  Skill Shot
//
//  Created by William Key on 12/21/15.
//
//

import UIKit
import CoreLocation

class LocationTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var locationSearchBar: UISearchBar!

    var listData: LocationList? {
        didSet {
            if let validList = listData {
                NotificationCenter.default.addObserver(self, selector: #selector(LocationTableViewController.listDataLoaded(_:)), name: NSNotification.Name(rawValue: "LocationListLoaded"), object: validList)
                NotificationCenter.default.addObserver(self, selector: #selector(LocationTableViewController.listDataReordered(_:)), name: NSNotification.Name(rawValue: "LocationListReordered"), object: validList)
                NotificationCenter.default.addObserver(self, selector: #selector(LocationTableViewController.listDataLocationsChanged(_:)), name: NSNotification.Name(rawValue: "LocationListDistancesRecalculated"), object: validList)
            }
            if let oldList = oldValue {
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "LocationListLoaded"), object: oldList)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "LocationListReordered"), object: oldList)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "LocationListDistancesRecalculated"), object: oldList)
            }
        }
    }
    var filteredList = [Location]()
    
    var hasSearchTerm: Bool {
        if let searchText = self.locationSearchBar.text {
            if searchText.trimmingCharacters(in: CharacterSet.whitespaces) != "" {
                return true
            }
        }
        return false
    }
    
    var searchTerm: String? {
        if let searchText = self.locationSearchBar.text {
            if searchText.trimmingCharacters(in: CharacterSet.whitespaces) != "" {
                return searchText.trimmingCharacters(in: CharacterSet.whitespaces)
            }
        }
        return nil
    }

    weak var containingViewController: MapAndListContainerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 58.0
        self.tableView.rowHeight = UITableView.automaticDimension

        NotificationCenter.default.addObserver(self, selector: #selector(LocationTableViewController.applyFilters(_:)), name: NSNotification.Name(rawValue: "FiltersChosen"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Table cell generation methods

    func getLocationTableViewCell(for indexPath: IndexPath, inTable tableView: UITableView) -> UITableViewCell {
        guard let validLocationList = listData else {
            return self.getLoadingCell(for: indexPath, inTable: tableView)
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        if let validLocationCell = cell as? LocationTableViewCell {
            var validLocation = validLocationList.locations[indexPath.row]
            if self.hasSearchTerm {
                if indexPath.row < filteredList.count {
                    validLocation = filteredList[indexPath.row]
                }
            }
            validLocationCell.setName(validLocation.name, withSearchText: self.searchTerm)
            if let validDistance = validLocation.distanceAwayInMiles {
                let distanceStr = NSString(format: "%.2f", validDistance)
                validLocationCell.distanceLabel.text = "\(distanceStr) mi"
            } else {
                validLocationCell.distanceLabel.text = ""
            }

            validLocationCell.setGameLabel(forMachines: validLocation.machines, withSearchText: self.searchTerm)
            return validLocationCell
        } else {
            return self.getLoadingCell(for: indexPath, inTable: tableView)
        }
    }

    func getLoadingCell(for indexPath: IndexPath, inTable tableView: UITableView) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
    }

    func getNoResultsCell(for indexPath: IndexPath, inTable tableView: UITableView) -> UITableViewCell {
        let noResultsCell = tableView.dequeueReusableCell(withIdentifier: "NoResultsCell", for: indexPath)
        if let searchTerm = self.searchTerm {
            noResultsCell.textLabel?.text = "No results found for \"\(searchTerm)\""
        } else {
            noResultsCell.textLabel?.text = "No results found"
        }
        return noResultsCell
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hasSearchTerm {
            return max(filteredList.count, 1)
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.hasSearchTerm && self.filteredList.count == 0 {
            return self.getNoResultsCell(for: indexPath, inTable: tableView)
        } else if listData != nil && listData!.loadedData {
            return self.getLocationTableViewCell(for: indexPath, inTable: tableView)
        } else {
            return self.getLoadingCell(for: indexPath, inTable: tableView)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
            validParentVC.performSegue(withIdentifier: "showLocationDetails", sender: nil)
        }
    }
    
    @objc func listDataLoaded(_ notification: Notification) {
        tableView.reloadData()
    }
    
    @objc func listDataLocationsChanged(_ notification: Notification) {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
            tableView.reloadRows(at: visibleIndexPaths, with: UITableView.RowAnimation.none)
        }
    }
    
    @objc func listDataReordered(_ notification: Notification) {
        guard let validUserInfo = notification.userInfo else {
            return
        }
        guard let initialLocations = validUserInfo["Initial"] as? [String : Int], let finalLocations = validUserInfo["Final"] as? [String : Int] else {
            return
        }
        if self.hasSearchTerm {
            self.tableView.reloadData()
        } else {
            self.tableView.beginUpdates()
            
            var indexPathsToRemove = [IndexPath]()
            var indexPathsToAdd = [IndexPath]()
            for (locationIdentifier, initialRow) in initialLocations {
                if let validEndRow = finalLocations[locationIdentifier] {
                    if initialRow != validEndRow {
                        self.tableView.moveRow(at: IndexPath(row: initialRow, section: 0), to: IndexPath(row: validEndRow, section: 0))
                    }
                } else {
                    indexPathsToRemove.append(IndexPath(row: initialRow, section: 0))
                }
            }
            for (locationIdentifier, finalRow) in finalLocations {
                if initialLocations[locationIdentifier] == nil {
                    indexPathsToAdd.append(IndexPath(row: finalRow, section: 0))
                }
            }
            if indexPathsToRemove.count > 0 {
                self.tableView.deleteRows(at: indexPathsToRemove, with: UITableView.RowAnimation.right)
            }
            if indexPathsToAdd.count > 0 {
                self.tableView.insertRows(at: indexPathsToAdd, with: UITableView.RowAnimation.middle)
            }
            
            self.tableView.endUpdates()
        }
    }

    @objc func applyFilters(_ notification: Notification) {
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

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.updateSearchResults()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.setShowsScope(true, animated: true)
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.setShowsScope(false, animated: true)
        tableView.reloadData()
        self.updateSearchResults()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.updateSearchResults()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        self.updateSearchResults()
    }
}
