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
                NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.listDataLoaded(_:)), name: NSNotification.Name(rawValue: "LocationListLoaded"), object: validList)
                NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.listDataLoaded(_:)), name: NSNotification.Name(rawValue: "LocationListReordered"), object: validList)
            }
            if let oldList = oldValue {
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "LocationListLoaded"), object: oldList)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "LocationListReordered"), object: oldList)
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
    
    @objc func listDataLoaded(_ notification: Notification) {
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation === mapView.userLocation {
            return nil
        }
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "LocationIdetifier") {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "LocationIdetifier")
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
            annotationView.pinTintColor = UIColor(red: 247/255.0, green: 174/255.0, blue: 0.0, alpha: 1.0)
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let validParentVC = containingViewController, let validLocation = view.annotation as? Location {
            validParentVC.selectedLocation = validLocation
            validParentVC.performSegue(withIdentifier: "showLocationDetails", sender: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if initialUserLocation == nil {
            initialUserLocation = userLocation.coordinate
            let region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.083, 0.07))
            mapView.region = region
        }
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: AnyObject) {
        if let validSegmentedControl = sender as? UISegmentedControl {
            if validSegmentedControl.selectedSegmentIndex == 0 {
                mapView.mapType = MKMapType.standard
            } else if validSegmentedControl.selectedSegmentIndex == 1 {
                mapView.mapType = MKMapType.hybrid
            }
        }
    }
}
