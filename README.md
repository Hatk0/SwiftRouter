# SwiftRouter

A modern, type-safe routing library for SwiftUI with support for deep linking, navigation interceptors, and event observers.

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20|%20macOS%20|%20tvOS%20|%20watchOS%20|%20visionOS-blue.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Features

✅ **Type-Safe Navigation** - Enum-based routes with compile-time safety  
✅ **Multi-Platform** - iOS 16+, macOS 13+, tvOS 16+, watchOS 9+, visionOS 1.0+  
✅ **Deep Linking** - Built-in support for custom schemes and universal links  
✅ **Navigation Interceptors** - Block or modify navigation flows (auth, confirmation, etc.)  
✅ **Event Observers** - Track navigation for analytics, logging, and debugging  
✅ **Swift 6 Concurrency** - Full Sendable conformance and strict concurrency  
✅ **Testability** - Includes `MockRouter` for easy testing

## Installation

### Swift Package Manager

Add SwiftRouter to your project via Xcode or Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/YourUsername/SwiftRouter.git", from: "1.0.0")
]
```

## Quick Start

### 1. Define Your Routes

```swift
import SwiftUI
import SwiftRouter

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
            HomeView()
        case .profile(let userId):
            ProfileView(userId: userId)
        case .settings:
            SettingsView()
        }
    }
}
```

### 2. Set Up Router

```swift
@main
struct MyApp: App {
    @StateObject private var router = Router<AppRoute>()
    
    var body: some Scene {
        WindowGroup {
            RouterView(router: router) { router in
                NavigationStack(path: $router.path) {
                    AppRoute.home.view()
                        .navigationDestination(for: AppRoute.self) { route in
                            route.view()
                        }
                }
                .sheet(item: $router.sheet) { route in
                    route.view()
                }
            }
        }
    }
}
```

### 3. Navigate

```swift
struct HomeView: View {
    @EnvironmentObject var router: Router<AppRoute>
    
    var body: some View {
        VStack {
            Button("Go to Profile") {
                router.push(.profile(userId: "123"))
            }
            
            Button("Open Settings") {
                router.presentSheet(.settings)
            }
        }
    }
}
```

## Advanced Usage

### Navigation Interceptors

Block navigation based on conditions (e.g., authentication):

```swift
let authInterceptor = AuthInterceptor(
    isAuthenticated: { AuthService.shared.isLoggedIn },
    protectedRoutes: ["profile", "settings"]
)

router.addInterceptor(authInterceptor)
```

### Event Observers

Track navigation for analytics:

```swift
let analyticsObserver = AnalyticsObserver { eventName, params in
    Analytics.log(eventName, parameters: params)
}

router.addObserver(analyticsObserver)
```

### Deep Linking

```swift
let coordinator = DeepLinkCoordinator(router: router)

// Register parsers
coordinator.register(UniversalLinkParser())
coordinator.register(CustomSchemeParser())

// Handle deep link
if let url = URL(string: "myapp://profile/123") {
    try? coordinator.handle(url)
}
```

### Custom Navigation Transitions

```swift
enum AppRoute: Routable {
    case profile(userId: String)
    
    var transition: AnyTransition? {
        switch self {
        case .profile:
            return CustomNavigationTransitions.slideFromRight
        }
    }
}
```

## Testing

SwiftRouter includes `MockRouter` for easy testing:

```swift
@MainActor
func testNavigation() async {
    let router = MockRouter<AppRoute>()
    
    router.push(.home)
    
    #expect(router.pushedRoutes.contains(.home))
    #expect(router.lastPushedRoute == .home)
}
```

## API Overview

### Router Methods

- `push(_ route:)` - Push route onto navigation stack
- `pop()` - Pop topmost route
- `popToRoot()` - Pop all routes to root
- `pop(count:)` - Pop N routes
- `presentSheet(_ route:)` - Present route as sheet
- `dismissSheet()` - Dismiss current sheet
- `presentFullScreen(_ route:)` - Present fullscreen cover (not available on macOS)
- `dismissFullScreen()` - Dismiss fullscreen cover
- `presentPopover(_ route:)` - Present popover (iPad)
- `dismissPopover()` - Dismiss popover
- `dismissAll()` - Dismiss all modals

### Interceptor Management

- `addInterceptor(_ interceptor:)` - Add navigation interceptor
- `removeInterceptor(withId:)` - Remove specific interceptor
- `clearInterceptors()` - Remove all interceptors

### Observer Management

- `addObserver(_ observer:)` - Add navigation observer  
- `removeObserver(withId:)` - Remove specific observer
- `clearObservers()` - Remove all observers

## Migration from Swift 5

SwiftRouter uses Swift 6 strict concurrency. Update your routes:

```swift
// ✅ Swift 6 - Add Sendable, Identifiable
enum AppRoute: Routable, Identifiable, Sendable {
    var id: String { /* ... */ }
}
```

## Requirements

- Swift 6.0+
- iOS 16.0+ / macOS 13.0+ / tvOS 16.0+ / watchOS 9.0+ / visionOS 1.0+

## License

SwiftRouter is released under the MIT license. See LICENSE for details.

## Author

Dmitry Yastrebov

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.
