//
//  CustomSchemeParser.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

/// Parser for Custom URL Schemes (myapp://...)
public struct CustomSchemeParser<Route: Routable>: DeepLinkParser {
    private let scheme: String
    private let routeBuilder: (String, String?, [String: String]?) -> [Route]?
    
    public init(
        scheme: String,
        routeBuilder: @escaping (String, String?, [String: String]?) -> [Route]?
    ) {
        self.scheme = scheme
        self.routeBuilder = routeBuilder
    }
    
    public func canHandle(_ url: URL) -> Bool {
        url.scheme == scheme
    }
    
    public func parse(_ url: URL) -> [Route]? {
        let host = url.host
        let path = url.path
        let params = url.queryParameters
        return routeBuilder(path, host, params)
    }
}
