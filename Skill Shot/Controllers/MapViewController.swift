//
//  MapViewController.swift
//  Skill Shot
//
//  Created by Will Clarke on 12/21/15.
//
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let validLocation = mapView.userLocation.location {
            let region = MKCoordinateRegionMake(validLocation.coordinate, MKCoordinateSpanMake(0.083, 0.07))
            mapView.region = region
        } else {
            let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(47.613760, -122.345098), MKCoordinateSpanMake(0.083, 0.07))
            mapView.region = region
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
