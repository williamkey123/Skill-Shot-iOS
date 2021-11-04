//
//  AllGameView.swift
//  Skill Shot
//
//  Created by William Key on 10/26/21.
//

import SwiftUI

struct AllGameView: View {
    @ObservedObject var locationDB = LocationDatabase.shared
    @State var searchText = ""

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
                    ForEach(games, id: \.self) {
                        game in
                        GameRowView(game: game)
                    }
                }
                .searchable(
                    text: $searchText,
                    placement: .toolbar,
                    prompt: "Enter game name"
                )
                .navigationTitle("All Games")
        }
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
    }
}
