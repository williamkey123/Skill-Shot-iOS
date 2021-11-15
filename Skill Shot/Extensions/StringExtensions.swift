//
//  StringExtensions.swift
//  Skill Shot
//
//  Created by William Key on 11/15/21.
//

import Foundation

extension String {
    var trimmingWhitespace: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
