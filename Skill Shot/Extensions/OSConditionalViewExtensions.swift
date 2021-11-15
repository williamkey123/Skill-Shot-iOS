//
//  OSConditionalViewExtensions.swift
//  Skill Shot
//
//  Created by William Key on 11/14/21.
//

import Foundation
import SwiftUI

extension View {
    func conditionallySearchable(
        text: Binding<String>,
        prompt: String? = nil
    ) -> some View {
        self.modifier(
            ConditionallySearchable(
                text: text,
                prompt: prompt
            )
        )
    }

    func listRowBackground(active: Bool, color: Color = Color.gray.opacity(0.4)) -> some View {
        self.modifier(ConditionalListRowBackground(active: active, color: color))
    }
}

struct ConditionalListRowBackground: ViewModifier {
    var active: Bool
    var color: Color

    func body(content: Content) -> some View {
        if active {
            content.listRowBackground(color)
        } else {
            content
        }
    }
}

struct ConditionallySearchable: ViewModifier {
    @Binding var text: String
    var prompt: String? = nil

    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content.searchable(
                text: $text,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: self.prompt ?? ""
            )
        } else {
            content
        }
    }
}
