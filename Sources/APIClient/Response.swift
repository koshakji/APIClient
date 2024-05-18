//
//  Response.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

import Foundation

public struct APIClientError<ResponseError>: Error {
    public let responseData: ResponseError?
    public let responseMeta: ResponseMetadata?
    public let underlyingError: Error
}

extension APIClientError: LocalizedError where ResponseError: LocalizedError {
    public var errorDescription: String? { self.responseData?.errorDescription }
    public var failureReason: String? { self.responseData?.failureReason }
    public var recoverySuggestion: String? { self.responseData?.recoverySuggestion }
    public var helpAnchor: String? { self.responseData?.helpAnchor }
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
