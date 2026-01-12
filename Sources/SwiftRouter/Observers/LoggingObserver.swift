//
//  LoggingObserver.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

public struct LoggingObserver: NavigationObserver {
    public let id = UUID()
    
    public init() {}
    
    public func onNavigationEvent(_ event: NavigationObserverEvent) {
        switch event {
        case .didNavigate(let route, let type):
            print("Navigation: \(type) to \(route)")
        case .didPop:
            print("Navigation: Pop")
        case .didPopToRoot:
            print("Navigation: Pop to root")
        case .didDismissSheet:
            print("Navigation: Dismiss sheet")
        case .didDismissFullScreen:
            print("Navigation: Dismiss full screen")
        case .didDismissAll:
            print("Navigation: Dismiss all")
        }
    }
}
