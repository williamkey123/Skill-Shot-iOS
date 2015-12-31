//
//  MapAndListContainerViewController.swift
//  Skill Shot
//
//  Created by Will Clarke on 12/21/15.
//
//

import UIKit
import CoreLocation

enum SortType: String {
    case Name = "Name"
    case Distance = "Distance"
    case NumOfGames = "Number of Games"
}

class MapAndListContainerViewController: UIViewController, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var mapListSegmentedControl: UISegmentedControl!
    @IBOutlet weak var filterButtonItem: UIBarButtonItem!
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var listViewContainer: UIView!
    
    var listData = LocationList()
    var selectedLocation: Location?
    
    var mapViewController: MapViewController?
    var listViewController: LocationTableViewController?
    
    var sortOrder = SortType.Name
    var allAgesFilter = false

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == CLAuthorizationStatus.NotDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.startUpdatingLocation()
        listData.loadList()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applyFilters:", name: "FiltersChosen", object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var mapViewShowing: Bool {
        return self.mapListSegmentedControl.selectedSegmentIndex == 0
    }

    var listViewShowing: Bool {
        return self.mapListSegmentedControl.selectedSegmentIndex == 1
    }
    
    func applyFilters(notification: NSNotification) {
        guard let validUserInfo = notification.userInfo else {
            return
        }
        var filterSet = false
        if let validAllAgesFilterChosen = validUserInfo["AllAges"] as? Bool {
            self.allAgesFilter = validAllAgesFilterChosen
            if validAllAgesFilterChosen {
                filterSet = true
            }
        }
        if let validSortText = validUserInfo["Sort"] as? String {
            if let validSortOption = SortType(rawValue: validSortText) {
                self.sortOrder = validSortOption
                if validSortOption != .Name {
                    filterSet = true
                }
            }
        }
        if filterSet {
            self.filterButtonItem.image = UIImage(named: "FilterFilled")
        } else {
            self.filterButtonItem.image = UIImage(named: "FilterEmpty")
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showMap" {
            if let validDestination = segue.destinationViewController as? MapViewController {
                validDestination.listData = self.listData
                validDestination.containingViewController = self
                self.mapViewController = validDestination
            }
        } else if segue.identifier == "showList" {
            if let validDestination = segue.destinationViewController as? LocationTableViewController {
                validDestination.listData = self.listData
                validDestination.containingViewController = self
                self.listViewController = validDestination
            }
        } else if segue.identifier == "showLocationDetails" {
            if let validDestination = segue.destinationViewController as? LocationDetailViewController {
                validDestination.displayedLocation = self.selectedLocation
                self.selectedLocation?.loadDetails()
            }
        } else if segue.identifier == "showFilters" {
            if let validDestination = segue.destinationViewController as? FilterViewController {
                validDestination.modalPresentationStyle = UIModalPresentationStyle.Popover
                validDestination.popoverPresentationController!.delegate = self
                validDestination.initialSort = self.sortOrder.rawValue
                validDestination.initialAllAges = self.allAgesFilter
                validDestination.showSortOptions = self.listViewShowing  //only want to show sort options if the list is showing
                self.mapListSegmentedControl.enabled = false
            }
        }
    }

    @IBAction func mapListSegmentedControlChanged(sender: AnyObject) {
        if self.mapListSegmentedControl.selectedSegmentIndex == 0 {
            self.mapViewContainer.hidden = false
            self.listViewContainer.hidden = true
            if let validListViewController = self.listViewController {
                validListViewController.resultSearchController.searchBar.hidden = true
            }
        } else {
            self.listViewContainer.hidden = false
            self.mapViewContainer.hidden = true
            if let validListViewController = self.listViewController {
                validListViewController.resultSearchController.searchBar.hidden = false
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        listData.updateLocationsWithDistancesFromUserLocation(newLocation)
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate functions
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        self.mapListSegmentedControl.enabled = true
    }
}
