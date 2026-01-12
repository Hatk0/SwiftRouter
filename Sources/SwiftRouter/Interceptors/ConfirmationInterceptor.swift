//
//  ConfirmationInterceptor.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

/// Interceptor for navigation confirmation
public struct ConfirmationInterceptor: NavigationInterceptor {
    public let id = UUID()
    private let shouldConfirm: @Sendable (String) -> Bool
    private let confirmationHandler: @Sendable (String) async -> Bool
    
    public init(
        shouldConfirm: @escaping @Sendable (String) -> Bool,
        confirmationHandler: @escaping @Sendable (String) async -> Bool
    ) {
        self.shouldConfirm = shouldConfirm
        self.confirmationHandler = confirmationHandler
    }
    
    public func shouldNavigate<Route: Routable>(to route: Route, type: NavigationType) async -> Bool {
        let routeName = String(describing: route)
        
        if shouldConfirm(routeName) {
            return await confirmationHandler(routeName)
        }
        
        return true
    }
}
