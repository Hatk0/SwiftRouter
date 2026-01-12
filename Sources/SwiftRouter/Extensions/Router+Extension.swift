//
//  Router+Extension.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

public extension Router {
    
    /// Processing deep links directly through the router
    func handleDeepLink(_ url: URL, using coordinator: DeepLinkCoordinator<Route>) {
        coordinator.handle(url)
    }
}
