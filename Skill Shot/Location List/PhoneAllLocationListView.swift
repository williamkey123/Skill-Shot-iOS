//
//  PhoneAllLocationListView.swift
//  Skill Shot
//
//  Created by William Key on 11/4/21.
//

import SwiftUI

struct PhoneAllLocationListView: View {
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
                    SingleLocationNavRowView(
                        location: location,
                        highlightingText: searchText.isEmpty ? nil : searchText,
                        isSelected: location == self.selectedLocation
                    ) {
                        self.selectedLocation = location
                    }
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
