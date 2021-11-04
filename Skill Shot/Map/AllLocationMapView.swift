//
//  AllLocationMapView.swift
//  Skill Shot
//
//  Created by William Key on 10/26/21.
//

import SwiftUI
import MapKit
import Contacts

let initialRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D(
        latitude: 47.613760,
        longitude: -122.345098
    ),
    span: MKCoordinateSpan(
        latitudeDelta: 0.083,
        longitudeDelta: 0.07
    )
)

struct AllLocationMapView: View {
    @ObservedObject var locationDB = LocationDatabase.shared
    let allItems = LocationDatabase.shared.locations.map {
        ClusteredLocationItem(
            coordinate: $0.coordinate,
            locations: [$0]
        )
    }
    @State var region = initialRegion
    @State var selectedItem: ClusteredLocationItem? = nil {
        didSet {
            if let validItem = selectedItem {
                region.center = validItem.coordinate
            }
        }
    }
    @State var annotationItems = [ClusteredLocationItem]()

    var approximateWidth: Double {
        let formatter = NumberFormatter()
        formatter.maximumSignificantDigits = 1
        formatter.minimumSignificantDigits = 1
        let number = NSNumber(value: region.width)

        if let result = formatter.string(from: number) {
            return Double(result) ?? region.width
        } else {
            return region.width
        }
    }

    static func clusterItems(
        _ items: [ClusteredLocationItem],
        minDistance: Double
    ) -> [ClusteredLocationItem] {
        var newItems = [ClusteredLocationItem]()
        for item in items {
            var found = false
            for (newItemNum, newItem) in newItems.enumerated() {
                let distance = newItem.coordinate.distance(to: item.coordinate)
                if distance < minDistance {
                    found = true
                    var averagedItem = newItem
                    averagedItem.addLocations(item.locations)
                    newItems[newItemNum] = averagedItem
                    break
                }
            }
            if !found {
                newItems.append(ClusteredLocationItem(
                    coordinate: item.coordinate,
                    locations: item.locations
                ))
            }
        }
        return newItems
    }

    func updateAnnotationItems() {
        let minDimension = min(
            UIScreen.main.bounds.width,
            UIScreen.main.bounds.height
        )
        let minDistance = region.width / (minDimension / 40)
        var annotationItems = locationDB.locations.map {
            ClusteredLocationItem(
                coordinate: $0.coordinate,
                locations: [$0]
            )
        }
        var clustered = Self.clusterItems(
            annotationItems,
            minDistance: minDistance
        )
        var clusterCount = 0

        while annotationItems.count != clustered.count && clusterCount < 4 {
            // repeatedly cluster until no more can be clustered
            annotationItems = clustered
            clustered = Self.clusterItems(
                annotationItems,
                minDistance: minDistance
            )
            clusterCount += 1
        }

        self.annotationItems = annotationItems
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                Map(
                    coordinateRegion: $region,
                    annotationItems: self.annotationItems
                ) { item in
                    MapAnnotation(
                        coordinate: item.coordinate,
                        anchorPoint: CGPoint(x: 0.5, y: 1)
                    ) {
                        LocationAnnotationView(
                            count: item.locations.count,
                            selected: item == self.selectedItem
                        )
                            .id("AnnotationFor\(item.id)")
                            .onTapGesture {
                                selectedItem = item
                            }
                    }
                }
                .animation(.default, value: selectedItem)
                .ignoresSafeArea(.container, edges: [.leading, .top, .trailing])
                DrawerView(selectedItem: $selectedItem)
                    .shadow(radius: 3)
            }
            .onAppear(perform: {
                updateAnnotationItems()
            })
            .onChange(of: approximateWidth, perform: { newValue in
                updateAnnotationItems()
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .navigationTitle("Map")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AllLocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        AllLocationMapView()
    }
}
