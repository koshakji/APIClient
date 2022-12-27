//
//  Group.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

import Foundation

public protocol GroupProtocol {
    var scheme: String { get }
    var host: String { get }
    var port: Int? { get }
    var path: String { get }
}

public extension GroupProtocol {
    func endpoint<Body, Headers, Queries, Response>(path: String, method: HTTPMethod = .get, queries: Queries) -> AdvancedRequest<Body, Headers, Queries, Response> {
        .init(scheme: self.scheme, host: self.host, port: self.port, path: self.path + path, method: method, queries: queries)
    }
    
    func endpoint<Body, Headers, Response>(path: String, method: HTTPMethod = .get) -> AdvancedRequest<Body, Headers, [String: String], Response> {
        .init(scheme: self.scheme, host: self.host, port: self.port, path: self.path + path, method: method, queries: [:])
    }
    
    func endpoint<Body, Headers, Response>(path: String, method: HTTPMethod = .get) -> AdvancedRequest<Body, Headers, Nothing, Response> {
        .init(scheme: self.scheme, host: self.host, port: self.port, path: self.path + path, method: method)
    }
    
    func subgroup(path: String) -> GroupProtocol {
        Group(scheme: self.scheme, host: self.host, port: self.port, path: self.path + path)
    }
}


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
