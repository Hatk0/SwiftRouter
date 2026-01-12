//
//  RateLimitMiddleware.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

/// Middleware for Rate Limiting
public actor RateLimitMiddleware<Route: Routable>: RouterMiddleware {
    
    private var lastNavigationTime: Date?
    private let minimumInterval: TimeInterval
    
    public init(minimumInterval: TimeInterval = 0.3) {
        self.minimumInterval = minimumInterval
    }
    
    public func beforeNavigation(to route: Route, type: NavigationType) async {
        if let last = lastNavigationTime {
            let elapsed = Date().timeIntervalSince(last)
            if elapsed < minimumInterval {
                let delay = minimumInterval - elapsed
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
    }
    
    public func afterNavigation(to route: Route, type: NavigationType) async {
        lastNavigationTime = Date()
    }
}
