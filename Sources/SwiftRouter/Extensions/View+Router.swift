//
//  View+Router.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import SwiftUI

public extension View {
    
    /// Inject router into environment
    func withRouter<Route: Routable>(_ router: Router<Route>) -> some View {
        self.environmentObject(router)
    }
    
    /// Automatic screen appearance tracking
    func trackScreenView<Route: Routable>(
        _ route: Route,
        analytics: @escaping (String) -> Void
    ) -> some View {
        self.onAppear {
            analytics("screen_view_\(route)")
        }
    }
    
    /// Processing the swipe back gesture
    func onSwipeBack(perform action: @escaping () -> Void) -> some View {
        self.gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 100 {
                        action()
                    }
                }
        )
    }
}
