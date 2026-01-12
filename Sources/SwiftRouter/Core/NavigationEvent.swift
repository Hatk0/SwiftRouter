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

/// Navigation event for history tracking
///
/// Generic over `Route` type for type-safe event tracking.
/// Use `NavigationEvent<AppRoute>` where `AppRoute` is your route enum.
public struct NavigationEvent<Route: Routable>: Identifiable, Sendable {
    public let id = UUID()
    public let route: Route?
    public let type: NavigationType
    public let timestamp: Date
    
    public init(route: Route?, type: NavigationType, timestamp: Date) {
        self.route = route
        self.type = type
        self.timestamp = timestamp
    }
}
