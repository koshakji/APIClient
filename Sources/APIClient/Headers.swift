//
//  Headers.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

import Foundation

public protocol StringDictionaryConvertible {
    func dictionary() -> [String: String]
}

public struct Nothing: Codable {}

extension Nothing: StringDictionaryConvertible {
    public func dictionary() -> [String : String] { [:] }
}

extension Dictionary: StringDictionaryConvertible where Key == String, Value == String {
    public func dictionary() -> [String : String] { return self }
}

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
