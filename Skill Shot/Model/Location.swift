//
//  Location.swift
//  Skill Shot
//
//  Created by William Key on 12/21/15.
//
//

import Foundation
import Alamofire
import MapKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class Location: NSObject, MKAnnotation {
    var identifier: String
    var name: String
    var address: String?
    var city: String?
    var postalCode: String?
    var latitude: Double
    var longitude: Double
    var phone: String?
    var URL: String?
    var allAges: Bool
    var numGames: Int
    var machines: [Machine]?
    var distanceAwayInMiles: Double?
    
    @objc var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.latitude, self.longitude)
    }
    
    @objc var title: String? {
        return name
    }
    
    @objc var subtitle: String? {
        let gameCountStr = numGames == 1 ? "1 game" : "\(numGames) games"
        
        if let validDistance = self.distanceAwayInMiles {
            let str = NSString(format: "%.2f", validDistance)
            return "\(str) mi - \(gameCountStr)"
        }
        return "\(gameCountStr)"
    }
    
    var formattedPhoneNumber: String? {
        guard let validPhone = phone else {
            return nil
        }
        return validPhone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    
    required init(identifier: String, name: String, latitude: Double, longitude: Double, allAges: Bool = false, numGames: Int = 0) {
        self.identifier = identifier
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.allAges = allAges
        self.numGames = numGames
    }

    func setDetails(_ serverData: [String: AnyObject]) {
        if let validAddress = serverData["address"] as? String {
            self.address = validAddress
        }
        if let validPostalCode = serverData["postal_code"] as? String {
            self.postalCode = validPostalCode
        }
        if let validLat = serverData["latitude"] as? Double {
            self.latitude = validLat
        }
        if let validLon = serverData["longitude"] as? Double {
            self.longitude = validLon
        }
        if let validPhone = serverData["phone"] as? String {
            self.phone = validPhone
        }
        if let validURL = serverData["url"] as? String {
            self.URL = validURL
        }
        if let validAllAges = serverData["all_ages"] as? Bool {
            self.allAges = validAllAges
        }
        if let validGames = serverData["num_games"] as? Int {
            self.numGames = validGames
        }
        if let validMachines = serverData["machines"] as? [[String : AnyObject]] {
            var machineList = [Machine]()
            for machineData in validMachines {
                if let validMachineIdentifier = machineData["id"] as? Int, let validTitleData = machineData["title"] as? [String : AnyObject] {
                    if let validTitleIdentifier = validTitleData["id"] as? Int, let validTitleName = validTitleData["name"] as? String {
                        let newMachine = Machine(identifier: validMachineIdentifier, titleIdentifier: validTitleIdentifier, titleName: validTitleName)
                        machineList.append(newMachine)
                    }
                }
            }
            self.machines = machineList
        }
    }
    
    func loadDetails() {
        AF.request("\(baseAPI)locations/\(self.identifier).json").responseJSON { response in
            switch response.result {
            case .success(let data):
                if let validLocationData = data as? [String : AnyObject] {
                    if let _ = validLocationData["id"] as? String, let _ = validLocationData["name"] as? String,
                        let _ = validLocationData["latitude"] as? Double, let _ = validLocationData["longitude"] as? Double
                    {
                        self.setDetails(validLocationData)
                    }
                }
                NotificationCenter.default.post(name: Notification.Name("LocationDetailsLoaded"), object: self)
            case .failure(let error):
                debugPrint(error)
                return
            }
        }
    }
    
    func matchesSearchString(_ searchString: String) -> Bool {
        let lowercaseSearch = searchString.lowercased()
        if self.name.lowercased().range(of: lowercaseSearch) != nil {
            return true
        }
        
        return false
    }
}

enum SortType: String {
    case Name = "Name"
    case Distance = "Distance"
    case NumOfGames = "Number of Games"
}

class LocationList: NSObject {
    var allLocations = [Location]()
    var locations = [Location]()
    var loadedData = false
    var sortOrder: SortType = .Name {
        didSet {
            self.performSort()
        }
    }
    var allAges = false
    var lastUserLocation: CLLocation?

