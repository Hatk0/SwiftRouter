//
//  SwiftRouter.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

/// SwiftRouter - Type-safe navigation library for SwiftUI
///
/// A modern routing solution with support for:
/// - **Type-safe routing** with enum-based routes
/// - **Deep linking** with custom schemes and universal links
/// - **Navigation interceptors** for auth, confirmation, and validation
/// - **Event observers** for analytics and logging
/// - **Multi-platform support** (iOS, macOS, tvOS, watchOS, visionOS)
/// - **Swift 6 concurrency** with full Sendable conformance
///
/// ## Quick Start
///
/// ```swift
/// import SwiftRouter
///
/// enum AppRoute: Routable {
///     case home
///     case profile(userId: String)
///      
///     var id: String { /* ... */ }
///     func view() -> some View { /* ... */ }
/// }
///
/// let router = Router<AppRoute>()
/// router.push(.home)
/// ```
///
/// ## Key Components
///
/// - `Router<Route>` - Main navigation coordinator
/// - `Routable` - Protocol for defining routes
/// - `DeepLinkCoordinator` - Deep link handling
/// - `NavigationInterceptor` - Pre-navigation validation
/// - `NavigationObserver` - Post-navigation tracking
///
/// - Version: 1.0.0
/// - Author: Dmitry Yastrebov
/// - Copyright: © 2026 Dmitry Yastrebov. All rights reserved.

import Foundation
