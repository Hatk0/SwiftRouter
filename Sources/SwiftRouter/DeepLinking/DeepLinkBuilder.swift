//
//  File.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

/// Builder for easy creation of deep link URLs
public struct DeepLinkBuilder {
    private let scheme: String
    private let host: String?
    
    public init(scheme: String, host: String? = nil) {
        self.scheme = scheme
        self.host = host
    }
    
    /// Building a URL
    public func build(
        path: String,
        queryParameters: [String: String]? = nil
    ) -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        if let params = queryParameters {
            components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return components.url
    }
}
