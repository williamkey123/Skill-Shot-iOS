//
//  Machine.swift
//  Skill Shot
//
//  Created by William Key on 12/21/15.
//
//

import Foundation
class Machine {
    var identifier: Int
    var title: Title
    
    required init(identifier: Int, title: Title) {
        self.identifier = identifier
        self.title = title
    }

    convenience init(identifier: Int, titleIdentifier: Int, titleName: String) {
        self.init(identifier: identifier, title: Title(identifier: titleIdentifier, name: titleName))
    }

    func containsString(_ searchText: String) -> Bool {
        let lowercaseSearch = searchText.lowercased()

        if self.title.name.lowercased().range(of: lowercaseSearch) != nil {
            return true
        } else {
            return false
        }
    }
}

class Title {
    var identifier: Int
    var name: String

    required init(identifier: Int, name: String) {
        self.identifier = identifier
        self.name = name
    }
}
