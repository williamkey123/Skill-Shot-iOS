//
//  SingleLocationRowView.swift
//  Skill Shot
//
//  Created by William Key on 10/28/21.
//

import SwiftUI

struct SingleLocationRowView: View {
    var location: Location
    let abbreviateGamesAfter = 3
    var highlightingText: String? = nil

    var abbreviatedGames: String {
        let machineCount = location.machines.count
        if machineCount < 1 {
            return "No games"
        } else if machineCount == 1 {
            return location.machines[0].game.name
        } else if machineCount <= abbreviateGamesAfter {
            let initial = location.machines.prefix(machineCount - 1).map { $0.game.name }
            let initialJoined = initial.joined(separator: ", ")
            return "\(initialJoined), and \(location.machines.last!.game.name)"
        } else {
            let initial = location.machines.prefix(abbreviateGamesAfter).map { $0.game.name }
            let initialJoined = initial.joined(separator: ", ")
            return "\(initialJoined), and \(machineCount - 3) more"
        }
    }

    var body: some View {
        NavigationLink {
            SingleLocationView(location: location)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(location.name, highlighting: highlightingText)
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    Text(self.abbreviatedGames)
                        .font(.caption)
                        .lineLimit(5)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
            .contentShape(Rectangle())
        }
    }
}

struct SingleLocationRowView_Previews: PreviewProvider {
    static var previews: some View {
        SingleLocationRowView(
            location: Location(
                id: "jcgducvg",
                name: "Shorty's",
                latitude: 47.6144972,
                longitude: -122.3460231,
                allAges: false,
                numGames: 16,
                machines: [Machine](),
                distanceAwayInMiles: 0
            )
        )
    }
}
