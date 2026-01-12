//
//  CustomNavigationTransitions.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import SwiftUI

/// Custom navigation transitions
public struct CustomNavigationTransitions {
    
    /// Slide from right to left
    public static var slideFromRight: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        )
    }
    
    /// Slide from bottom to top
    public static var slideFromBottom: AnyTransition {
        .move(edge: .bottom)
    }
    
    /// Fade
    public static var fade: AnyTransition {
        .opacity
    }
    
    /// Scale
    public static var scale: AnyTransition {
        .scale(scale: 0.8).combined(with: .opacity)
    }
}
