//
//  Routable.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import SwiftUI

/// Base protocol for all routes in the application
/// Inherits from Hashable to support NavigationPath
public protocol Routable: Hashable, Identifiable, Sendable {
    /// The View type that the route returns
    associatedtype Body: View
    
    /// Build the View for this route
    @ViewBuilder
    func view() -> Body
    
    /// Presentation type (push, sheet, fullScreen, etc.)
    var presentationType: PresentationType { get }
    
    /// Optional transition animatio
    var transition: AnyTransition? { get }
}

// MARK: - Default implementations

public extension Routable {
    
    var presentationType: PresentationType { .push }
    var transition: AnyTransition? { nil }
}
