//
//  LocationTableViewController+UIViewControllerPreviewingDelegate.swift
//  Skill Shot
//
//  Created by Will Clarke on 1/24/16.
//
//

import UIKit

extension LocationTableViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRowAtPoint(location),
            cell = tableView.cellForRowAtIndexPath(indexPath),
            validData = self.listData, validParentVC = containingViewController else
        {
            return nil
        }

        var selectedLocation = validData.locations[indexPath.row]
        if self.hasSearchTerm {
            if indexPath.row < self.filteredList.count {
                selectedLocation = self.filteredList[indexPath.row]
            } else {
                return nil
            }
        }

        // Create a detail view controller and set its properties.
        guard let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("VenueDetailPreview") as? LocationPreviewViewController else {
            return nil
        }
        detailViewController.displayedLocation = selectedLocation
        validParentVC.selectedLocation = selectedLocation

        detailViewController.preferredContentSize = CGSize(width: 0.0, height: 160.0)

        // Set the source rect to the cell frame, so surrounding elements are blurred.
        previewingContext.sourceRect = cell.frame
        return detailViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        guard let validParentVC = containingViewController else {
            return
        }

        validParentVC.performSegueWithIdentifier("showLocationDetails", sender: validParentVC)
//        validParentVC.showViewController(viewControllerToCommit, sender: validParentVC)
    }
}

