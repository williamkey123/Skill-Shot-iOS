//
//  GameLocationMapView.swift
//  Skill Shot
//
//  Created by William Key on 11/5/21.
//

import SwiftUI
import MapKit

struct GameLocationMapView: View {
    @Binding var region: MKCoordinateRegion
    @Binding var selectedLocation: Location?
    var locations: [Location]

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: locations) { location in
            MapAnnotation(coordinate: location.coordinate) {
                let isSelected = selectedLocation == location
                Circle()
                    .fill(isSelected ? Color("SkillShotDarkerColor") : Color("SkillShotTintColor"))
                    .frame(width: 34, height: 34)
                    .onTapGesture {
                        selectedLocation = location
                    }
            }
        }
        .onChange(of: selectedLocation) { newValue in
            if let selectedLocation = selectedLocation {
                withAnimation(.default) {
                    region.center = selectedLocation.coordinate
                }
            }
        }
    }
}
