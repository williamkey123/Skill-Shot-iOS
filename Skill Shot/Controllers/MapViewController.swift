//
//  MapViewController.swift
//  Skill Shot
//
//  Created by Will Clarke on 12/21/15.
//
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var initialUserLocation: CLLocationCoordinate2D?

    var listData: LocationList? {
        didSet {
            if let validList = listData {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "listDataLoaded:", name: "LocationListLoaded", object: validList)
            }
            if let oldList = oldValue {
                NSNotificationCenter.defaultCenter().removeObserver(self, name: "LocationListLoaded", object: oldList)
            }
        }
    }
    
    weak var containingViewController: MapAndListContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true

        let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(47.613760, -122.345098), MKCoordinateSpanMake(0.083, 0.07))
        mapView.region = region
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func listDataLoaded(notification: NSNotification) {
        if let validData = listData {
            mapView.addAnnotations(validData.locations)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation === mapView.userLocation {
            return nil
        }
        if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("LocationIdetifier") {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "LocationIdetifier")
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
            return annotationView
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let validParentVC = containingViewController, validLocation = view.annotation as? Location {
            validParentVC.selectedLocation = validLocation
            validParentVC.performSegueWithIdentifier("showLocationDetails", sender: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if initialUserLocation == nil {
            initialUserLocation = userLocation.coordinate
            let region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.083, 0.07))
            mapView.region = region
        }
    }
}
