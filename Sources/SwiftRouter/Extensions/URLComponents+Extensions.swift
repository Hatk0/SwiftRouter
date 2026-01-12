//
//  URLComponents+Extensions.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

public extension URL {
    
    /// Extracting query parameters
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        return parameters
    }
    
    /// Extracting path components (excluding root "/")
    var pathComponentsArray: [String] {
        pathComponents.filter { $0 != "/" }
    }
}
