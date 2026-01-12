//
//  NavigationFlow.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import SwiftUI

/// A component that creates a new independent navigation flow.
///
/// Use this component inside modals (sheets, fullScreenCovers) when you need
/// a separate navigation stack that is independent of the parent router.
///
/// Example:
/// ```swift
/// enum AppRoute: Routable {
///     case home
///     case settings
///     case settingsDetail
///
///     @ViewBuilder
///     func view() -> some View {
///         switch self {
///         case .home:
///             HomeView()
///         case .settings:
///             // Starts a new navigation flow for settings
///             NavigationFlow<AppRoute> {
///                 SettingsView()
///             }
///         case .settingsDetail:
///             SettingsDetailView()
///         }
///     }
/// }
/// ```
public struct NavigationFlow<Route: Routable, Content: View>: View {
    @StateObject private var router: Router<Route>
    private let content: () -> Content
    
    public init(
        router: Router<Route> = Router(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        _router = StateObject(wrappedValue: router)
        self.content = content
    }
    
    public var body: some View {
        RouterView(router: router) { childRouter in
            RoutableNavigationStack {
                content()
            }
        }
    }
}
