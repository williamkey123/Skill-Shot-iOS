//
//  AllLocationListView.swift
//  Skill Shot
//
//  Created by William Key on 10/26/21.
//

import SwiftUI

struct AllLocationListView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var selectedLocation: Location? = nil
    @State var searchText: String = ""
    @State var showingSortSheet = false
    @State var sort: LocationSortOption = .byName
    @State var allAges = false
    @State var isLandscape = UIDevice.current.orientation.isLandscape

    var usesStackView: Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        } else if horizontalSizeClass == .regular {
            return true
        } else {
            return false
        }
    }

    var body: some View {
        ZStack {
            if self.usesStackView {
                PadAllLocationListView(
                    selectedLocation: $selectedLocation,
                    showingSortSheet: $showingSortSheet,
                    sort: $sort,
                    allAges: $allAges,
                    searchText: $searchText
                )
            } else {
                PhoneAllLocationListView(
                    selectedLocation: $selectedLocation,
                    showingSortSheet: $showingSortSheet,
                    sort: $sort,
                    allAges: $allAges,
                    searchText: $searchText
                )
            }
        }
        .onReceive(
            NotificationCenter.Publisher(
                center: .default,
                name: UIDevice.orientationDidChangeNotification
            ),
            perform: { _ in
                self.isLandscape = UIDevice.current.orientation.isLandscape
            }
        )
        .sheet(isPresented: $showingSortSheet) {
            LocationSortSheetView(
                isShown: $showingSortSheet,
                allAges: $allAges,
                sort: $sort
            )
        }
    }
}

struct AllLocationListView_Previews: PreviewProvider {
    static var previews: some View {
        TabView(selection: .constant(1)) {
            AllLocationListView()
                .tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 1")/*@END_MENU_TOKEN@*/ }.tag(1)
            Text("Tab Content 2").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(2)
        }
    }
}
