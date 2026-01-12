//
//  MockRouter.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import SwiftUI

#if DEBUG
/// Mock router for testing
@MainActor
public final class MockRouter<Route: Routable>: ObservableObject {
    
    @Published public var path = NavigationPath()
    @Published public var sheet: Route?
    @Published public var fullScreenCover: Route?
    @Published public var popover: Route?
    @Published public private(set) var navigationHistory: [NavigationEvent] = []
    
    // Tracking for tests
    public private(set) var pushedRoutes: [Route] = []
    public private(set) var poppedCount: Int = 0
    public private(set) var presentedSheets: [Route] = []
    public private(set) var dismissedSheetsCount: Int = 0
    
    public init() {}
    
    public func push(_ route: Route) {
        pushedRoutes.append(route)
        path.append(route)
        recordNavigation(route: route, type: .push)
    }
    
    public func pop() {
        poppedCount += 1
        if !path.isEmpty {
            path.removeLast()
        }
        recordNavigation(route: nil, type: .pop)
    }
    
    public func popToRoot() {
        let count = path.count
        poppedCount += count
        path.removeLast(count)
        recordNavigation(route: nil, type: .popToRoot)
    }
    
    public func presentSheet(_ route: Route) {
        presentedSheets.append(route)
        sheet = route
        recordNavigation(route: route, type: .sheet)
    }
    
    public func dismissSheet() {
        dismissedSheetsCount += 1
        sheet = nil
        recordNavigation(route: nil, type: .dismissSheet)
    }
    
    public func presentFullScreen(_ route: Route) {
        fullScreenCover = route
        recordNavigation(route: route, type: .fullScreenCover)
    }
    
    public func dismissFullScreen() {
        fullScreenCover = nil
        recordNavigation(route: nil, type: .dismissFullScreen)
    }
    
    public func dismissAll() {
        sheet = nil
        fullScreenCover = nil
        popover = nil
    }
    
    public func reset() {
        pushedRoutes.removeAll()
        poppedCount = 0
        presentedSheets.removeAll()
        dismissedSheetsCount = 0
        navigationHistory.removeAll()
        path = NavigationPath()
        sheet = nil
        fullScreenCover = nil
        popover = nil
    }
    
    private func recordNavigation(route: Route?, type: NavigationType) {
        let event = NavigationEvent(
            route: route.map { "\($0)" },
            type: type,
            timestamp: Date()
        )
        navigationHistory.append(event)
    }
}

// MARK: - Testing Helpers

public extension MockRouter {
    
    /// Checking the latest push
    var lastPushedRoute: Route? {
        pushedRoutes.last
    }
    
    /// Checking whether a specific route was pushed
    func didPush(_ route: Route) -> Bool {
        pushedRoutes.contains(route)
    }
    
    /// Clearing history for the next test
    func clearHistory() {
        pushedRoutes.removeAll()
        poppedCount = 0
        presentedSheets.removeAll()
        dismissedSheetsCount = 0
    }
}
#endif
