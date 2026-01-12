//
//  AnalyticsObserver.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

/// Observer for analytics
public struct AnalyticsObserver: NavigationObserver {
    public let id = UUID()
    private let analyticsService: @Sendable (String, [String: Any]) -> Void
    
    public init(analyticsService: @escaping @Sendable (String, [String: Any]) -> Void) {
        self.analyticsService = analyticsService
    }
    
    public func onNavigationEvent(_ event: NavigationObserverEvent) {
        switch event {
        case .didNavigate(let route, let type):
            analyticsService("screen_view", [
                "screen_name": "\(route)",
                "navigation_type": "\(type)"
            ])
        default:
            break
        }
    }
}
