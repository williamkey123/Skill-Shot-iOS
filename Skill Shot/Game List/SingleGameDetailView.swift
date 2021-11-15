//
//  SingleGameDetailView.swift
//  Skill Shot
//
//  Created by William Key on 11/4/21.
//

import SwiftUI
import MapKit

struct SingleGameDetailView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @ObservedObject var locationDB = LocationDatabase.shared
    @Binding var game: Game?
    @State var region = initialRegion
    @Binding var selectedLocation: Location?
    @Binding var tappedLocation: Location?

    func fullRegion(for locations: [Location]) -> MKCoordinateRegion {
        let coords = locations.map { $0.coordinate }
        return MKCoordinateRegion(from: coords)
    }

    var body: some View {
        if let game = game {
            let locations = locationDB.locations.filter { location in
                location.machines.contains { machine in
                    machine.game == self.game
                }
            }
            ZStack {
                if verticalSizeClass == .compact {
                    VStack(alignment: .leading, spacing: 0) {
                        GameLocationsHeaderView(name: game.name)
                        HStack(alignment: .top, spacing: 0) {
                            GameLocationScrollView(
                                selectedLocation: $selectedLocation,
                                tappedLocation: $tappedLocation,
                                locations: locations
                            )
                            GameLocationMapView(
                                region: $region,
                                selectedLocation: $selectedLocation,
                                locations: locations
                            )
                        }
                    }
                    .ignoresSafeArea(.container, edges: [.trailing])
                    .navigationTitle("Details")
                    .navigationBarTitleDisplayMode(.inline)
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        GameLocationsHeaderView(name: game.name)
                        GameLocationScrollView(
                            selectedLocation: $selectedLocation,
                            tappedLocation: $tappedLocation,
                            locations: locations
                        )
                        GameLocationMapView(
                            region: $region,
                            selectedLocation: $selectedLocation,
                            locations: locations
                        )
                    }
                    .navigationTitle("Details")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
            .id("SingleGameViewForGame\(game.id)")
            .onAppear {
                self.region = self.fullRegion(for: locations)
            }
            .onChange(of: game) { newValue in
                let newLocations = locationDB.locations.filter { location in
                    location.machines.contains { machine in
                        machine.game == newValue
                    }
                }
                let newRegion = self.fullRegion(for: newLocations)
                withAnimation(.default) {
                    self.region = newRegion
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct SingleGameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SingleGameDetailView(
            game: .constant(Game(id: 34352, name: "Ding donger")),
            selectedLocation: .constant(nil),
            tappedLocation: .constant(nil)
        )
    }
}
