//
//  UniversalLinkParser.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

/// Parser for Universal Links (https://domain.com/...)
public struct UniversalLinkParser<Route: Routable>: DeepLinkParser {
    private let host: String
    private let routeBuilder: (String, [String: String]?) -> [Route]?
    
    public init(
        host: String,
        routeBuilder: @escaping (String, [String: String]?) -> [Route]?
    ) {
        self.host = host
        self.routeBuilder = routeBuilder
    }
    
    public func canHandle(_ url: URL) -> Bool {
        url.scheme == "https" && url.host == host
    }
    
    public func parse(_ url: URL) -> [Route]? {
        let path = url.path
        let params = url.queryParameters
        return routeBuilder(path, params)
    }
}
