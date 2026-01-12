//
//  RouterError.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import Foundation

/// Errors that can occur during routing operations
public enum RouterError: Error, LocalizedError {
    /// Navigation was blocked by an interceptor
    case navigationBlocked(reason: String)
    
    /// Invalid route configuration
    case invalidRoute(String)
    
    /// Navigation stack is in an invalid state
    case invalidState(String)
    
    public var errorDescription: String? {
        switch self {
        case .navigationBlocked(let reason):
            return "Navigation blocked: \(reason)"
        case .invalidRoute(let route):
            return "Invalid route: \(route)"
        case .invalidState(let state):
            return "Invalid navigation state: \(state)"
        }
    }
}

/// Errors that can occur during deep linking
public enum DeepLinkError: Error, LocalizedError {
    /// No parser found that can handle the URL
    case noParserFound(URL)
    
    /// URL parsing failed
    case parsingFailed(URL, reason: String? = nil)
    
    /// Navigation was cancelled by interceptor
    case navigationCancelled(URL)
    
    /// Invalid URL format
    case invalidURL(String)
    
    public var errorDescription: String? {
        switch self {
        case .noParserFound(let url):
            return "No parser found for URL: \(url)"
        case .parsingFailed(let url, let reason):
            if let reason = reason {
                return "Failed to parse URL: \(url). Reason: \(reason)"
            }
            return "Failed to parse URL: \(url)"
        case .navigationCancelled(let url):
            return "Navigation cancelled for URL: \(url)"
        case .invalidURL(let urlString):
            return "Invalid URL format: \(urlString)"
        }
    }
}
