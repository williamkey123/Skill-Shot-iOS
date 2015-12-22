//
//  Machine.swift
//  Skill Shot
//
//  Created by Will Clarke on 12/21/15.
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
}

class Title {
    var identifier: Int
    var name: String

    required init(identifier: Int, name: String) {
        self.identifier = identifier
        self.name = name
    }
}