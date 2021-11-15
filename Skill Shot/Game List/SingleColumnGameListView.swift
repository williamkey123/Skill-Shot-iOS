//
//  SingleColumnGameListView.swift
//  Skill Shot
//
//  Created by William Key on 11/4/21.
//

import SwiftUI

struct SingleColumnGameListView: View {
    @ObservedObject var locationDB = LocationDatabase.shared
    @Binding var searchText: String
    @Binding var selectedGame: Game?
    @Binding var selectedLocation: Location?
    @Binding var tappedLocation: Location?

    var body: some View {
        let games = Array(locationDB.games).sorted { lhs, rhs in
            lhs.name < rhs.name
        }
            .filter { game in
                if searchText.isEmpty {
                    return true
                } else {
                    return game.name.localizedCaseInsensitiveContains(searchText)
                }
            }
        NavigationView {
            List {
                ForEach(games, id: \.self) {
                    game in
                    GameRowNavView(
                        game: game,
                        selectedGame: $selectedGame,
                        selectedLocation: $selectedLocation,
                        tappedLocation: $tappedLocation
                    )
                }
            }
            .listStyle(.plain)
            .conditionallySearchable(
                text: $searchText,
                prompt: "Search Games"
            )
            .navigationTitle("All Games")
        }
    }
}

struct GameRowNavView: View {
    var game: Game
    @Binding var selectedGame: Game?
    @Binding var selectedLocation: Location?
    @Binding var tappedLocation: Location?

    var body: some View {
        NavigationLink(tag: game, selection: $selectedGame) {
            SingleGameDetailView(
                game: .constant(game),
                selectedLocation: $selectedLocation,
                tappedLocation: $tappedLocation
            )
        } label: {
            GameRowView(game: game)
        }
    }
}

struct SingleColumnGameListView_Previews: PreviewProvider {
    static var previews: some View {
        SingleColumnGameListView(
            searchText: .constant(""),
            selectedGame: .constant(nil),
            selectedLocation: .constant(nil),
            tappedLocation: .constant(nil)
        )
    }
}
