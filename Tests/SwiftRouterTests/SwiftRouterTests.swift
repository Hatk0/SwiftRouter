import XCTest
import SwiftUI
@testable import SwiftRouter

// MARK: - Interceptor Tests

@MainActor
final class InterceptorTests: XCTestCase {
    
    // Mock interceptor for testing
    struct MockInterceptor: NavigationInterceptor {
        let id = UUID()
        var shouldBlock: Bool
        
        func shouldNavigate<Route: Routable>(to route: Route, type: NavigationType) async -> Bool {
            return !shouldBlock
        }
    }
    
    func testInterceptorBlocksNavigation() async {
        let router = Router<AppRoute>()
        let blockingInterceptor = MockInterceptor(shouldBlock: true)
        
        router.addInterceptor(blockingInterceptor)
        router.push(.home)
        
        // Wait for async navigation
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(router.path.count, 0) // Navigation should be blocked
    }
    
    func testInterceptorAllowsNavigation() async {
        let router = Router<AppRoute>()
        let allowingInterceptor = MockInterceptor(shouldBlock: false)
        
        router.addInterceptor(allowingInterceptor)
        router.push(.home)
        
        // Wait for async navigation
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(router.path.count, 1) // Navigation should succeed
    }
    
    func testClearAllInterceptors() async {
        let router = Router<AppRoute>()
        router.addInterceptor(MockInterceptor(shouldBlock: true))
        router.addInterceptor(MockInterceptor(shouldBlock: true))
        
        router.clearInterceptors()
        router.push(.home)
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(router.path.count, 1) // Should navigate (all interceptors cleared)
    }
}

// MARK: - Observer Tests

@MainActor
final class ObserverTests: XCTestCase {
    
    struct MockObserver: NavigationObserver {
        let id = UUID()
        
        func onNavigationEvent(_ event: NavigationObserverEvent) {
            // In real implementation, this would send events to analytics
        }
    }
    
    func testAddAndClearObservers() {
        let router = Router<AppRoute>()
        let observer = MockObserver()
        
        router.addObserver(observer)
        router.clearObservers()
        
        // Should not crash
        XCTAssertTrue(true)
    }
}

// MARK: - Edge Case Tests

@MainActor
final class EdgeCaseTests: XCTestCase {
    
    func testRapidNavigationAttempts() async {
        let router = Router<AppRoute>()
        
        // Simulate rapid button taps
        router.push(.home)
        router.push(.settings)
        router.push(.profile(userId: "123"))
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        // Should handle without crashing and have some navigation
        XCTAssertGreaterThanOrEqual(router.path.count, 1)
    }
    
    func testPopOnEmptyStack() {
        let router = Router<AppRoute>()
        
        router.pop() // Should not crash
        
        XCTAssertTrue(router.path.isEmpty)
    }
    
    func testPopToRootOnEmptyStack() {
        let router = Router<AppRoute>()
        
        router.popToRoot() // Should not crash
        
        XCTAssertTrue(router.path.isEmpty)
    }
    
    func testNavigationHistoryMaxSize() async {
        let router = Router<AppRoute>(maxHistorySize: 5)
        
        // Add more than max
        for _ in 0..<10 {
            router.push(.home)
            try? await Task.sleep(nanoseconds: 10_000_000)
        }
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        XCTAssertLessThanOrEqual(router.navigationHistory.count, 5)
    }
    
    func testMultipleDismissCalls() {
        let router = Router<AppRoute>()
        
        router.dismissSheet()
        router.dismissFullScreen()
        router.dismissAll()
        router.dismissAll() // Double dismiss
        
        // Should not crash
        XCTAssertNil(router.sheet)
        XCTAssertNil(router.fullScreenCover)
    }
}

// MARK: - Navigation Event Tests

final class NavigationEventTests: XCTestCase {
    
    func testEventStoresRoute() {
        let event = NavigationEvent(
            route: AppRoute.home,
            type: .push,
            timestamp: Date()
        )
        
        XCTAssertEqual(event.route, AppRoute.home)
        XCTAssertEqual(event.type, .push)
    }
    
    func testEventWithNilRoute() {
        let event = NavigationEvent<AppRoute>(
            route: nil,
            type: .pop,
            timestamp: Date()
        )
        
        XCTAssertNil(event.route)
        XCTAssertEqual(event.type, .pop)
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
