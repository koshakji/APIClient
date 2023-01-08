//
//  Group.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

import Foundation


/// Request group.
public protocol GroupProtocol {

    /// Scheme for all requests/subgroups generated from this group.
    /// - Example: http, https
    var scheme: String { get }
    
    /// Hostname for all requests/subgroups generated from this group.
    /// - Example: github.com
    var host: String { get }
    
    /// Port for all requests/subgroups generated from this group.
    /// - Example: 80
    var port: Int? { get }
    
    /// Base path for all requests/subgroups generated from this group.
    /// - Example: koshakji/
    var path: String { get }
}

public extension GroupProtocol {
    
    /// Get a request from the group.
    /// - Parameters:
    ///   - path: Relative path (appended to the group path)
    ///   - method: Request HTTP method.
    ///   - queries: Request URL query parameters.
    /// - Returns: A request definition instance.
    func endpoint<Body, Headers, Queries, Response>(path: String, method: HTTPMethod = .get, queries: Queries? = nil) -> AdvancedRequest<Body, Headers, Queries, Response> {
        .init(scheme: self.scheme, host: self.host, port: self.port, path: self.path + path, method: method, queries: queries)
    }
    
    /// Get a request from the group with no URL query parameters.
    /// - Parameters:
    ///   - path: Relative path (appended to the group path)
    ///   - method: Request HTTP method.
    /// - Returns: A request definition instance.
    func endpoint<Body, Headers, Response>(path: String, method: HTTPMethod = .get) -> AdvancedRequest<Body, Headers, [String: String], Response> {
        .init(scheme: self.scheme, host: self.host, port: self.port, path: self.path + path, method: method, queries: [:])
    }
    
    
    /// Get a request from the group when there's no URL query parameters (Query == ``Nothing``)
    /// - Parameters:
    ///   - path: Relative path (appended to the group path)
    ///   - method: Request HTTP method.
    /// - Returns: A request definition instance.
    func endpoint<Body, Headers, Response>(path: String, method: HTTPMethod = .get) -> AdvancedRequest<Body, Headers, Nothing, Response> {
        .init(scheme: self.scheme, host: self.host, port: self.port, path: self.path + path, method: method)
    }
    
    
    /// Create a subgroup.
    /// - Parameter path: Relative path (appended to the original group path).
    /// - Returns: New group with all the same details except the new, more detailed path.
    func subgroup(path: String) -> GroupProtocol {
        Group(scheme: self.scheme, host: self.host, port: self.port, path: self.path + path)
    }
}


/// Default Implementation of ``GroupProtocol``
public struct Group: GroupProtocol {
    public let scheme: String
    public let host: String
    public let port: Int?
    public let path: String
    
    public init(scheme: String = "https", host: String, port: Int? = nil, path: String) {
        self.scheme = scheme
        self.host = host
        self.port = port
        self.path = path
    }
}
