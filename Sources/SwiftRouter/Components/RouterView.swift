//
//  RouterView.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import SwiftUI

/// Main component for working with router
public struct RouterView<Route: Routable, Content: View>: View {
    @StateObject private var router: Router<Route>
    private let content: (Router<Route>) -> Content
    
    public init(
        router: Router<Route> = Router(),
        @ViewBuilder content: @escaping (Router<Route>) -> Content
    ) {
        _router = StateObject(wrappedValue: router)
        self.content = content
    }
    
    public var body: some View {
        content(router)
            .environmentObject(router)
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
