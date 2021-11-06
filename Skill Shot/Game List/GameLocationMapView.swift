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
    @State var originalRegion: MKCoordinateRegion? = nil
    @State var hasMoved = false

    var approximateLocation: Double {
        let formatter = NumberFormatter()
        formatter.maximumSignificantDigits = 5
        let latNum = NSNumber(value: region.center.latitude)
        let lonNum = NSNumber(value: region.center.longitude)

        if let latStr = formatter.string(from: latNum), let lonStr = formatter.string(from: lonNum) {
            return (Double(latStr) ?? region.center.latitude) + (Double(lonStr) ?? region.center.longitude)
        } else {
            return region.center.latitude +  region.center.longitude
        }
    }

    var minDistance: Double {
        guard let originalRegion = originalRegion else {
            return 40
        }

        return originalRegion.width / 28
    }

    var body: some View {
        ZStack {
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
            HStack {
                VStack {
                    Button {
                        withAnimation(.default) {
                            self.region = originalRegion!
                            withAnimation(.default) {
                                hasMoved = false
                            }
                        }
                    } label: {
                        Label(
                            "All",
                            systemImage: "dot.arrowtriangles.up.right.down.left.circle"
                        )
                            .padding(.trailing, 4)
                            .font(.system(size: 18))
                    }
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 32).fill(Color("MapOverlayButton"))
                    )
                    .padding()
                    Spacer()
                }
                Spacer()
            }
            .opacity(hasMoved ? 1 : 0)
        }
        .onAppear {
            self.originalRegion = region
        }
        .onChange(of: approximateLocation, perform: { newValue in
            guard let originalRegion = originalRegion else {
                return
            }

            if region.center.distance(to: originalRegion.center) > minDistance {
                withAnimation(.default) {
                    hasMoved = true
                }
            } else {
                withAnimation(.default) {
                    hasMoved = false
                }
            }
        })
        .onChange(of: selectedLocation) { newValue in
            if let selectedLocation = selectedLocation {
                withAnimation(.default) {
                    region.center = selectedLocation.coordinate
                    region.span = initialRegion.span
                }
            }
        }
    }
}
