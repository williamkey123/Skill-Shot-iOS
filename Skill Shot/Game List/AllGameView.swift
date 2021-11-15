//
//  AllGameView.swift
//  Skill Shot
//
//  Created by William Key on 10/26/21.
//

import SwiftUI

struct AllGameView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var searchText = ""
    @State var selectedGame: Game? = nil
    @State var selectedLocation: Location? = nil
    @State var tappedLocation: Location? = nil

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
                DoubleColumnGameListView(
                    searchText: $searchText,
                    selectedGame: $selectedGame,
                    selectedLocation: $selectedLocation,
                    tappedLocation: $tappedLocation
                )
                    .edgesIgnoringSafeArea(.horizontal)
            } else {
                SingleColumnGameListView(
                    searchText: $searchText,
                    selectedGame: $selectedGame,
                    selectedLocation: $selectedLocation,
                    tappedLocation: $tappedLocation
                )
            }
        }
        .onChange(of: selectedGame, perform: { newValue in
            self.selectedLocation = nil
            self.tappedLocation = nil
        })
        .sheet(item: $tappedLocation, onDismiss: {
            tappedLocation = nil
        }, content: { location in
            NavigationView {
                SingleLocationView(location: location)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button {
                                tappedLocation = nil
                            } label: {
                                Text("Done").bold()
                            }
                        }
                    }
            }
        })
    }
}

struct AllGameView_Previews: PreviewProvider {
    static var previews: some View {
        AllGameView()
    }
}

struct GameRowView: View {
    var game: Game

    func getLocationCount(for game: Game) -> String {
        let db = LocationDatabase.shared
        let gameID = game.id
        if let count = db.gameCounts[gameID] {
            return "\(count)"
        } else {
            return "0"
        }
    }

    var body: some View {
        HStack {
            Text(game.name)
            Spacer()
            Text(self.getLocationCount(for: game))
                .padding(.horizontal, 8)
                .foregroundColor(.white)
                .font(.subheadline)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray)
                )
        }
        .contentShape(ContainerRelativeShape())
    }
}
