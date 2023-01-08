//
//  AsyncClient.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

import Foundation

/// The protocol defining the basic async API client
@available(macOS 10.15.0, *)
@available(iOS 13.0, *)
public protocol AsyncClient: BaseClient {

    /// Make an async API request.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(
        request: Request,
        body: Request.Body,
        headers: Request.Headers
    ) async -> Result<Response<Request.Response>, Error>
}


@available(macOS 10.15.0, *)
@available(iOS 13.0, *)
public extension AsyncClient {
    func make<Request: RequestProtocol>(
        request: Request,
        body: Request.Body,
        headers: Request.Headers
    ) async -> Result<Response<Request.Response>, Error> {
        do {
            let request = try self.createURLRequest(endpoint: request, body: body, headers: headers)
            let (data, response) = try await self.session.data(for: request)
            let result = try decoder.decode(Request.Response.self, from: data)

            return .success(.init(data: result, meta: .init(from: response)))
        } catch {
            return .failure(error)
        }
    }
}

@available(macOS 10.15.0, *)
@available(iOS 13.0, *)
public extension AsyncClient {
    
    /// Make an async API request when there's no request body (Body == ``Nothing``).
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request, headers: Request.Headers) async -> Result<Response<Request.Response>, Error> where Request.Body == Nothing {
        return await make(request: request, body: .init(), headers: headers)
    }

    
    /// Make an async API request when there's no request headers (Headers == ``Nothing``).
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request, body: Request.Body) async -> Result<Response<Request.Response>, Error> where Request.Headers == Nothing {
        return await self.make(request: request, body: body, headers: .init())
    }

    
    /// Make an async API request when there's no request body or headers (Body == ``Nothing`` and Headers == ``Nothing``).
    /// - Parameter request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request) async -> Result<Response<Request.Response>, Error> where Request.Body == Nothing, Request.Headers == Nothing {
        return await self.make(request: request, body: .init(), headers: .init())
    }
    
    
    /// Make an async API request with no HTTP headers.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request, body: Request.Body) async -> Result<Response<Request.Response>, Error> where Request.Headers == [String: String] {
        return await self.make(request: request, body: body, headers: [:])
    }
    
    /// Make an async API request with no HTTP headers when there's no request body (Body == ``Nothing``).
    /// - Parameter request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request) async -> Result<Response<Request.Response>, Error> where Request.Body == Nothing, Request.Headers == [String: String] {
        return await self.make(request: request, body: .init(), headers: [:])
    }
}
