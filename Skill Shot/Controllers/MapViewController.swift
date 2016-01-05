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
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "listDataLoaded:", name: "LocationListReordered", object: validList)
            }
            if let oldList = oldValue {
                NSNotificationCenter.defaultCenter().removeObserver(self, name: "LocationListLoaded", object: oldList)
                NSNotificationCenter.defaultCenter().removeObserver(self, name: "LocationListReordered", object: oldList)
            }
        }
    }
    
    weak var containingViewController: MapAndListContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true

        let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(47.613760, -122.345098), MKCoordinateSpanMake(0.083, 0.07))
        mapView.region = region
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func listDataLoaded(notification: NSNotification) {
        if let validData = listData {
            var annotationsToRemove = [MKAnnotation]()
            var annotationsToAdd = [MKAnnotation]()
            for currentMapAnnotation in mapView.annotations {
                if let currentMapLocation = currentMapAnnotation as? Location {
                    if !validData.locations.contains(currentMapLocation) {
                        annotationsToRemove.append(currentMapAnnotation)
                    }
                }
            }
            for location in validData.locations {
                var foundLocation = false
                for mapAnnotation in mapView.annotations {
                    if mapAnnotation === location {
                        foundLocation = true
                        break
                    }
                }
                if !foundLocation {
                    annotationsToAdd.append(location)
                }
            }
            mapView.removeAnnotations(annotationsToRemove)
            mapView.addAnnotations(annotationsToAdd)
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
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if initialUserLocation == nil {
            initialUserLocation = userLocation.coordinate
            let region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.083, 0.07))
            mapView.region = region
        }
    }
}
