//
//  Router.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import SwiftUI

@MainActor
public final class Router<Route: Routable>: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Navigation stack for push transitions
    @Published public var path = NavigationPath()
    
    /// Current sheet route
    @Published public var sheet: Route?
    
    /// Current fullScreenCover route
    @Published public var fullScreenCover: Route?
    
    /// Popover route (for iPad)
    @Published public var popover: Route?
    
    /// History of all transitions (for analytics/debugging)
    @Published private(set) public var navigationHistory: [NavigationEvent] = []
    
    // MARK: - Private Properties
    
    /// Interceptors for navigation handling
    private var interceptors: [any NavigationInterceptor] = []
    
    /// Observers for tracking navigation events
    private var observers: [any NavigationObserver] = []
    
    /// Maximum history size
    private let maxHistorySize: Int
    
    // MARK: - Initialization
    
    public init(maxHistorySize: Int = 100) {
        self.maxHistorySize = maxHistorySize
    }
    
    // MARK: - Navigation Methods
    
    /// Push navigation to new screen
    public func push(_ route: Route) {
        Task {
            guard await shouldNavigate(to: route, type: .push) else { return }
            
            path.append(route)
            recordNavigation(route: route, type: .push)
            notifyObservers(event: .didNavigate(to: route, type: .push))
        }
    }
    
    /// Pop to previous screen
    public func pop() {
        guard !path.isEmpty else { return }
        
        path.removeLast()
        recordNavigation(route: nil, type: .pop)
        notifyObservers(event: .didPop)
    }
    
    /// Pop to root screen
    public func popToRoot() {
        guard !path.isEmpty else { return }
        
        let count = path.count
        path.removeLast(count)
        recordNavigation(route: nil, type: .popToRoot)
        notifyObservers(event: .didPopToRoot)
    }
    
    /// Pop N screens back
    public func pop(count: Int) {
        let actualCount = min(count, path.count)
        guard actualCount > 0 else { return }
        
        path.removeLast(actualCount)
        recordNavigation(route: nil, type: .pop)
    }
    
    /// Present sheet
    public func presentSheet(_ route: Route) {
        Task {
            guard await shouldNavigate(to: route, type: .sheet) else { return }
            
            sheet = route
            recordNavigation(route: route, type: .sheet)
            notifyObservers(event: .didNavigate(to: route, type: .sheet))
        }
    }
    
    /// Dismiss sheet
    public func dismissSheet() {
        sheet = nil
        recordNavigation(route: nil, type: .dismissSheet)
        notifyObservers(event: .didDismissSheet)
    }
    
    /// Present fullScreenCover
    public func presentFullScreen(_ route: Route) {
        Task {
            guard await shouldNavigate(to: route, type: .fullScreenCover) else { return }
            
            fullScreenCover = route
            recordNavigation(route: route, type: .fullScreenCover)
            notifyObservers(event: .didNavigate(to: route, type: .fullScreenCover))
        }
    }
    
    /// Dismiss fullScreenCover
    public func dismissFullScreen() {
        fullScreenCover = nil
        recordNavigation(route: nil, type: .dismissFullScreen)
        notifyObservers(event: .didDismissFullScreen)
    }
    
    /// Present popover
    public func presentPopover(_ route: Route) {
        Task {
            guard await shouldNavigate(to: route, type: .popover) else { return }
            
            popover = route
            recordNavigation(route: route, type: .popover)
            notifyObservers(event: .didNavigate(to: route, type: .popover))
        }
    }
    
    /// Dismiss popover
    public func dismissPopover() {
        popover = nil
    }
    
    /// Dismiss all modals
    public func dismissAll() {
        sheet = nil
        fullScreenCover = nil
        popover = nil
        notifyObservers(event: .didDismissAll)
    }
    
    /// Replace current stack with new route
    public func replace(with route: Route) {
        path.removeLast(path.count)
        path.append(route)
        recordNavigation(route: route, type: .replace)
    }
    
    // MARK: - Deep Linking
    
    /// Navigate using deep link path
    public func navigate(to routes: [Route]) {
        path.removeLast(path.count)
        for route in routes {
            path.append(route)
        }
        recordNavigation(route: routes.last, type: .deepLink)
    }
    
    // MARK: - Interceptors
    
    /// Add interceptor for navigation handling
    public func addInterceptor(_ interceptor: any NavigationInterceptor) {
        interceptors.append(interceptor)
    }
    
    
    /// Clear all interceptors
    public func clearInterceptors() {
        interceptors.removeAll()
    }
    
    // MARK: - Observers
    
    /// Add observer for event tracking
    public func addObserver(_ observer: any NavigationObserver) {
        observers.append(observer)
    }
    
    
    /// Clear all observers
    public func clearObservers() {
        observers.removeAll()
    }
}

private extension Router {
    
    func shouldNavigate(to route: Route, type: NavigationType) async -> Bool {
        let currentInterceptors = await MainActor.run { interceptors }
        for interceptor in currentInterceptors {
            let canNavigate = await interceptor.shouldNavigate(to: route, type: type)
            if !canNavigate {
                return false
            }
        }
        return true
    }
    
    func recordNavigation(route: Route?, type: NavigationType) {
        let event = NavigationEvent(
            route: route.map { "\($0)" },
            type: type,
            timestamp: Date()
        )
        
        navigationHistory.append(event)
        
        // Limit history size
        if navigationHistory.count > maxHistorySize {
            navigationHistory.removeFirst(navigationHistory.count - maxHistorySize)
        }
    }
    
    func notifyObservers(event: NavigationObserverEvent) {
        for observer in observers {
            observer.onNavigationEvent(event)
        }
    }
}
