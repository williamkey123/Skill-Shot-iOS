//
//  LocationSortSheetView.swift
//  Skill Shot
//
//  Created by William Key on 10/28/21.
//

import SwiftUI
import CoreLocation

enum LocationSortOption {
    case byName
    case byDistance(from: CLLocationCoordinate2D)
    case byNumGames

    var description: String {
        switch self {
        case .byDistance:
            return "By Distance"
        case .byName:
            return "By Name"
        case .byNumGames:
            return "By Number of Games"
        }
    }

    func apply(to locations: [Location]) -> [Location] {
        switch self {
        case .byName:
            return locations.sorted { $0.name < $1.name }
        case .byNumGames:
            return locations.sorted { $0.numGames > $1.numGames }
        case .byDistance(let origin):
            return locations.sorted {
                $0.coordinate.distance(to: origin) < $1.coordinate.distance(to: origin)
            }
        }
    }
}

struct LocationSortSheetView: View {
    @Binding var isShown: Bool
    @Binding var allAges: Bool
    @Binding var sort: LocationSortOption

    var body: some View {
        NavigationView {
            Form {
                Section {
                    List {
                        Text(LocationSortOption.byName.description)
//                        Text(LocationSortOption.byDistance.description)
                        Text(LocationSortOption.byNumGames.description)
                    }
                } header: {
                    Text("Sort")
                }

                Section {
                    List {
                        Toggle(isOn: $allAges) {
                            Text("All Ages")
                        }
                    }
                } header: {
                    Text("Filter")
                } footer: {
                    if allAges {
                        Text("Only showing all-ages venues")
                    } else {
                        Text("Showing all venues")
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        isShown = false
                    } label: {
                        Text("Done")
                            .bold()
                    }

                }
            }
            .navigationTitle("Sort and Filter")
        }
    }
}

struct LocationSortSheetView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSortSheetView(
            isShown: .constant(false),
            allAges: .constant(false),
            sort: .constant(LocationSortOption.byName)
        )
    }
}
