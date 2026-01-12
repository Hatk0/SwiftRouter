import Testing
import SwiftUI
@testable import SwiftRouter

enum AppRoute: Routable {
    case home
    case profile(userId: String)
    case settings
    
    var id: String {
        switch self {
        case .home:
            return "home"
        case .profile(let userId):
            return "profile_\(userId)"
        case .settings:
            return "settings"
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

@Suite("Router Tests")
struct RouterTests {
    @Test("Push navigation adds route to path")
    @MainActor
    func pushNavigation() async {
        let router = Router<AppRoute>()
        router.push(.home)
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(router.path.count == 1)
    }
    
    @Test("Pop removes last route")
    @MainActor
    func popNavigation() async {
        let router = Router<AppRoute>()
        router.push(.home)
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        router.pop()
        #expect(router.path.isEmpty)
    }
    
    @Test(arguments: [
        AppRoute.home,
        AppRoute.settings,
        AppRoute.profile(userId: "123")
    ])
    @MainActor
    func testMultipleRoutes(route: AppRoute) async {
        let router = Router<AppRoute>()
        router.push(route)
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(router.path.count == 1)
    }
    
    @Test("PopToRoot clears entire navigation stack")
    @MainActor
    func popToRoot() async {
        let router = Router<AppRoute>()
        router.push(.home)
        router.push(.settings)
        router.push(.profile(userId: "456"))
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        router.popToRoot()
        #expect(router.path.isEmpty)
    }
    
    @Test("Sheet presentation sets sheet property")
    @MainActor
    func sheetPresentation() async {
        let router = Router<AppRoute>()
        router.presentSheet(.settings)
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(router.sheet != nil)
    }
    
    @Test("Dismiss sheet clears sheet property")
    @MainActor
    func dismissSheet() {
        let router = Router<AppRoute>()
        router.dismissSheet()
        #expect(router.sheet == nil)
    }
}
