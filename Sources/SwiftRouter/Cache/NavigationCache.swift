//
//  NavigationCache.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import SwiftUI

/// View caching for fast navigation
public actor NavigationCache<Route: Routable> {
    
    private var cache: [String: AnyView] = [:]
    private let maxCacheSize: Int
    private var accessOrder: [String] = []
    
    public init(maxCacheSize: Int = 10) {
        self.maxCacheSize = maxCacheSize
    }
    
    /// Getting a cached view
    public func get(_ route: Route) -> AnyView? {
        let key = "\(route)"
        
        // Updating the access order (LRU)
        if let index = accessOrder.firstIndex(of: key) {
            accessOrder.remove(at: index)
            accessOrder.append(key)
        }
        
        return cache[key]
    }
    
    /// Caching the view
    public func set(_ route: Route, view: AnyView) {
        let key = "\(route)"
        
        // Checking the cache limit
        if cache.count >= maxCacheSize, !cache.keys.contains(key) {
            // Remove the oldest element (LRU)
            if let oldest = accessOrder.first {
                cache.removeValue(forKey: oldest)
                accessOrder.removeFirst()
            }
        }
        
        cache[key] = view
        accessOrder.append(key)
    }
    
    /// Clearing the cache
    public func clear() {
        cache.removeAll()
        accessOrder.removeAll()
    }
}
