import Testing
import SwiftUI
@testable import SwiftRouter

// MARK: - Interceptor Tests

@Suite("Interceptor Tests")
struct InterceptorTests {
    
    // Mock interceptor for testing
    struct MockInterceptor: NavigationInterceptor {
        let id = UUID()
        var shouldBlock: Bool
        
        func shouldNavigate<Route: Routable>(to route: Route, type: NavigationType) async -> Bool {
            return !shouldBlock
        }
    }
    
    @Test("Interceptor blocks navigation when returning false")
    @MainActor
    func interceptorBlocksNavigation() async {
        let router = Router<AppRoute>()
        let blockingInterceptor = MockInterceptor(shouldBlock: true)
        
        router.addInterceptor(blockingInterceptor)
        router.push(.home)
        
        // Wait for async navigation
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(router.path.count == 0) // Navigation should be blocked
    }
    
    @Test("Interceptor allows navigation when returning true")
    @MainActor
    func interceptorAllowsNavigation() async {
        let router = Router<AppRoute>()
        let allowingInterceptor = MockInterceptor(shouldBlock: false)
        
        router.addInterceptor(allowingInterceptor)
        router.push(.home)
        
        // Wait for async navigation
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(router.path.count == 1) // Navigation should succeed
    }
    
    @Test("clearInterceptors removes all interceptors")
    @MainActor
    func clearAllInterceptors() async {
        let router = Router<AppRoute>()
        router.addInterceptor(MockInterceptor(shouldBlock: true))
        router.addInterceptor(MockInterceptor(shouldBlock: true))
        
        router.clearInterceptors()
        router.push(.home)
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(router.path.count == 1) // Should navigate (all interceptors cleared)
    }
}

// MARK: - Observer Tests

@Suite("Observer Tests")
struct ObserverTests {
    
    struct MockObserver: NavigationObserver {
        let id = UUID()
        
        func onNavigationEvent(_ event: NavigationObserverEvent) {
            // In real implementation, this would send events to analytics
        }
    }
    
    @Test("Can add and clear observers")
    @MainActor
    func addAndClearObservers() {
        let router = Router<AppRoute>()
        let observer = MockObserver()
        
        router.addObserver(observer)
        router.clearObservers()
        
        // Should not crash
        #expect(true)
    }
}

// MARK: - Edge Case Tests

@Suite("Edge Case Tests")
struct EdgeCaseTests {
    
    @Test("Rapid navigation attempts are handled safely")
    @MainActor
    func rapidNavigationAttempts() async {
        let router = Router<AppRoute>()
        
        // Simulate rapid button taps
        router.push(.home)
        router.push(.settings)
        router.push(.profile(userId: "123"))
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        // Should handle without crashing and have some navigation
        #expect(router.path.count >= 1)
    }
    
    @Test("Pop on empty stack does nothing")
    @MainActor
    func popOnEmptyStack() {
        let router = Router<AppRoute>()
        
        router.pop() // Should not crash
        
        #expect(router.path.isEmpty)
    }
    
    @Test("PopToRoot on empty stack does nothing")
    @MainActor
    func popToRootOnEmptyStack() {
        let router = Router<AppRoute>()
        
        router.popToRoot() // Should not crash
        
        #expect(router.path.isEmpty)
    }
    
    @Test("Navigation history respects max size")
    @MainActor
    func navigationHistoryMaxSize() async {
        let router = Router<AppRoute>(maxHistorySize: 5)
        
        // Add more than max
        for _ in 0..<10 {
            router.push(.home)
            try? await Task.sleep(nanoseconds: 10_000_000)
        }
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        #expect(router.navigationHistory.count <= 5)
    }
    
    @Test("Multiple dismiss calls are safe")
    @MainActor
    func multipleDismissCalls() {
        let router = Router<AppRoute>()
        
        router.dismissSheet()
        router.dismissFullScreen()
        router.dismissAll()
        router.dismissAll() // Double dismiss
        
        // Should not crash
        #expect(router.sheet == nil)
        #expect(router.fullScreenCover == nil)
    }
}

// MARK: - Navigation Event Tests

@Suite("Navigation Event Tests")
struct NavigationEventTests {
    
    @Test("NavigationEvent stores route correctly")
    func eventStoresRoute() {
        let event = NavigationEvent(
            route: AppRoute.home,
            type: .push,
            timestamp: Date()
        )
        
        #expect(event.route == AppRoute.home)
        #expect(event.type == .push)
    }
    
    @Test("NavigationEvent can be nil route")
    func eventWithNilRoute() {
        let event = NavigationEvent<AppRoute>(
            route: nil,
            type: .pop,
            timestamp: Date()
        )
        
        #expect(event.route == nil)
        #expect(event.type == .pop)
    }
}

// MARK: - Test Helper Routes

enum AppRoute: Routable {
    case home
    case profile(userId: String)
    case settings
    
    var id: String {
        switch self {
        case .home: return "home"
        case .profile(let userId): return "profile_\(userId)"
        case .settings: return "settings"
        }
    }
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home:
            Text("Home")
        case .profile(let userId):
            Text("Profile: \(userId)")
        case .settings:
            Text("Settings")
        }
    }
}
