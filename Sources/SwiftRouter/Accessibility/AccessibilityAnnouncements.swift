//
//  AccessibilityAnnouncements.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import SwiftUI

/// Observer for accessibility announcements
public struct AccessibilityObserver: NavigationObserver {
    public let id = UUID()
    
    public init() {}
    
    public func onNavigationEvent(_ event: NavigationObserverEvent) {
        #if os(iOS) || os(tvOS) || os(watchOS)
        switch event {
        case .didNavigate(let route, _):
            let announcement = "Navigated to \(route)"
            UIAccessibility.post(notification: .screenChanged, argument: announcement)
            
        case .didPop:
            UIAccessibility.post(notification: .screenChanged, argument: "Navigated back")
            
        case .didPopToRoot:
            UIAccessibility.post(notification: .screenChanged, argument: "Returned to home")
            
        default:
            break
        }
        #endif
    }
}
