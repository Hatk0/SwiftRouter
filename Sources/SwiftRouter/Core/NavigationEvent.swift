//
//  NavigationEvent.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

/// Navigation action type
public enum NavigationType: Sendable {
    case push
    case pop
    case popToRoot
    case sheet
    case fullScreenCover
    case popover
    case dismissSheet
    case dismissFullScreen
    case replace
    case deepLink
}

/// Navigation event for history
public struct NavigationEvent: Identifiable, Sendable {
    public let id = UUID()
    public let route: String?
    public let type: NavigationType
    public let timestamp: Date
}
