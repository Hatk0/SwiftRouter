//
//  DeepLinkParser.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

/// Deep links parser
public protocol DeepLinkParser {
    associatedtype Route: Routable
    
    /// Parsing a URL into an array of routes
    func parse(_ url: URL) -> [Route]?
    
    /// Validating URLs before parsing
    func canHandle(_ url: URL) -> Bool
}

public extension DeepLinkParser {
    func canHandle(_ url: URL) -> Bool {
        true // By default, we process all URLs
    }
}
