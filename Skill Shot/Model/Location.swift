//
//  Location.swift
//  Skill Shot
//
//  Created by William Key on 12/21/15.
//
//

import Foundation
import MapKit

struct Location: Codable, Hashable, Identifiable {
    var id: String
    var name: String
    var address: String?
    var city: String?
    var postalCode: String?
    var latitude: Double
    var longitude: Double
    var phone: String?
    var urlString: String?
    var allAges: Bool
    var numGames: Int
    var machines: [Machine]
    var distanceAwayInMiles: Double?

    private enum CodingKeys: String, CodingKey {
        case postalCode = "postal_code"
        case allAges = "all_ages"
        case numGames = "num_games"
        case urlString = "url"
        case id, name, address, city, latitude, longitude, phone, machines
    }

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: self.latitude,
            longitude: self.longitude
        )
    }

    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.name)
    }
    
//    var coordinate: CLLocationCoordinate2D {
//        return CLLocationCoordinate2DMake(self.latitude, self.longitude)
//    }
//    
//    var title: String? {
//        return name
//    }
//    
//    var subtitle: String? {
//        let gameCountStr = numGames == 1 ? "1 game" : "\(numGames) games"
//        
//        if let validDistance = self.distanceAwayInMiles {
//            let str = NSString(format: "%.2f", validDistance)
//            return "\(str) mi - \(gameCountStr)"
//        }
//        return "\(gameCountStr)"
//    }
//    
//    var formattedPhoneNumber: String? {
//        guard let validPhone = phone else {
//            return nil
//        }
//        return validPhone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
//    }
//
//    func matchesSearchString(_ searchString: String) -> Bool {
//        let lowercaseSearch = searchString.lowercased()
//
//        if self.name.lowercased().range(of: lowercaseSearch) != nil {
//            return true
//        } else if self.machines?.contains(where: { machine in
//                machine.game.name.lowercased().range(of: lowercaseSearch) != nil
//        }) == true {
//            return true
//        } else {
//            return false
//        }
//    }
}

enum SortType: String {
    case Name = "Name"
    case Distance = "Distance"
    case NumOfGames = "Number of Games"
}
