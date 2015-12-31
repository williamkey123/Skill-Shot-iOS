//
//  Location.swift
//  Skill Shot
//
//  Created by Will Clarke on 12/21/15.
//
//

import Foundation
import Alamofire
import MapKit

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
        return validPhone.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
    }
    
    required init(identifier: String, name: String, latitude: Double, longitude: Double, allAges: Bool = false, numGames: Int = 0) {
        self.identifier = identifier
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.allAges = allAges
        self.numGames = numGames
    }

    func setDetails(serverData: [String: AnyObject]) {
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
                if let validMachineIdentifier = machineData["id"] as? Int, validTitleData = machineData["title"] as? [String : AnyObject] {
                    if let validTitleIdentifier = validTitleData["id"] as? Int, validTitleName = validTitleData["name"] as? String {
                        let newMachine = Machine(identifier: validMachineIdentifier, titleIdentifier: validTitleIdentifier, titleName: validTitleName)
                        machineList.append(newMachine)
                    }
                }
            }
            self.machines = machineList
        }
    }
    
    func loadDetails() {
        Alamofire.request(.GET, "\(baseAPI)locations/\(self.identifier).json").responseJSON { response in
            guard response.result.isSuccess else {
                return
            }
            if let validLocationData = response.result.value as? [String : AnyObject] {
                if let _ = validLocationData["id"] as? String, _ = validLocationData["name"] as? String,
                    _ = validLocationData["latitude"] as? Double, _ = validLocationData["longitude"] as? Double
                {
                    self.setDetails(validLocationData)
                }
            }
            NSNotificationCenter.defaultCenter().postNotificationName("LocationDetailsLoaded", object: self)
        }
    }
}

class LocationList {
    var locations = [Location]()
    var loadedData = false
    
    func loadList() {
        Alamofire.request(.GET, "\(baseAPI)locations.json").responseJSON { response in
            guard response.result.isSuccess else {
                return
            }
            self.loadedData = true
            if let validLocationData = response.result.value as? [[String : AnyObject]] {
                for locationData in validLocationData {
                    if let validIdentifier = locationData["id"] as? String, validName = locationData["name"] as? String,
                        validLat = locationData["latitude"] as? Double, validLon = locationData["longitude"] as? Double
                    {
                        let newLocation = Location(identifier: validIdentifier, name: validName, latitude: validLat, longitude: validLon)
                        newLocation.setDetails(locationData)
                        self.locations.append(newLocation)
                    }
                }
            }
            NSNotificationCenter.defaultCenter().postNotificationName("LocationListLoaded", object: self)
        }
    }
    
    func updateLocationsWithDistancesFromUserLocation(userLocation: CLLocation) {
        for location in locations {
            location.distanceAwayInMiles = userLocation.distanceFromLocation(CLLocation(latitude: location.latitude, longitude: location.longitude)) * 0.000621371
        }
        NSNotificationCenter.defaultCenter().postNotificationName("LocationListLoaded", object: self)
    }
}
