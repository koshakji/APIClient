//
//  Headers.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

import Foundation

public typealias KeyValuePair<T> = (key: String, value: T)

public protocol StringKeyValueConvertible {
    func keyValues() -> [KeyValuePair<String>]
}

public struct Nothing: Codable {
    public init() {}
}

extension Nothing: StringKeyValueConvertible {
    public func keyValues() -> [KeyValuePair<String>] { [] }
}

extension Dictionary: StringKeyValueConvertible where Key == String, Value == String {
    public func keyValues() -> [KeyValuePair<String>] { return self.map { $0 } }
}

extension Optional: StringKeyValueConvertible where Wrapped: StringKeyValueConvertible {
    public func keyValues() -> [KeyValuePair<String>] {
        return self?.keyValues() ?? []
    }
}

public struct BearerHeaders<Others: StringKeyValueConvertible>: StringKeyValueConvertible {
    let token: String
    let otherHeaders: Others
    
    public init(token: String, otherHeaders: Others) {
        self.token = token
        self.otherHeaders = otherHeaders
    }
    
    public func keyValues() -> [KeyValuePair<String>] {
        self.otherHeaders.keyValues() + [("Authorization", "Bearer \(token)")]
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
