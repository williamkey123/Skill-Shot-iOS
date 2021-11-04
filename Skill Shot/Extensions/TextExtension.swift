//
//  TextExtension.swift
//  Skill Shot
//
//  Created by William Key on 10/29/21.
//

import Foundation
import SwiftUI

extension Text {
    init(_ string: String, highlighting: String?, in color: Color = Color("SkillShotTintColor").opacity(0.7)) {
        guard let highlighting = highlighting else {
            self.init(string)
            return
        }

        if #available(iOS 15, *) {
            var stringRanges = [Range<String.Index>]()
            while let range = string.range(
                of: highlighting,
                options: .caseInsensitive,
                range: (stringRanges.last?.upperBound ?? string.startIndex) ..< string.endIndex
            ) {
                stringRanges.append(range)
            }
            if stringRanges.isEmpty {
                self.init(string)
                return
            }

            var attributedString = AttributedString(string.prefix(upTo: stringRanges.first!.lowerBound))
            var attributedHighlight = AttributedString(highlighting)
            attributedHighlight.backgroundColor = color
            for (rangeNum, range) in stringRanges.enumerated() {
                attributedString += attributedHighlight
                var nextIndex = string.endIndex
                if rangeNum + 1 < stringRanges.count {
                    nextIndex = stringRanges[rangeNum + 1].lowerBound
                }
                let range = range.upperBound ..< nextIndex
                attributedString += AttributedString(string[range])
            }
            self.init(attributedString)
        } else {
            self.init(string)
        }
    }
}
