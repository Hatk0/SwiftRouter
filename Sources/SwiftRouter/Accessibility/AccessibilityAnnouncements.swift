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
        // Extract announcement before Task to avoid data race
        let announcement: String? = {
            switch event {
            case .didNavigate(let route, _):
                return "Navigated to \(route)"
            case .didPop:
                return "Navigated back"
            case .didPopToRoot:
                return "Returned to home"
            default:
                return nil
            }
        }()
        
        guard let announcement = announcement else { return }
        
        Task { @MainActor in
            UIAccessibility.post(notification: .screenChanged, argument: announcement)
        }
        #endif
    }
}
