//
//  GameLocationsHeaderView.swift
//  Skill Shot
//
//  Created by William Key on 11/5/21.
//

import SwiftUI

struct GameLocationsHeaderView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var name: String

    var body: some View {
        let compactHeight = horizontalSizeClass == .compact
        Group {
            if !compactHeight {
                Text("Where to play")
                    .font(.body)
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
            }
            Text(name)
                .font(.largeTitle).fontWeight(.bold)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .lineLimit(compactHeight ? 1 : 2)
                .minimumScaleFactor(compactHeight ? 0.7 : 1)
        }
    }
}

