//
//  Response.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

import Foundation

/// Response container wrapping the actual request response type and ``ResponseMetadata``
public struct Response<Response: Decodable> {
    public let data: Response
    public let meta: ResponseMetadata?
}


/// HTTP Response metadata
public struct ResponseMetadata {
    let statusCode: Int
    let headers: [AnyHashable: Any]
    
    public init(statusCode: Int, headers: [AnyHashable: Any]) {
        self.statusCode = statusCode
        self.headers = headers
    }
    
    public init?(from urlResponse: URLResponse) {
        guard let urlResponse = urlResponse as? HTTPURLResponse else { return nil }
        self.init(statusCode: urlResponse.statusCode, headers: urlResponse.allHeaderFields)
    }
}
