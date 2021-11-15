//
//  PadAllLocationListView.swift
//  Skill Shot
//
//  Created by William Key on 11/4/21.
//

import SwiftUI

struct PadAllLocationListView: View {
    @Binding var selectedLocation: Location?
    @Binding var showingSortSheet: Bool
    @Binding var sort: LocationSortOption
    @Binding var allAges: Bool
    @Binding var searchText: String
    let dividerWidth: CGFloat = 0.5

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 0) {
                PadAllLocationColumn1View(
                    selectedLocation: $selectedLocation,
                    showingSortSheet: $showingSortSheet,
                    sort: $sort,
                    allAges: $allAges,
                    searchText: $searchText
                )
                    .frame(width: (geometry.size.width - dividerWidth) / 3)
                Rectangle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(width: dividerWidth)
                PadAllLocationColumn2View(selectedLocation: $selectedLocation)
                    .frame(width: (geometry.size.width - dividerWidth) * 2 / 3)
            }
            .ignoresSafeArea(.container, edges: [.top, .horizontal])
        }
    }
}

struct PadAllLocationColumn1View: View {
    @Binding var selectedLocation: Location?
    @ObservedObject var locationDB = LocationDatabase.shared
    @Binding var showingSortSheet: Bool
    @Binding var sort: LocationSortOption
    @Binding var allAges: Bool
    @Binding var searchText: String

    var body: some View {
        let locations = locationDB.locations.filter {
            var included = true
            if !searchText.isEmpty && !$0.name.contains(searchText) {
                included = false
            }
            if allAges && !$0.allAges {
                included = false
            }
            return included
        }

        NavigationView {
            List {
                ForEach(locations, id: \.self) {
                    location in
                    let isSelected = location == self.selectedLocation
                    SingleLocationRowView(
                        location: location,
                        highlightingText: searchText.isEmpty ? nil : searchText
                    )
                        .padding(.vertical, 4)
                        .onTapGesture {
                            self.selectedLocation = location
                        }
                        .listRowBackground(isSelected ? Color.gray.opacity(0.3) : Color.clear)
                }
                if locations.isEmpty && !searchText.isEmpty {
                    Text("No search results for \(searchText)")
                }
            }
            .listStyle(.plain)
            .navigationTitle("All Venues")
            .conditionallySearchable(text: $searchText)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showingSortSheet = true
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down.circle")
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
struct PadAllLocationColumn2View: View {
    @Binding var selectedLocation: Location?
    var body: some View {
        if let location = self.selectedLocation {
            NavigationView {
                SingleLocationView(location: location)
                    .navigationTitle("Details")
            }.navigationViewStyle(.stack)
        } else {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text("Select a venue to see details")
                        .font(.system(size: 32, weight: .light, design: .default))
                        .foregroundColor(.gray.opacity(0.4))
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
