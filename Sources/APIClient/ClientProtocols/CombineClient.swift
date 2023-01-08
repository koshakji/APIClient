//
//  CombineClient.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

import Foundation
import Combine

/// The protocol defining the basic Combine-based API client
@available(macOS 10.15.0, *)
@available(iOS 13.0, *)
public protocol CombineClient: BaseClient {
    
    /// Make a completion-based API request.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request, body: Request.Body, headers: Request.Headers) -> AnyPublisher<Response<Request.Response>, Error>
}


@available(macOS 10.15.0, *)
@available(iOS 13.0, *)
public extension CombineClient {
    func publisher<Request: RequestProtocol>(request: Request, body: Request.Body, headers: Request.Headers) -> AnyPublisher<Response<Request.Response>, Error> {
        do {
            let request = try self.createURLRequest(endpoint: request, body: body, headers: headers)
            return self.session.dataTaskPublisher(for: request)
                .tryMap { [decoder] r in
                    let decoded = try decoder.decode(Request.Response.self, from: r.data)
                    return Response(data: decoded, meta: .init(from: r.response))
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}

@available(macOS 10.15.0, *)
@available(iOS 13.0, *)
public extension CombineClient {
    
    /// Make a Combine-based API request when there's no request body (Body == ``Nothing``).
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request, headers: Request.Headers) -> AnyPublisher<Response<Request.Response>, Error> where Request.Body == Nothing {
        return self.publisher(request: request, body: .init(), headers: headers)
    }
    
    /// Make a Combine-based API request when there's no request headers (Headers == ``Nothing``).
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request, body: Request.Body) -> AnyPublisher<Response<Request.Response>, Error> where Request.Headers == Nothing {
        return self.publisher(request: request, body: body, headers: .init())
    }
    
    /// Make a Combine-based API request when there's no request body or headers (Body == ``Nothing`` and Headers == ``Nothing``).
    /// - Parameter request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request) -> AnyPublisher<Response<Request.Response>, Error> where Request.Body == Nothing, Request.Headers == Nothing {
        return self.publisher(request: request, body: .init())
    }
    
    
    /// Make a Combine-based API request with no HTTP headers.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request, body: Request.Body) -> AnyPublisher<Response<Request.Response>, Error> where Request.Headers == [String: String] {
        return self.publisher(request: request, body: body, headers: [:])
    }
    
    /// Make a Combine-based API request with no HTTP headers when there's no request body (Body == ``Nothing``).
    /// - Parameter request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request) -> AnyPublisher<Response<Request.Response>, Error> where Request.Body == Nothing, Request.Headers == [String: String] {
        return self.publisher(request: request, body: .init())
    }
}
