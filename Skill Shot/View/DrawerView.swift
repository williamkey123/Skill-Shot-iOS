//
//  DrawerView.swift
//  Skill Shot
//
//  Created by William Key on 10/28/21.
//

import SwiftUI
import MapKit
import Contacts

struct DrawerView: View {
    @Binding var selectedItem: ClusteredLocationItem?
    @Namespace var nspace

    var body: some View {
        GeometryReader { geometry in
            if selectedItem == nil {
                EmptyView()
            } else if geometry.size.width < geometry.size.height {
                PortraitDrawerView(
                    selectedItem: $selectedItem,
                    size: geometry.size
                )
                    .matchedGeometryEffect(
                        id: "DrawerFor\(selectedItem!.id)",
                        in: nspace
                    )
            } else {
                LandscapeDrawerView(
                    selectedItem: $selectedItem,
                    size: geometry.size
                )
                    .matchedGeometryEffect(
                        id: "DrawerFor\(selectedItem!.id)",
                        in: nspace
                    )
            }
        }
    }
}

struct PortraitDrawerView: View {
    @Binding var selectedItem: ClusteredLocationItem?
    var size: CGSize

    var body: some View {
        let width = UIDevice.current.userInterfaceIdiom == .phone ? size.width : size.width / 2

        HStack {
            Spacer(minLength: 0)
            VStack {
                Spacer()
                ItemDrawerView(
                    selectedItem: $selectedItem,
                    size: size,
                    width: width
                )
            }
            Spacer(minLength: 0)
        }
    }
}

struct LandscapeDrawerView: View {
    @Binding var selectedItem: ClusteredLocationItem?
    var size: CGSize

    var body: some View {
        let width = UIDevice.current.userInterfaceIdiom == .phone ? size.width / 2.5 : 280
        VStack {
            Spacer()
            HStack {
                Spacer()
                ItemDrawerView(
                    selectedItem: $selectedItem,
                    size: size,
                    width: width
                )
            }
            Spacer()
        }
    }
}

struct ItemDrawerView: View {
    @Binding var selectedItem: ClusteredLocationItem?
    var size: CGSize
    var width: CGFloat

    var body: some View {
        let locationCount = selectedItem?.locations.count ?? 0
        if locationCount == 1 {
            SingleLocationDrawerView(
                location: selectedItem!.locations.first!,
                selectedItem: $selectedItem,
                frame: size,
                width: width
            )
        } else if locationCount > 1 {
            MultiLocationDrawerView(
                locations: selectedItem!.locations,
                selectedItem: $selectedItem,
                frame: size,
                width: width
            )
        } else {
            EmptyView()
        }
    }

}

struct SingleLocationDrawerView: View {
    var location: Location
    @Binding var selectedItem: ClusteredLocationItem?
    var frame: CGSize
    var width: CGFloat

    var isPortrait: Bool {
        return self.frame.width < self.frame.height
    }

    var maxHeight: CGFloat {
        return 180
    }

    var offset: CGSize {
        if self.isPortrait {
            return CGSize(width: 0, height: 50)
        } else {
            return CGSize(width: -16, height: 0)
        }
    }
    let defaultPadding: CGFloat = 16
    let cornerRadius: CGFloat = 32

    var body: some View {
        VStack {
            HStack {
                Text(location.name)
                    .font(.system(size: 28, weight: .heavy))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer()
                Button {
                    selectedItem = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 28))
                }
                .accentColor(Color.gray)
            }
            .padding(EdgeInsets(top: defaultPadding, leading: defaultPadding, bottom: 6, trailing: defaultPadding))
            VStack(alignment: .leading, spacing: 6) {
                Text(location.address ?? location.phone ?? "Games: \(location.machines.count)")
                NavigationLink {
                    SingleLocationView(location: location)
                } label: {
                    HStack {
                        Text("See Details")
                        Spacer()
                        Image(systemName: "chevron.forward")
                    }
                }
            }
            .font(.system(size: 18))
            .padding(EdgeInsets(top: 0, leading: defaultPadding, bottom: cornerRadius, trailing: defaultPadding))
            if isPortrait {
                Spacer().frame(height: 50)
            }
        }
        .frame(width: self.width)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color("DrawerBackground"))
        )
        .ignoresSafeArea(.container, edges: [.leading, .trailing])
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .offset(self.offset)
    }
}

struct MultiLocationDrawerView: View {
    var locations: [Location]
    @Binding var selectedItem: ClusteredLocationItem?
    var frame: CGSize
    var width: CGFloat

    var isPortrait: Bool {
        return self.frame.width < self.frame.height
    }

    var maxHeight: CGFloat {
        if self.isPortrait {
            return self.frame.height / 3.3
        } else {
            return self.frame.height - (cornerRadius * 4)
        }
    }

    var offset: CGSize {
        if self.isPortrait {
            return CGSize(width: 0, height: 50)
        } else {
            return CGSize(width: -16, height: 0)
        }
    }
    let defaultPadding: CGFloat = 16
    let cornerRadius: CGFloat = 32

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Venues")
                    .font(.system(size: 28, weight: .heavy))
                Spacer()
                Button {
                    self.selectedItem = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 28))
                }
                .accentColor(Color.gray)
            }
            .padding(EdgeInsets(top: defaultPadding, leading: defaultPadding, bottom: 6, trailing: defaultPadding))
            if locations.count == 2 {
                SingleLocationWrapperRowView(location: locations[0])
                SingleLocationWrapperRowView(location: locations[1], hideDivider: true)
                Spacer().frame(height: 16)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(locations) { location in
                            SingleLocationWrapperRowView(
                                location: location,
                                hideDivider: location == locations.last
                            )
                        }
                        Spacer().frame(height: 12)
                    }
                }
                .frame(maxHeight: self.maxHeight)
            }
            if isPortrait {
                Spacer().frame(height: 50)
            }
        }
        .frame(width: self.width)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color("DrawerBackground"))
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .offset(self.offset)
    }
}

struct SingleLocationWrapperRowView: View {
    var location: Location
    var hideDivider: Bool = false

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                SingleLocationRowView(location: location)
                Spacer()
                Image(systemName: "chevron.forward")
                    .foregroundColor(.gray)
            }
            .padding(EdgeInsets(top: 3, leading: 18, bottom: 3, trailing: 12))
            if !hideDivider {
                Rectangle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(height: 0.5)
                    .padding(EdgeInsets(top: 1, leading: 18, bottom: 1, trailing: 0))
            }
        }
    }
}
