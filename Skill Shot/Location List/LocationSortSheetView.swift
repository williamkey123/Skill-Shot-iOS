//
//  LocationSortSheetView.swift
//  Skill Shot
//
//  Created by William Key on 10/28/21.
//

import SwiftUI
import CoreLocation

enum LocationSortOption: Equatable {
    case byName
    case byNumGames

    var description: String {
        switch self {
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
        }
    }
}

struct LocationSortItem: View {
    var item: LocationSortOption
    @Binding var selection: LocationSortOption
    @State var highlighted = false

    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            if item == selection {
                Image(systemName: "checkmark")
                    .frame(width: 34)
                    .foregroundColor(Color("SkillShotTintColor"))
            } else {
                Spacer().frame(width: 34)
            }
            Text(item.description)
            Spacer()
        }
        .listRowBackground(active: highlighted, color: Color.gray.opacity(0.1))
        .contentShape(ContainerRelativeShape())
        .onTapGesture {
            selection = item
            highlighted = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                highlighted = false
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
                        LocationSortItem(item: .byName, selection: $sort)
                        LocationSortItem(item: .byNumGames, selection: $sort)
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
