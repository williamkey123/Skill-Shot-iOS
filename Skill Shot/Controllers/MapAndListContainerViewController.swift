//
//  MapAndListContainerViewController.swift
//  Skill Shot
//
//  Created by Will Clarke on 12/21/15.
//
//

import UIKit
import CoreLocation

enum LocationViewControllerType {
    case List
    case Map
}

class MapAndListContainerViewController: UIViewController, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var mapListSegmentedControl: UISegmentedControl!
    @IBOutlet weak var filterButtonItem: UIBarButtonItem!
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var listViewContainer: UIView!
    
    var listData = LocationList()
    var selectedLocation: Location?
    
    var initialContainerView: LocationViewControllerType? = nil
    
    var mapViewController: MapViewController?
    var listViewController: LocationTableViewController?

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

        if traitCollection.forceTouchCapability == .Available {
            if let validListVC = listViewController {
                registerForPreviewingWithDelegate(validListVC, sourceView: validListVC.view)
            }
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applyFilters:", name: "FiltersChosen", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationRelaunched:", name: "ApplicationRelaunched", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        if let validInitialContainer = initialContainerView {
            self.showContainerController(validInitialContainer)
        }
        self.initialContainerView = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var mapViewShowing: Bool {
        return self.mapListSegmentedControl.selectedSegmentIndex == 0
    }

    var listViewShowing: Bool {
        return self.mapListSegmentedControl.selectedSegmentIndex == 1
    }

    func showContainerController(container: LocationViewControllerType) {
        switch container {
        case .Map:
            self.mapListSegmentedControl.selectedSegmentIndex = 0
            self.listViewContainer.hidden = true
            self.mapViewContainer.hidden = false
        case .List:
            self.mapListSegmentedControl.selectedSegmentIndex = 1
            self.listViewContainer.hidden = false
            self.mapViewContainer.hidden = true
        }
    }
    
    func applicationRelaunched(notification: NSNotification) {
        if let validInitialContainer = initialContainerView {
            self.showContainerController(validInitialContainer)
        }
        self.initialContainerView = nil
    }
    
    func applyFilters(notification: NSNotification) {
        guard let validUserInfo = notification.userInfo else {
            return
        }
        var filterSet = false
        if let validAllAgesFilterChosen = validUserInfo["AllAges"] as? Bool {
            if validAllAgesFilterChosen {
                filterSet = true
            }
        }
        if filterSet {
            self.filterButtonItem.image = UIImage(named: "FilterFilled")
        } else {
            self.filterButtonItem.image = UIImage(named: "FilterEmpty")
        }
    }
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
                validDestination.initialSort = self.listData.sortOrder.rawValue
                validDestination.initialAllAges = self.listData.allAges
                validDestination.showSortOptions = self.listViewShowing  //only want to show sort options if the list is showing
                self.mapListSegmentedControl.enabled = false
            }
        }
    }

    @IBAction func mapListSegmentedControlChanged(sender: AnyObject) {
        if self.mapListSegmentedControl.selectedSegmentIndex == 0 {
            self.mapViewContainer.hidden = false
            self.listViewContainer.hidden = true
        } else {
            self.listViewContainer.hidden = false
            self.mapViewContainer.hidden = true
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
