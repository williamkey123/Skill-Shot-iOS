//
//  UIDeviceOrientationExtension.swift
//  Skill Shot
//
//  Created by William Key on 10/29/21.
//

import SwiftUI

extension UIDeviceOrientation {
    var isSupported: Bool {
        switch self {
        case .portrait, .landscapeLeft, .landscapeRight:
            return true
        case .portraitUpsideDown:
            if UIDevice.current.userInterfaceIdiom == .pad {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }

    static var currentSupported: UIDeviceOrientation {
        let currentOrientation = UIDevice.current.orientation
        if currentOrientation.isSupported {
            return currentOrientation
        } else {
            return .portrait
        }
    }
}
