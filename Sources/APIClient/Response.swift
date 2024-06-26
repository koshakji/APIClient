//
//  Response.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

import Foundation

public enum APIClientError<ResponseError>: Error {
    case responseError(ResponseError, meta: ResponseMetadata?, underlyingError: Error)
    case unexpectedResponseError(data: Data, meta: ResponseMetadata?, underlyingError: Error)
    case otherError(Error)
}

extension APIClientError: LocalizedError {
    private var localizedError: LocalizedError? {
        switch self {
        case .responseError(let response, _, _) where response is LocalizedError:
            return (response as? LocalizedError)
        case .otherError(let error) where error is LocalizedError,
            .responseError(_, _, underlyingError: let error) where error is LocalizedError,
            .unexpectedResponseError(_, _, underlyingError: let error) where error is LocalizedError:
            return (error as? LocalizedError)
        default:
            return nil
        }
    }
    
    public var underlyingError: Error {
        switch self {
        case .responseError(_, meta: _, underlyingError: let error),
                .unexpectedResponseError(data: _, meta: _, underlyingError: let error),
                .otherError(let error):
            return error
        }
    }
    
    public var errorDescription: String? {
        self.localizedError?.errorDescription ?? (underlyingError as? LocalizedError)?.errorDescription
    }
    public var failureReason: String? {
        self.localizedError?.failureReason ?? (underlyingError as? LocalizedError)?.failureReason
    }
    public var recoverySuggestion: String? {
        self.localizedError?.recoverySuggestion ?? (underlyingError as? LocalizedError)?.recoverySuggestion
    }
    public var helpAnchor: String? {
        self.localizedError?.helpAnchor ?? (underlyingError as? LocalizedError)?.helpAnchor
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