    static var MinimumDistanceToTriggerUIUpdate: CLLocationDistance = 100.0

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(LocationList.applyFilters(_:)), name: NSNotification.Name(rawValue: "FiltersChosen"), object: nil)
    }
    
    func loadList() {
        AF.request("\(baseAPI)locations/for_wordpress.json").responseJSON { response in
            switch response.result {
            case .success(let data):
                if let validLocationData = data as? [[String : AnyObject]] {
                    for locationData in validLocationData {
                        if let validIdentifier = locationData["id"] as? String, let validName = locationData["name"] as? String,
                            let validLat = locationData["latitude"] as? Double, let validLon = locationData["longitude"] as? Double
                        {
                            let newLocation = Location(identifier: validIdentifier, name: validName, latitude: validLat, longitude: validLon)
                            newLocation.setDetails(locationData)
                            self.allLocations.append(newLocation)
                            self.locations.append(newLocation)
                        }
                    }
                    if let initialUserLocation = self.lastUserLocation {
                        self.updateLocationsWithDistancesFromUserLocation(initialUserLocation)
                    }
                }
                self.loadedData = true
                NotificationCenter.default.post(name: Notification.Name("LocationListLoaded"), object: self)
            case .failure(let error):
                debugPrint(error)
                //TODO: log error somewhere
                return
            }
        }
    }
    
    func updateLocationsWithDistancesFromUserLocation(_ userLocation: CLLocation) {
        guard loadedData == true else {
            return
        }
        if let lastUserLocation = self.lastUserLocation {
            guard lastUserLocation.distance(from: userLocation) > LocationList.MinimumDistanceToTriggerUIUpdate else {
                print("Only moved \(lastUserLocation.distance(from: userLocation))")
                return
            }
        } else {
            self.sortOrder = SortType.Distance
        }
        self.lastUserLocation = userLocation
        for location in allLocations {
            location.distanceAwayInMiles = userLocation.distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude)) * 0.000621371
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LocationListDistancesRecalculated"), object: self)
        if self.sortOrder == SortType.Distance {
            let userInfo: [AnyHashable: Any] = ["Sort" : SortType.Distance.rawValue]
            self.applyFilters(Notification(name: Notification.Name(rawValue: "FiltersChosen"), object: nil, userInfo: userInfo))
        }
    }
    
    @objc func applyFilters(_ notification: Notification) {
        guard let validUserInfo = notification.userInfo else {
            return
        }
        var initialLocations = [String : Int]()
        for (index, location) in locations.enumerated() {
            initialLocations[location.identifier] = index
        }
        self.locations = [Location]()
        if let validAllAgesFilterChosen = validUserInfo["AllAges"] as? Bool {
            self.allAges = validAllAgesFilterChosen
        }
        for location in allLocations {
            if location.allAges || self.allAges == false {
                self.locations.append(location)
            }
        }
        if let validSortText = validUserInfo["Sort"] as? String {
            if let validSortOption = SortType(rawValue: validSortText) {
                self.sortOrder = validSortOption
            }
        }
        
        var finalLocations = [String : Int]()
        for (index, location) in locations.enumerated() {
            finalLocations[location.identifier] = index
        }
        
        let userInfo: [AnyHashable: Any] = ["Initial" : initialLocations, "Final" : finalLocations]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LocationListReordered"), object: self, userInfo: userInfo)
    }
    
    func performSort() {
        switch self.sortOrder {
        case .Name:
            self.locations.sort { (location1: Location, location2: Location) -> Bool in
                location1.name.compare(location2.name) == ComparisonResult.orderedAscending
            }
        case .Distance:
            self.locations.sort { (location1: Location, location2: Location) -> Bool in
                location1.distanceAwayInMiles < location2.distanceAwayInMiles
            }
        case .NumOfGames:
            self.locations.sort { (location1: Location, location2: Location) -> Bool in
                location1.numGames > location2.numGames
            }
        }
    }
}
