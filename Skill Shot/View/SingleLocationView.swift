//
//  SingleLocationView.swift
//  Skill Shot
//
//  Created by William Key on 10/27/21.
//

import SwiftUI
import MapKit
import Contacts

struct SingleLocationView: View {
    var location: Location

    var body: some View {
        GeometryReader { geometry in
            if geometry.size.width < geometry.size.height {
                VStack(alignment: .leading, spacing: 8) {
                    LocationSummaryHeaderView(location: location)
                        .padding(.bottom, 10)
                    LocationGameList(machines: location.machines)
                }
            } else {
                HStack(alignment: .top, spacing: 16) {
                    LocationSummaryHeaderView(location: location)
                    LocationGameList(machines: location.machines)
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SingleLocationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SingleLocationView(
                location: Location(
                    id: "jcgducvg",
                    name: "Shorty's",
                    address: "823 Buttland Drive",
                    latitude: 47.6144972,
                    longitude: -122.3460231,
                    phone: "(504) 626-9193",
                    urlString: "https://www.google.com",
                    allAges: false,
                    numGames: 16,
                    machines: [
                        Machine(
                            id: 234324,
                            game: Game(id: 765786, name: "Pinballer Pro")
                        ),
                        Machine(
                            id: 23324,
                            game: Game(id: 76578, name: "Boink bonk")
                        ),
                        Machine(
                            id: 23434,
                            game: Game(id: 76576, name: "Ding donger")
                        ),
                    ],
                    distanceAwayInMiles: 0
                )
            )
        }
    }
}

struct AddressRowView: View {
    var address: String
    var location: Location

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if #available(iOS 15.0, *) {
                Text(address).textSelection(.enabled).font(.body)
            } else {
                Text(address).font(.body)
            }
            Button {
                var addressDictionary = [String : AnyObject]()
                if let validAddress = location.address {
                    addressDictionary[CNPostalAddressStreetKey] = validAddress as AnyObject
                }
                if let validCity = location.city {
                    addressDictionary[CNPostalAddressCityKey] = validCity as AnyObject
                }
                if let validPostalCode = location.postalCode {
                    addressDictionary[CNPostalAddressPostalCodeKey] = validPostalCode as AnyObject
                }
                let mapPlacemark = MKPlacemark(
                    coordinate: location.coordinate,
                    addressDictionary: addressDictionary
                )
                let mapItem = MKMapItem(placemark: mapPlacemark)
                mapItem.name = location.name
                mapItem.openInMaps(launchOptions: nil)
            } label: {
                Label("Open in Maps", systemImage: "mappin.and.ellipse")
                    .font(.caption)
            }
        }
        .padding(.horizontal)
    }
}

struct WebsiteRowView: View {
    var urlString: String

    var body: some View {
        if let url = URL(string: urlString),
           UIApplication.shared.canOpenURL(url)
        {
            VStack(alignment: .leading, spacing: 2) {
                if #available(iOS 15.0, *) {
                    Text(urlString).textSelection(.enabled).font(.body)
                } else {
                    Text(urlString).font(.body)
                }
                Button {
                    UIApplication.shared.open(url)
                } label: {
                    Label(
                        "Visit Website",
                        systemImage: "link"
                    )
                        .font(.caption)
                }
            }
            .padding(.horizontal)
        } else {
            EmptyView()
        }
    }
}

struct PhoneNumberRowView: View {
    var phone: String

    var body: some View {
        let formattedPhone = phone.components(
            separatedBy: CharacterSet.decimalDigits.inverted
        ).joined(separator: "")

        VStack(alignment: .leading, spacing: 2) {
            if #available(iOS 15.0, *) {
                Text(phone).textSelection(.enabled).font(.body)
            } else {
                Text(phone).font(.body)
            }
            if let url = URL(string: "tel://\(formattedPhone)"),
                UIApplication.shared.canOpenURL(url)
            {
                Button {
                    UIApplication.shared.open(url)
                } label: {
                    Label("Call Phone Number", systemImage:   "phone.arrow.up.right")
                }
            }
        }
        .padding(.horizontal)
    }
}

struct LocationSummaryHeaderView: View {
    var location: Location

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(location.name)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.horizontal)
            if let address = location.address {
                AddressRowView(address: address, location: location)
            }
            if let phone = location.phone {
                PhoneNumberRowView(phone: phone)
            }
            if let urlString = location.urlString {
                WebsiteRowView(urlString: urlString)
            }
        }
    }
}

struct LocationGameList: View {
    var machines: [Machine]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("All Games")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(
                Rectangle().fill(Color.gray.opacity(0.4))
            )

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(machines) { machine in
                        Text(machine.game.name)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        if machine != machines.last {
                            Rectangle()
                                .fill(Color.gray.opacity(0.6))
                                .padding(.leading, 16)
                                .frame(height: 0.5)
                        }
                    }
                }
            }
        }
        .clipped()
    }
}
