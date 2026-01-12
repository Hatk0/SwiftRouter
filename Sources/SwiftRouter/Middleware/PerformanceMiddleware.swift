//
//  PerformanceMiddleware.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

/// Middleware for performance logging
public actor PerformanceMiddleware<Route: Routable>: RouterMiddleware {
    
    private var startTime: [String: Date] = [:]
    
    public init() {}
    
    public func beforeNavigation(to route: Route, type: NavigationType) async {
        let key = "\(route)"
        startTime[key] = Date()
    }
    
    public func afterNavigation(to route: Route, type: NavigationType) async {
        let key = "\(route)"
        if let start = startTime[key] {
            let duration = Date().timeIntervalSince(start)
            print("Navigation to \(route) took \(duration)s")
            startTime.removeValue(forKey: key)
        }
    }
}
