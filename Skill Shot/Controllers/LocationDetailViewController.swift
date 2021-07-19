//
//  LocationDetailViewController.swift
//  Skill Shot
//
//  Created by Will Clarke on 12/21/15.
//
//

import UIKit
import MapKit
import Contacts
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


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
                NotificationCenter.default.addObserver(self, selector: #selector(LocationDetailViewController.locationDetailsLoaded(_:)), name: NSNotification.Name(rawValue: "LocationDetailsLoaded"), object: validLocation)
            }
            if let validOldLocation = oldValue {
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "LocationDetailsLoaded"), object: validOldLocation)
            }
        }
    }
    
    var initiallyLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if let validLocation = displayedLocation {
            venueNameLabel.text = validLocation.name
            allAgesLabel.text = validLocation.allAges ? "All Ages" : "21+"
            streetAddressLabel.text = validLocation.address
            phoneNumberLabel.text = validLocation.phone
            
            if let validPhone = validLocation.formattedPhoneNumber {
                let phoneURL = URL(string: "tel://\(validPhone)")
                if phoneURL == nil || validPhone.trimmingCharacters(in: CharacterSet.whitespaces) == "" {
                    self.phoneNumberButton.isEnabled = false
                }
            } else {
                self.phoneNumberButton.isEnabled = false
            }

            if let validWebsite = validLocation.URL {
                let webURL = URL(string: validWebsite)
                if webURL == nil || validWebsite.trimmingCharacters(in: CharacterSet.whitespaces) == "" {
                    self.webButton.isEnabled = false
                }
            } else {
                self.webButton.isEnabled = false
            }
        }
        self.initiallyLoaded = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func locationDetailsLoaded(_ notification: Notification) {
        if self.initiallyLoaded {
            //We are checking if it has been initially loaded, because since the web service to show detail is run before the view is on the screen, it's 
            //possible that we get a response before the view is fully set up.
            self.tableView.reloadData()
        }
    }

    // MARK: - IBActions

    @IBAction func phoneButtonTapped(_ sender: AnyObject) {
        guard let validLocation = displayedLocation else {
            return
        }
        guard let validPhone = validLocation.formattedPhoneNumber else {
            return
        }
        if let phoneURL = URL(string: "tel://\(validPhone)") {
            UIApplication.shared.open(phoneURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([String : Any]()), completionHandler: nil)
        }
    }
    
    @IBAction func webButtonTapped(_ sender: AnyObject) {
        guard let validLocation = displayedLocation else {
            return
        }
        guard let validURL = validLocation.URL else {
            return
        }
        if let webURL = URL(string: validURL) {
            UIApplication.shared.open(webURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([String : Any]()), completionHandler: nil)
        }
    }
    
    @IBAction func mapButtonTapped(_ sender: AnyObject) {
        guard let validLocation = displayedLocation else {
            return
        }
        
        var addressDictionary = [String : AnyObject]()
        if let validAddress = validLocation.address {
            addressDictionary[CNPostalAddressStreetKey] = validAddress as AnyObject
        }
        if let validCity = validLocation.city {
            addressDictionary[CNPostalAddressCityKey] = validCity as AnyObject
        }
        if let validPostalCode = validLocation.postalCode {
            addressDictionary[CNPostalAddressPostalCodeKey] = validPostalCode as AnyObject
        }
        let mapPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: validLocation.latitude, longitude: validLocation.longitude), addressDictionary: addressDictionary)
        let mapItem = MKMapItem(placemark: mapPlacemark)
        mapItem.name = validLocation.name
        mapItem.openInMaps(launchOptions: nil)
    }


    // MARK: - UITableViewDelegate and UITableViewDataSource functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Games"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let validLocation = displayedLocation else {
            return UITableViewCell()
        }
        var validIdentifier = "LoadingCell"
        if let _ = validLocation.machines {
            validIdentifier = "GameCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: validIdentifier, for: indexPath)
        if validIdentifier == "GameCell" {
            if indexPath.row < validLocation.machines?.count {
                cell.textLabel!.text = validLocation.machines![indexPath.row].title.name
                cell.detailTextLabel!.text = ""
            }
        }
        return cell
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
