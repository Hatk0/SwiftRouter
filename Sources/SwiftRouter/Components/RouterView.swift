//
//  RouterView.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import SwiftUI

/// Main component for working with router
public struct RouterView<Route: Routable, Content: View>: View {
    @ObservedObject private var router: Router<Route>
    @Environment(\.dismiss) private var dismiss
    private let content: (Router<Route>) -> Content
    
    public init(
        router: Router<Route>,
        @ViewBuilder content: @escaping (Router<Route>) -> Content
    ) {
        self.router = router
        self.content = content
    }
    
    public var body: some View {
        content(router)
            .onAppear { router.dismissAction = { dismiss() } }
            .environmentObject(router)
            .sheet(item: $router.sheet) { route in
                route.view()
                    .environmentObject(router)
            }
            #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
            .fullScreenCover(item: $router.fullScreenCover) { route in
                route.view()
                    .environmentObject(router)
            }
            #endif
            .popover(item: $router.popover) { route in
                route.view()
                    .environmentObject(router)
            }
    }
}
