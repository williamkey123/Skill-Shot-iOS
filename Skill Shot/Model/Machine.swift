//
//  Machine.swift
//  Skill Shot
//
//  Created by William Key on 12/21/15.
//
//

import Foundation

struct Machine: Codable, Identifiable, Equatable {
    var id: Int
    var game: Game

    private enum CodingKeys: String, CodingKey {
        case id, game = "title"
    }

    func containsString(_ searchText: String) -> Bool {
        let lowercaseSearch = searchText.lowercased()

        if self.game.name.lowercased().range(of: lowercaseSearch) != nil {
            return true
        } else {
            return false
        }
    }
}

struct Game: Codable, Hashable {
    var id: Int
    var name: String

    static func == (lhs: Game, rhs: Game) -> Bool {
        lhs.id == rhs.id
    }
}
