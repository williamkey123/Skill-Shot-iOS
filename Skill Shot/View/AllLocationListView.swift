//
//  AllLocationListView.swift
//  Skill Shot
//
//  Created by William Key on 10/26/21.
//

import SwiftUI

struct AllLocationListView: View {
    @ObservedObject var locationDB = LocationDatabase.shared
    @State var showingSortSheet = false
    @State var sort: LocationSortOption = .byName
    @State var allAges = false
    @State var searchText: String = ""

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
                    SingleLocationRowView(
                        location: location,
                        highlightingText: searchText.isEmpty ? nil : searchText
                    )
                }
                if locations.isEmpty && !searchText.isEmpty {
                    Text("No search results for \(searchText)")
                }
            }
            .listStyle(.plain)
            .navigationTitle("All Venues")
            .navigationViewStyle(.stack)
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showingSortSheet = true
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down.circle")
                    }
                    .sheet(isPresented: $showingSortSheet) {
                        LocationSortSheetView(
                            isShown: $showingSortSheet,
                            allAges: $allAges,
                            sort: $sort
                        )
                    }
                }
            }
        }
    }
}

struct AllLocationListView_Previews: PreviewProvider {
    static var previews: some View {
        AllLocationListView()
    }
}
