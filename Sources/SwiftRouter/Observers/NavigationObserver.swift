//
//  NavigationObserver.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

/// Events for observers
public enum NavigationObserverEvent {
    case didNavigate(to: Any, type: NavigationType)
    case didPop
    case didPopToRoot
    case didDismissSheet
    case didDismissFullScreen
    case didDismissAll
}

/// Protocol for observers that track navigation
public protocol NavigationObserver: Identifiable, Sendable {
    /// Called on navigation event
    func onNavigationEvent(_ event: NavigationObserverEvent)
}
