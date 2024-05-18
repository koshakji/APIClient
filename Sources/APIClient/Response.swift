//
//  Response.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

import Foundation

public protocol LocalizedErrorResponse {
    var localizedDescription: String { get }
}

public struct APIClientError<T>: Error {
    public let responseData: T?
    public let responseMeta: ResponseMetadata?
    public let underlyingError: Error
}
extension APIClientError {
    public var localizedDescription: String {
        if let responseData = responseData as? LocalizedErrorResponse {
            return responseData.localizedDescription
        } else {
            return underlyingError.localizedDescription
        }
    }
}


public struct Response<Response: Decodable> {
    public let data: Response
    public let meta: ResponseMetadata?
}

public struct ResponseMetadata {
    public let statusCode: Int
    public let headers: [AnyHashable: Any]
    
    public init(statusCode: Int, headers: [AnyHashable: Any]) {
        self.statusCode = statusCode
        self.headers = headers
    }
    
    public init?(from urlResponse: URLResponse) {
        guard let urlResponse = urlResponse as? HTTPURLResponse else { return nil }
        self.init(statusCode: urlResponse.statusCode, headers: urlResponse.allHeaderFields)
    }
}
