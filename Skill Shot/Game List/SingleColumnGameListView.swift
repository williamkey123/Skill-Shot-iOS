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
                GameRowNavView(game: game, isActive: game == self.selectedGame) {
                    self.selectedGame = game
                }
            }
        }
        .listStyle(.plain)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Enter game name"
        )
        .navigationTitle("All Games")
        }
    }
}

struct GameRowNavView: View {
    var game: Game
    @State var isActive = false
    var onSelect: () -> Void

    var body: some View {
        NavigationLink(isActive: $isActive) {
            SingleGameDetailView(game: .constant(game))
        } label: {
            GameRowView(game: game)
        }
        .onChange(of: isActive) { newValue in
            if newValue {
                self.onSelect()
            }
        }
    }
}

struct SingleColumnGameListView_Previews: PreviewProvider {
    static var previews: some View {
        SingleColumnGameListView(
            searchText: .constant(""),
            selectedGame: .constant(nil)
        )
    }
}
