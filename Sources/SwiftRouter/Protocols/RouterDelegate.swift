//
//  RouterDelegate.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import SwiftUI

/// Delegate for custom router event handling
public protocol RouterDelegate: AnyObject {
    associatedtype Route: Routable
    
    /// Called before navigation
    func router(_ router: Router<Route>, willNavigateTo route: Route) -> Bool
    
    /// Called after navigation
    func router(_ router: Router<Route>, didNavigateTo route: Route)
    
    /// Called when a navigation error occurs
    func router(_ router: Router<Route>, didFailWith error: Error)
}

// Default implementations
public extension RouterDelegate {
    
    func router(_ router: Router<Route>, willNavigateTo route: Route) -> Bool { true }
    func router(_ router: Router<Route>, didNavigateTo route: Route) {}
    func router(_ router: Router<Route>, didFailWith error: Error) {}
}

/// Debug view for displaying navigation history
public struct RouterDebugView<Route: Routable>: View {
    @EnvironmentObject private var router: Router<Route>
    
    public init() {}
    
    public var body: some View {
        List {
            Section("Navigation Stack") {
                Text("Depth: \(router.path.count)")
            }
            
            Section("History") {
                ForEach(router.navigationHistory.reversed()) { event in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("\(event.type)")
                                .font(.headline)
                            Spacer()
                            Text(event.timestamp, style: .time)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        if let route = event.route {
                            Text(route)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Router Debug")
    }
}
