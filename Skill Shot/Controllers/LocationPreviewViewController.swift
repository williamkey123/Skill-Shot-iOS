//
//  LocationPreviewViewController.swift
//  Skill Shot
//
//  Created by William Key on 1/24/16.
//
//

import UIKit
import MapKit
import Contacts

class LocationPreviewViewController: UIViewController {
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var allAgesLabel: UILabel!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!

    var displayedLocation: Location?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let validLocation = displayedLocation {
            venueNameLabel.text = validLocation.name
            allAgesLabel.text = validLocation.allAges ? "All Ages" : "21+"
            streetAddressLabel.text = validLocation.address
            phoneNumberLabel.text = validLocation.phone
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var previewActionItems : [UIPreviewActionItem] {
        var items = [UIPreviewActionItem]()
        
        if let validLocation = displayedLocation {
            if let validPhone = validLocation.formattedPhoneNumber,
                let validUnformattedPhone = validLocation.phone,
                let phoneURL = URL(string: "tel://\(validPhone)")
            {
                if validPhone.trimmingCharacters(in: CharacterSet.whitespaces) != "" {
                    let phonePreviewItem = UIPreviewAction(title: "Call \(validUnformattedPhone)", style: UIPreviewAction.Style.default, handler: {
                        (action: UIPreviewAction, controller: UIViewController) -> Void in
                        UIApplication.shared.open(phoneURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([String : Any]()), completionHandler: nil)
                    })
                    items.append(phonePreviewItem)
                }
            }
            
            if let validWebsite = validLocation.URL, let webURL = URL(string: validWebsite) {
                if validWebsite.trimmingCharacters(in: CharacterSet.whitespaces) != "" {
                    let webPreviewItem = UIPreviewAction(title: "Visit Website", style: UIPreviewAction.Style.default, handler: {
                        (action: UIPreviewAction, controller: UIViewController) -> Void in
                        UIApplication.shared.open(webURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([String : Any]()), completionHandler: nil)
                    })
                    items.append(webPreviewItem)
                }
            }
            
            let mapPreviewItem = UIPreviewAction(title: "View in Maps", style: UIPreviewAction.Style.default, handler: {
                (action: UIPreviewAction, controller:UIViewController) -> Void in
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
            })
            items.append(mapPreviewItem)
        }

        return items
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
