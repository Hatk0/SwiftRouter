//
//  DeepLinkCoordinator.swift
//  SwiftRouter
//
//  Created by Dmitry Yastrebov on 12.01.2026.
//

import SwiftUI

/// Coordinator for managing deep links
@MainActor
public final class DeepLinkCoordinator<Route: Routable> {
    
    private let router: Router<Route>
    private var parsers: [AnyDeepLinkParser<Route>] = []
    private var pendingDeepLink: URL?
    
    public init(router: Router<Route>) {
        self.router = router
    }
    
    /// Parser registration
    public func register<Parser: DeepLinkParser>(
        _ parser: Parser
    ) where Parser.Route == Route {
        parsers.append(AnyDeepLinkParser(parser))
    }
    
    /// Deep link processing
    /// - Parameter url: The URL to handle
    /// - Returns: True if handled successfully
    /// - Throws: `DeepLinkError` if parsing fails or no parser found
    @discardableResult
    public func handle(_ url: URL) throws -> Bool {
        // Looking for a suitable parser
        guard let parser = parsers.first(where: { $0.canHandle(url) }) else {
            throw DeepLinkError.noParserFound(url)
        }
        
        // Parsing URLs
        guard let routes = parser.parse(url) else {
            throw DeepLinkError.parsingFailed(url)
        }
        
        // Navigation
        navigate(to: routes)
        return true
    }
    
    /// Deferred processing (if the application is not yet ready)
    public func handleWhenReady(_ url: URL) {
        pendingDeepLink = url
    }
    
    /// Processing deferred deep links
    /// - Returns: True if processed successfully, false otherwise
    @discardableResult
    public func processPendingDeepLink() -> Bool {
        guard let url = pendingDeepLink else { return false }
        pendingDeepLink = nil
        return (try? handle(url)) ?? false
    }
    
    private func navigate(to routes: [Route]) {
        // Close all modal windows
        router.dismissAll()
        
        // Clear the stack
        router.popToRoot()
        
        // Navigating a new path
        for route in routes {
            switch route.presentationType {
            case .push, .replace:
                router.push(route)
            case .sheet:
                router.presentSheet(route)
            case .fullScreenCover:
                router.presentFullScreen(route)
            case .popover:
                router.presentPopover(route)
            case .custom:
                router.push(route)
            }
        }
    }
}

// MARK: - Type Erasure для DeepLinkParser

private struct AnyDeepLinkParser<Route: Routable> {
    private let _parse: (URL) -> [Route]?
    private let _canHandle: (URL) -> Bool
    
    init<Parser: DeepLinkParser>(_ parser: Parser) where Parser.Route == Route {
        _parse = parser.parse
        _canHandle = parser.canHandle
    }
    
    func parse(_ url: URL) -> [Route]? {
        _parse(url)
    }
    
    func canHandle(_ url: URL) -> Bool {
        _canHandle(url)
    }
}
