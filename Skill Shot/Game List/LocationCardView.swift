//
//  LocationCardView.swift
//  Skill Shot
//
//  Created by William Key on 11/5/21.
//

import SwiftUI

struct RegularLocationCardView: View {
    var location: Location
    var selected: Bool
    @State var showingDetail: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text(location.name)
                    .font(.headline)
                    .lineLimit(2)
                Text(location.address ?? location.phone ?? "\(location.machines.count) games")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                Spacer(minLength: 0)
                Button {
                    showingDetail = true
                } label: {
                    Text("Show Details")
                }
                .sheet(isPresented: $showingDetail) {
                    NavigationView {
                        SingleLocationView(location: location)
                            .toolbar {
                                ToolbarItemGroup(placement: .navigationBarTrailing) {
                                    Button {
                                        showingDetail = false
                                    } label: {
                                        Text("Done").bold()
                                    }
                                }
                            }
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .frame(width: 160, height: 100)
        .padding()
        .background(
            ZStack {
                if selected {
                    RoundedRectangle(cornerRadius: 9)
                        .stroke(Color("SkillShotTintColor"), lineWidth: 4)
                }
                RoundedRectangle(cornerRadius: 9)
                    .fill(selected ? Color("LocationCardBackgroundSelected") : Color("LocationCardBackground"))
//                    .scaleEffect(0.98)
            }
        )
        .compositingGroup()
        .shadow(radius: 4)
        .padding(.vertical)
        .padding(.horizontal, 8)
    }
}

struct CompactLocationCardView: View {
    var location: Location
    var selected: Bool
    @State var showingDetail: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text(location.name)
                    .font(.headline)
                    .lineLimit(2)
                Text(location.address ?? location.phone ?? "\(location.machines.count) games")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                Button {
                    showingDetail = true
                } label: {
                    Text("Show Details")
                }
                .sheet(isPresented: $showingDetail) {
                    NavigationView {
                        SingleLocationView(location: location)
                            .toolbar {
                                ToolbarItemGroup(placement: .navigationBarTrailing) {
                                    Button {
                                        showingDetail = false
                                    } label: {
                                        Text("Done").bold()
                                    }
                                }
                            }
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .frame(width: 160)
        .padding()
        .background(
            ZStack {
                if selected {
                    RoundedRectangle(cornerRadius: 9)
                        .stroke(Color("SkillShotTintColor"), lineWidth: 4)
                }
                RoundedRectangle(cornerRadius: 9)
                    .fill(selected ? Color("LocationCardBackgroundSelected") : Color("LocationCardBackground"))
            }
        )
        .compositingGroup()
        .shadow(color: Color("CardShadow"), radius: 3, x: 1, y: 1)
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
    }
}
