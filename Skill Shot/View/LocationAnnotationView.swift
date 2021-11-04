//
//  LocationAnnotationView.swift
//  Skill Shot
//
//  Created by William Key on 10/28/21.
//

import SwiftUI

struct LocationAnnotationView: View {
    var count: Int
    var selected: Bool

    var body: some View {
        let size: CGFloat = 36
        let scale: CGFloat = selected ? 1.2 : 1
        let color = selected ? Color("SkillShotDarkerColor") : Color("SkillShotTintColor")

        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .overlay(
                Rectangle()
                    .rotation(Angle(degrees: 45))
                    .fill(color)
                    .frame(width: size/3, height: size/3)
                    .offset(x: 0, y: 2 + size/3)
            )
            .compositingGroup()
            .shadow(radius: 3)
            .overlay(
                Text("\(count)")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .bold))
            )
            .scaleEffect(scale, anchor: UnitPoint(x: 0.5, y: 1.0))
            .animation(.default, value: selected)
    }
}

struct LocationAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationAnnotationView(count: 5, selected: false)
    }
}
