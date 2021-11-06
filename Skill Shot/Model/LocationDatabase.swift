//
//  LocationDatabase.swift
//  Skill Shot
//
//  Created by William Key on 10/26/21.
//

import Foundation

class LocationDatabase: ObservableObject {
    static var shared = LocationDatabase()
    private static let locationAPI = "https://list.skill-shot.com/locations/for_wordpress.json"
    private static let userDefaultsKey = "StoredLocations"
    private let jsonDecoder = JSONDecoder()

    @Published var locations: [Location] = [] {
        didSet {
            var games = Set<Game>()
            var gameCounts = [Int : Int]()
            for location in locations {
                for machine in location.machines {
                    games.insert(machine.game)
                    if gameCounts[machine.game.id] != nil {
                        gameCounts[machine.game.id]! += 1
                    } else {
                        gameCounts[machine.game.id] = 1
                    }
                }
            }
            self.games = games
            self.gameCounts = gameCounts
        }
    }
    @Published var games: Set<Game> = []
    @Published var gameCounts = [Int : Int]()

    init() {
        // 1. Try from user defaults
        if let validData = UserDefaults.standard.data(forKey: Self.userDefaultsKey) {
            if let locations = try? jsonDecoder.decode([Location].self, from: validData) {
                self.locations = locations
            }
        }

        // 2. If that fails, try local file
        if locations.isEmpty {
            let fileName = "all_locations"
            if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
                let url = URL(fileURLWithPath: path)
                if let data = try? Data(contentsOf: url, options: .mappedIfSafe) {
                    if let locations = try? jsonDecoder.decode([Location].self, from: data) {
                        self.locations = locations
                    }
                }
            }
        }

        // 3. Kick off background task to load from server
        DispatchQueue.main.async {
            self.loadLocationsFromServer()
        }
    }

    private func loadLocationsFromServer() {
        guard let url = URL(string: Self.locationAPI) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            let locations = try? self.jsonDecoder.decode([Location].self, from: data)
            if let locations = locations {
                DispatchQueue.main.sync {
                    self.locations = locations
                }
                self.saveLocationsToUserDefaults()
            }
        }
        task.resume()
    }

    private func saveLocationsToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.locations) {
            UserDefaults.standard.set(encoded, forKey: Self.userDefaultsKey)
            UserDefaults.standard.synchronize()
        }
    }
}
