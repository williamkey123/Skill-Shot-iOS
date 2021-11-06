//
//  DoubleColumnGameListView.swift
//  Skill Shot
//
//  Created by William Key on 11/4/21.
//

import SwiftUI

struct DoubleColumnGameListView: View {
    @ObservedObject var locationDB = LocationDatabase.shared
    @Binding var searchText: String
    @Binding var selectedGame: Game?

    let dividerWidth: CGFloat = 0.5

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 0) {
                GameListColumn1View(
                    searchText: $searchText,
                    selectedGame: $selectedGame
                )
                    .frame(width: (geometry.size.width - dividerWidth) / 3)
                Rectangle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(width: dividerWidth)
                GameListColumn2View(
                    searchText: $searchText,
                    selectedGame: $selectedGame
                )
                    .frame(width: (geometry.size.width - dividerWidth) * 2 / 3)
            }
            .ignoresSafeArea(.container, edges: [.top, .horizontal])
        }
    }
}

struct GameListColumn1View: View {
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
                    return game.name.contains(searchText)
                }
            }

        NavigationView {
            List {
                ForEach(games) { game in
                    let isSelected = self.selectedGame == game
                    GameRowView(game: game)
                        .listRowBackground(isSelected ? Color.gray.opacity(0.3) : Color.clear)
                        .onTapGesture {
                            if isSelected {
                                self.selectedGame = nil
                            } else {
                                self.selectedGame = game
                            }
                        }
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("All Games")
        }
        .navigationViewStyle(.stack)
    }
}

struct GameListColumn2View: View {
    @ObservedObject var locationDB = LocationDatabase.shared
    @Binding var searchText: String
    @Binding var selectedGame: Game?

    var body: some View {
        if selectedGame != nil {
            SingleGameDetailView(game: $selectedGame)
        } else {
            VStack {
                Spacer()
                HStack {
                    Spacer(minLength: 60)
                    Text("Select a game to see where it can be played")
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Spacer(minLength: 60)
                }
                Spacer()
            }
        }
    }
}
