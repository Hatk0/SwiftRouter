//
//  AuthInterceptor.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

/// Interceptor for authentication checks
public struct AuthInterceptor: NavigationInterceptor {
    public let id = UUID()
    private let isAuthenticated: @Sendable () -> Bool
    private let protectedRoutes: Set<String>
    
    public init(isAuthenticated: @escaping @Sendable () -> Bool, protectedRoutes: Set<String>) {
        self.isAuthenticated = isAuthenticated
        self.protectedRoutes = protectedRoutes
    }
    
    public func shouldNavigate<Route: Routable>(to route: Route, type: NavigationType) async -> Bool {
        let routeName = String(describing: route)
        
        if protectedRoutes.contains(routeName) && !isAuthenticated() {
            print("Navigation blocked: User not authenticated for route \(routeName)")
            return false
        }
        
        return true
    }
}
