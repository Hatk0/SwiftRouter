//
//  NavigationSecurity.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

/// Interceptor for safe navigation
public struct SecurityInterceptor: NavigationInterceptor {
    public let id = UUID()
    
    private let blockedRoutes: Set<String>
    private let securityCheck: @Sendable (String) async -> Bool
    
    public init(
        blockedRoutes: Set<String> = [],
        securityCheck: @escaping @Sendable (String) async -> Bool = { _ in true }
    ) {
        self.blockedRoutes = blockedRoutes
        self.securityCheck = securityCheck
    }
    
    public func shouldNavigate<Route: Routable>(to route: Route, type: NavigationType) async -> Bool {
        let routeName = String(describing: route)
        
        // Checking blocked routes
        if blockedRoutes.contains(routeName) {
            print("Navigation blocked: Route '\(routeName)' is in blocklist")
            return false
        }
        
        // Custom security check
        let isSecure = await securityCheck(routeName)
        if !isSecure {
            print("Navigation blocked: Security check failed for '\(routeName)'")
        }
        
        return isSecure
    }
}
