//
//  LocationPreviewViewController.swift
//  Skill Shot
//
//  Created by Will Clarke on 1/24/16.
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
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        var items = [UIPreviewActionItem]()
        
        if let validLocation = displayedLocation {
            if let validPhone = validLocation.formattedPhoneNumber,
                validUnformattedPhone = validLocation.phone,
                phoneURL = NSURL(string: "tel://\(validPhone)")
            {
                if validPhone.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "" {
                    let phonePreviewItem = UIPreviewAction(title: "Call \(validUnformattedPhone)", style: UIPreviewActionStyle.Default, handler: {
                        (action: UIPreviewAction, controller: UIViewController) -> Void in
                        UIApplication.sharedApplication().openURL(phoneURL)
                    })
                    items.append(phonePreviewItem)
                }
            }
            
            if let validWebsite = validLocation.URL, webURL = NSURL(string: validWebsite) {
                if validWebsite.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "" {
                    let webPreviewItem = UIPreviewAction(title: "Visit Website", style: UIPreviewActionStyle.Default, handler: {
                        (action: UIPreviewAction, controller: UIViewController) -> Void in
                        UIApplication.sharedApplication().openURL(webURL)
                    })
                    items.append(webPreviewItem)
                }
            }
            
            let mapPreviewItem = UIPreviewAction(title: "View On Map", style: UIPreviewActionStyle.Default, handler: {
                (action: UIPreviewAction, controller:UIViewController) -> Void in
                var addressDictionary = [String : AnyObject]()
                if let validAddress = validLocation.address {
                    addressDictionary[CNPostalAddressStreetKey] = validAddress
                }
                if let validCity = validLocation.city {
                    addressDictionary[CNPostalAddressCityKey] = validCity
                }
                if let validPostalCode = validLocation.postalCode {
                    addressDictionary[CNPostalAddressPostalCodeKey] = validPostalCode
                }
                let mapPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: validLocation.latitude, longitude: validLocation.longitude), addressDictionary: addressDictionary)
                let mapItem = MKMapItem(placemark: mapPlacemark)
                mapItem.name = validLocation.name
                mapItem.openInMapsWithLaunchOptions(nil)
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
