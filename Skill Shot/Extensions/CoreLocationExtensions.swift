//
//  CoreLocationExtensions.swift
//  Skill Shot
//
//  Created by William Key on 10/28/21.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    func distance(to location: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let to = CLLocation(latitude: location.latitude, longitude: location.longitude)
        return from.distance(from: to)
    }
}

extension MKCoordinateRegion {
    var width: CLLocationDistance {
        let halfLongitude = self.span.longitudeDelta / 2
        let startPoint = CLLocationCoordinate2D(
            latitude: self.center.latitude,
            longitude: self.center.longitude - halfLongitude
        )
        let endPoint = CLLocationCoordinate2D(
            latitude: self.center.latitude,
            longitude: self.center.longitude + halfLongitude
        )
        return startPoint.distance(to: endPoint)
    }

    func nearlyContains(_ point: CLLocationCoordinate2D) -> Bool {
        let ctrLat = self.center.latitude
        let ctrLon = self.center.longitude
        let latDelta = self.span.latitudeDelta
        let lonDelta = self.span.longitudeDelta

        let nwCorner = CLLocationCoordinate2D(
            latitude: ctrLat - latDelta,
            longitude: ctrLon - lonDelta
        )
        let seCorner = CLLocationCoordinate2D(
            latitude: ctrLat + latDelta,
            longitude: ctrLon + lonDelta
        )
        return point.latitude >= nwCorner.latitude
        && point.latitude <= seCorner.latitude
        && point.longitude >= nwCorner.longitude
        && point.longitude <= seCorner.longitude
    }

    init(from coordinates: [CLLocationCoordinate2D]) {
        let coordCount = Double(coordinates.count)
        if coordinates.isEmpty {
            self = initialRegion
        } else if coordCount == 1 {
            self.init(
                center: coordinates.first!,
                span: initialRegion.span
            )
        } else {
            let coordCount = Double(coordinates.count)
            let lats = coordinates.map { $0.latitude }
            let lons = coordinates.map { $0.longitude }
            let latSum = lats.reduce(0, {$0 + $1})
            let lonSum = lons.reduce(0) { $0 + $1 }
            let avgLat = latSum / coordCount
            let avgLon = lonSum / coordCount
            self.init(
                center: CLLocationCoordinate2D(latitude: avgLat, longitude: avgLon),
                span: MKCoordinateSpan(
                    latitudeDelta: (lats.max()! - lats.min()!) * 1.5,
                    longitudeDelta: (lons.max()! - lons.min()!) * 1.5
                )
            )
        }
    }
}
