//
//  PathBasedParser.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

/// Advanced parser based on path patterns
public final class PathBasedParser<Route: Routable>: DeepLinkParser {
    
    private var routes: [PathPattern<Route>] = []
    private let scheme: String?
    private let host: String?
    
    public init(scheme: String? = nil, host: String? = nil) {
        self.scheme = scheme
        self.host = host
    }
    
    /// Path pattern registration
    public func register(
        _ pattern: String,
        builder: @escaping ([String: String]) -> [Route]?
    ) {
        routes.append(PathPattern(pattern: pattern, builder: builder))
    }
    
    public func canHandle(_ url: URL) -> Bool {
        if let scheme, url.scheme != scheme {
            return false
        }
        if let host, url.host != host {
            return false
        }
        return true
    }
    
    public func parse(_ url: URL) -> [Route]? {
        let path = url.path
        
        // Looking for the right pattern
        for routePattern in routes {
            if let params = routePattern.match(path: path) {
                // Combine with query parameters
                var allParams = params
                url.queryParameters?.forEach { allParams[$0.key] = $0.value }
                
                return routePattern.builder(allParams)
            }
        }
        
        return nil
    }
}

// MARK: - PathPattern helper

private struct PathPattern<Route: Routable> {
    let pattern: String
    let builder: ([String: String]) -> [Route]?
    
    /// Checking path pattern matching
    func match(path: String) -> [String: String]? {
        let patternComponents = pattern.split(separator: "/").map(String.init)
        let pathComponents = path.split(separator: "/").map(String.init)
        
        guard patternComponents.count == pathComponents.count else {
            return nil
        }
        
        var parameters: [String: String] = [:]
        
        for (patternPart, pathPart) in zip(patternComponents, pathComponents) {
            if patternPart.hasPrefix(":") {
                // This is a parameter
                let paramName = String(patternPart.dropFirst())
                parameters[paramName] = pathPart
            } else if patternPart != pathPart {
                // Does not match
                return nil
            }
        }
        
        return parameters
    }
}
