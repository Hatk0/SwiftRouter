//
//  PresentationType.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import SwiftUI

/// Route presentation types
public enum PresentationType {
    case push // NavigationStack push
    case sheet // Modal sheet presentation
    case fullScreenCover // Full-screen modal
    case popover // Popover (iPad)
    case replace // Replace current screen
    case custom(AnyTransition) // Custom animation
}
