//
//  RouterMiddleware.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

/// Middleware for navigation processing
public protocol RouterMiddleware {
    associatedtype Route: Routable
    
    /// Processing before navigation
    func beforeNavigation(to route: Route, type: NavigationType) async
    
    /// Post-navigation processing
    func afterNavigation(to route: Route, type: NavigationType) async
}
