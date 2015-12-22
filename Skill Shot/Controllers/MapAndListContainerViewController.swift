//
//  MapAndListContainerViewController.swift
//  Skill Shot
//
//  Created by Will Clarke on 12/21/15.
//
//

import UIKit

class MapAndListContainerViewController: UIViewController {

    @IBOutlet weak var mapListSegmentedControl: UISegmentedControl!
    @IBOutlet weak var filterButtonItem: UIBarButtonItem!
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var listViewContainer: UIView!
    
    var listData = LocationList()
    var selectedLocation: Location?

    override func viewDidLoad() {
        super.viewDidLoad()

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
        } else if segue.identifier == "showLocationDetails" {
            if let validDestination = segue.destinationViewController as? LocationDetailViewController {
                validDestination.displayedLocation = self.selectedLocation
                self.selectedLocation?.loadDetails()
            }
        }
    }

    @IBAction func mapListSegmentedControlChanged(sender: AnyObject) {
    }
}
