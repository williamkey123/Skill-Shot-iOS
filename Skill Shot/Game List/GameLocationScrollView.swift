//
//  GameLocationScrollView.swift
//  Skill Shot
//
//  Created by William Key on 11/5/21.
//

import SwiftUI

struct GameLocationScrollView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Binding var selectedLocation: Location?
    @Binding var tappedLocation: Location?
    var locations: [Location]

    var body: some View {
        ScrollViewReader { proxy in
            let axis: Axis.Set = verticalSizeClass == .compact ? .vertical : .horizontal
            ScrollView(axis, showsIndicators: true) {
                if verticalSizeClass == .compact {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(locations) { location in
                            let isSelected = selectedLocation == location
                            CompactLocationCardView(
                                location: location,
                                selected: isSelected,
                                tappedLocation: $tappedLocation
                            )
                                .id("CardFor\(location.id)")
                                .onTapGesture {
                                    selectedLocation = location
                                }
                        }
                        Spacer().frame(height: 2)
                    }
                } else {
                    HStack(alignment: .top, spacing: 0) {
                        Spacer().frame(width: 2)
                        ForEach(locations) { location in
                            let isSelected = selectedLocation == location
                            RegularLocationCardView(
                                location: location,
                                selected: isSelected,
                                tappedLocation: $tappedLocation
                            )
                                .id("CardFor\(location.id)")
                                .onTapGesture {
                                    selectedLocation = location
                                }
                        }
                        Spacer().frame(width: 2)
                    }
                }
            }
            .onChange(of: selectedLocation) { newValue in
                if let validLocation = newValue {
                    withAnimation(.default) {
                        proxy.scrollTo("CardFor\(validLocation.id)")
                    }
                }
            }
        }
    }
}

