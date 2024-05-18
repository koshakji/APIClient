//
//  Response.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

import Foundation

public struct APIClientError<T>: Error {
    public let responseData: T?
    public let responseMeta: ResponseMetadata?
    public let underlyingError: Error
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
