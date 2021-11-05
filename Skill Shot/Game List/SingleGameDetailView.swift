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
    var game: Game
    @State var region = initialRegion
    @State var selectedLocation: Location? = nil
    @State var locations = [Location]() {
        didSet {
            // TODO: update region
        }
    }

    var body: some View {
        ZStack {
            if verticalSizeClass == .compact {
                VStack(alignment: .leading, spacing: 0) {
                    GameLocationsHeaderView(name: game.name)
                    HStack(alignment: .top, spacing: 0) {
                        GameLocationScrollView(
                            selectedLocation: $selectedLocation,
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
        .onAppear {
            self.locations = LocationDatabase.shared.locations.filter { location in
                location.machines.contains { machine in
                    machine.game == self.game
                }
            }
        }
    }
}

struct SingleGameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SingleGameDetailView(game: Game(id: 34352, name: "Ding donger"))
    }
}
