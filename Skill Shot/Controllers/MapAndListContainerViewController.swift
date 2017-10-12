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
    case list
    case map
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
        if authorizationStatus == CLAuthorizationStatus.notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.startUpdatingLocation()
        listData.loadList()

        if traitCollection.forceTouchCapability == .available {
            if let validListVC = listViewController {
                registerForPreviewing(with: validListVC, sourceView: validListVC.view)
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(MapAndListContainerViewController.applyFilters(_:)), name: NSNotification.Name(rawValue: "FiltersChosen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapAndListContainerViewController.applicationRelaunched(_:)), name: NSNotification.Name(rawValue: "ApplicationRelaunched"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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

    func showContainerController(_ container: LocationViewControllerType) {
        switch container {
        case .map:
            self.mapListSegmentedControl.selectedSegmentIndex = 0
            self.listViewContainer.isHidden = true
            self.mapViewContainer.isHidden = false
        case .list:
            self.mapListSegmentedControl.selectedSegmentIndex = 1
            self.listViewContainer.isHidden = false
            self.mapViewContainer.isHidden = true
        }
    }
    
    @objc func applicationRelaunched(_ notification: Notification) {
        if let validInitialContainer = initialContainerView {
            self.showContainerController(validInitialContainer)
        }
        self.initialContainerView = nil
    }
    
    @objc func applyFilters(_ notification: Notification) {
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            if let validDestination = segue.destination as? MapViewController {
                validDestination.listData = self.listData
                validDestination.containingViewController = self
                self.mapViewController = validDestination
            }
        } else if segue.identifier == "showList" {
            if let validDestination = segue.destination as? LocationTableViewController {
                validDestination.listData = self.listData
                validDestination.containingViewController = self
                self.listViewController = validDestination
            }
        } else if segue.identifier == "showLocationDetails" {
            if let validDestination = segue.destination as? LocationDetailViewController {
                validDestination.displayedLocation = self.selectedLocation
                self.selectedLocation?.loadDetails()
            }
        } else if segue.identifier == "showFilters" {
            if let validDestination = segue.destination as? FilterViewController {
                validDestination.modalPresentationStyle = UIModalPresentationStyle.popover
                validDestination.popoverPresentationController!.delegate = self
                validDestination.initialSort = self.listData.sortOrder.rawValue
                validDestination.initialAllAges = self.listData.allAges
                validDestination.showSortOptions = self.listViewShowing  //only want to show sort options if the list is showing
                self.mapListSegmentedControl.isEnabled = false
            }
        }
    }

    @IBAction func mapListSegmentedControlChanged(_ sender: AnyObject) {
        if self.mapListSegmentedControl.selectedSegmentIndex == 0 {
            self.mapViewContainer.isHidden = false
            self.listViewContainer.isHidden = true
        } else {
            self.listViewContainer.isHidden = false
            self.mapViewContainer.isHidden = true
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        listData.updateLocationsWithDistancesFromUserLocation(newLocation)
    }

    // MARK: - UIPopoverPresentationControllerDelegate functions
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.mapListSegmentedControl.isEnabled = true
    }
}
