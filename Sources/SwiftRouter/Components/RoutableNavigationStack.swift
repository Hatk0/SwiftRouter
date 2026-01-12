//
//  RoutableNavigationStack.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import SwiftUI

/// NavigationStack with Routable support
public struct RoutableNavigationStack<Route: Routable, Root: View>: View {
    @EnvironmentObject private var router: Router<Route>
    private let root: Root
    
    public init(@ViewBuilder root: () -> Root) {
        self.root = root()
    }
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            root
                .navigationDestination(for: Route.self) { route in
                    route.view()
                }
        }
        .sheet(item: $router.sheet) { route in
            route.view()
        }
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        .fullScreenCover(item: $router.fullScreenCover) { route in
            route.view()
        }
        #endif
    }
}
