//
//  NavigationInterceptor.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

/// Protocol for interceptors that can block navigation
public protocol NavigationInterceptor: Identifiable, Sendable {
    /// Determines if navigation can proceed
    func shouldNavigate<Route: Routable>(to route: Route, type: NavigationType) async -> Bool
}
