//
//  MapAndListContainerViewController.swift
//  Skill Shot
//
//  Created by Will Clarke on 12/21/15.
//
//

import UIKit
import CoreLocation

class MapAndListContainerViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapListSegmentedControl: UISegmentedControl!
    @IBOutlet weak var filterButtonItem: UIBarButtonItem!
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var listViewContainer: UIView!
    
    var listData = LocationList()
    var selectedLocation: Location?

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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            }
        } else if segue.identifier == "showList" {
            if let validDestination = segue.destinationViewController as? LocationTableViewController {
                validDestination.listData = self.listData
                validDestination.containingViewController = self
            }
        } else if segue.identifier == "showLocationDetails" {
            if let validDestination = segue.destinationViewController as? LocationDetailViewController {
                validDestination.displayedLocation = self.selectedLocation
                self.selectedLocation?.loadDetails()
            }
        }
    }

    @IBAction func mapListSegmentedControlChanged(sender: AnyObject) {
        if self.mapListSegmentedControl.selectedSegmentIndex == 0 {
            self.mapViewContainer.hidden = false
        } else {
            self.mapViewContainer.hidden = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        listData.updateLocationsWithDistancesFromUserLocation(newLocation)
    }
}
