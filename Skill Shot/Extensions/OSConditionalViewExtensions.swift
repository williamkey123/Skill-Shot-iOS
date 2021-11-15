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
