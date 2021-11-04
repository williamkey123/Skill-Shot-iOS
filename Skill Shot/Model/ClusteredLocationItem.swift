//
//  ClusteredLocationItem.swift
//  Skill Shot
//
//  Created by William Key on 10/28/21.
//

import Foundation
import CoreLocation

struct ClusteredLocationItem: Identifiable, Equatable {
    var id: String
    var coordinate: CLLocationCoordinate2D
    var locations: [Location]

    init(coordinate: CLLocationCoordinate2D, locations: [Location]) {
        self.id = "cluster\(coordinate.latitude).\(coordinate.longitude)"
        self.locations = locations.sorted { $0.id < $1.id }
        self.coordinate = coordinate
        self.updateCoordinate()
    }

    static func == (lhs: ClusteredLocationItem, rhs: ClusteredLocationItem) -> Bool {
        lhs.id == rhs.id
    }

    mutating func addLocation(_ newLocation: Location) {
        self.locations.append(newLocation)
        self.locations.sort { $0.id < $1.id }
        self.updateCoordinate()
    }

    mutating func addLocations(_ newLocations: [Location]) {
        self.locations.append(contentsOf: newLocations)
        self.locations.sort { $0.id < $1.id }
        self.updateCoordinate()
    }

    mutating private func updateIdentifier() {
        self.id = "cluster\(coordinate.latitude).\(coordinate.longitude)"
    }

    mutating private func updateCoordinate() {
        guard !locations.isEmpty else {
            return
        }
        let total = Double(locations.count)
        let avgLat = locations.reduce(0) { $0 + $1.latitude } / total
        let avgLon = locations.reduce(0) { $0 + $1.longitude } / total
        self.coordinate = CLLocationCoordinate2D(
            latitude: avgLat,
            longitude: avgLon
        )
        self.updateIdentifier()
    }
}
