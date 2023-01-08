//
//  Headers.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

import Foundation

/// Protocol that defines a type that could be convertible to dictionary of strings
public protocol StringDictionaryConvertible {
    func dictionary() -> [String: String]
}


/// Empty type that conforms to `Codable` and ``StringDictionaryConvertible``
public struct Nothing: Codable {}

extension Nothing: StringDictionaryConvertible {
    public func dictionary() -> [String : String] { [:] }
}

extension Dictionary: StringDictionaryConvertible where Key == String, Value == String {
    public func dictionary() -> [String : String] { return self }
}

/// Headers with Bearer token authentication
public struct BearerHeaders<Others: StringDictionaryConvertible>: StringDictionaryConvertible {
    let token: String
    let otherHeaders: Others
    
    public init(token: String, otherHeaders: Others) {
        self.token = token
        self.otherHeaders = otherHeaders
    }
    
    public func dictionary() -> [String : String] {
        var headers = self.otherHeaders.dictionary()
        headers["Authentication"] = "Bearer \(token)"
        return headers
    }
}

public extension BearerHeaders where Others == Nothing {
    init(token: String) {
        self.init(token: token, otherHeaders: .init())
    }
}

public extension BearerHeaders where Others == [String: String] {
    init(token: String) {
        self.init(token: token, otherHeaders: [:])
    }
}
