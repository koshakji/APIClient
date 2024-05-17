//
//  AsyncClient.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

import Foundation

@available(macOS 10.15.0, *)
@available(iOS 13.0, *)
public protocol AsyncClient: BaseClient {
    func make<Request: RequestProtocol>(
        request: Request,
        body: Request.Body,
        headers: Request.Headers,
        queries: Request.Queries
    ) async throws -> Response<Request.Response> 
}


@available(macOS 10.15.0, *)
@available(iOS 13.0, *)
public extension AsyncClient {
    func make<Request: RequestProtocol>(
        request: Request,
        body: Request.Body,
        headers: Request.Headers,
        queries: Request.Queries
    ) async throws -> Response<Request.Response> {
        let request = try self.createURLRequest(endpoint: request, body: body, headers: headers, queries: queries)
        let (data, response) = try await self.session.data(for: request)
        let result = try decoder.decode(Request.Response.self, from: data)

        return .init(data: result, meta: .init(from: response))
    }
}

@available(macOS 10.15.0, *)
@available(iOS 13.0, *)
public extension AsyncClient {
    /// Make an async API request when headers is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - queries: The request URL queries, must match the queries type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, queries: Request.Queries) async throws -> Response<Request.Response> where Request.Headers == Nothing {
        return try await make(request: request, body: body, headers: .init(), queries: queries)
    }
    
    /// Make an async API request when headers is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - queries: The request URL queries, must match the queries type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, queries: Request.Queries) async throws -> Response<Request.Response> where Request.Headers == Dictionary<String, String> {
        return try await make(request: request, body: body, headers: .init(), queries: queries)
    }
    
    /// Make an async API request when headers is `Optional<H>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - queries: The request URL queries, must match the queries type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol, H>(request: Request, body: Request.Body, queries: Request.Queries) async throws -> Response<Request.Response> where Request.Headers == Optional<H> {
        return try await make(request: request, body: body, headers: nil, queries: queries)
    }
    
    /// Make an async API request when queries is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, headers: Request.Headers) async throws -> Response<Request.Response> where Request.Queries == Nothing {
        return try await make(request: request, body: body, headers: headers, queries: .init())
    }
    
    /// Make an async API request when headers is `Nothing`, queries is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request, body: Request.Body) async throws -> Response<Request.Response> where Request.Headers == Nothing, Request.Queries == Nothing {
        return try await make(request: request, body: body, headers: .init(), queries: .init())
    }
    
    /// Make an async API request when headers is `Dictionary<String, String>`, queries is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request, body: Request.Body) async throws -> Response<Request.Response> where Request.Headers == Dictionary<String, String>, Request.Queries == Nothing {
        return try await make(request: request, body: body, headers: .init(), queries: .init())
    }
    
    /// Make an async API request when headers is `Optional<H>`, queries is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol, H>(request: Request, body: Request.Body) async throws -> Response<Request.Response> where Request.Headers == Optional<H>, Request.Queries == Nothing {
        return try await make(request: request, body: body, headers: nil, queries: .init())
    }
    
    /// Make an async API request when queries is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, headers: Request.Headers) async throws -> Response<Request.Response> where Request.Queries == Dictionary<String, String> {
        return try await make(request: request, body: body, headers: headers, queries: .init())
    }
    
    /// Make an async API request when headers is `Nothing`, queries is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request, body: Request.Body) async throws -> Response<Request.Response> where Request.Headers == Nothing, Request.Queries == Dictionary<String, String> {
        return try await make(request: request, body: body, headers: .init(), queries: .init())
    }
    
    /// Make an async API request when headers is `Dictionary<String, String>`, queries is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request, body: Request.Body) async throws -> Response<Request.Response> where Request.Headers == Dictionary<String, String>, Request.Queries == Dictionary<String, String> {
        return try await make(request: request, body: body, headers: .init(), queries: .init())
    }
    
    /// Make an async API request when headers is `Optional<H>`, queries is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol, H>(request: Request, body: Request.Body) async throws -> Response<Request.Response> where Request.Headers == Optional<H>, Request.Queries == Dictionary<String, String> {
        return try await make(request: request, body: body, headers: nil, queries: .init())
    }
    
    /// Make an async API request when queries is `Optional<Q>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol, Q>(request: Request, body: Request.Body, headers: Request.Headers) async throws -> Response<Request.Response> where Request.Queries == Optional<Q> {
        return try await make(request: request, body: body, headers: headers, queries: nil)
    }
    
    /// Make an async API request when headers is `Nothing`, queries is `Optional<Q>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol, Q>(request: Request, body: Request.Body) async throws -> Response<Request.Response> where Request.Headers == Nothing, Request.Queries == Optional<Q> {
        return try await make(request: request, body: body, headers: .init(), queries: nil)
    }
    
    /// Make an async API request when headers is `Dictionary<String, String>`, queries is `Optional<Q>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol, Q>(request: Request, body: Request.Body) async throws -> Response<Request.Response> where Request.Headers == Dictionary<String, String>, Request.Queries == Optional<Q> {
        return try await make(request: request, body: body, headers: .init(), queries: nil)
    }
    
    /// Make an async API request when headers is `Optional<H>`, queries is `Optional<Q>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol, H, Q>(request: Request, body: Request.Body) async throws -> Response<Request.Response> where Request.Headers == Optional<H>, Request.Queries == Optional<Q> {
        return try await make(request: request, body: body, headers: nil, queries: nil)
    }
    
    /// Make an async API request when body is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    ///   - queries: The request URL queries, must match the queries type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request, headers: Request.Headers, queries: Request.Queries) async throws -> Response<Request.Response> where Request.Body == Nothing {
        return try await make(request: request, body: .init(), headers: headers, queries: queries)
    }
    
    /// Make an async API request when body is `Nothing`, headers is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - queries: The request URL queries, must match the queries type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request, queries: Request.Queries) async throws -> Response<Request.Response> where Request.Body == Nothing, Request.Headers == Nothing {
        return try await make(request: request, body: .init(), headers: .init(), queries: queries)
    }
    
    /// Make an async API request when body is `Nothing`, headers is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - queries: The request URL queries, must match the queries type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request, queries: Request.Queries) async throws -> Response<Request.Response> where Request.Body == Nothing, Request.Headers == Dictionary<String, String> {
        return try await make(request: request, body: .init(), headers: .init(), queries: queries)
    }
    
    /// Make an async API request when body is `Nothing`, headers is `Optional<H>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - queries: The request URL queries, must match the queries type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol, H>(request: Request, queries: Request.Queries) async throws -> Response<Request.Response> where Request.Body == Nothing, Request.Headers == Optional<H> {
        return try await make(request: request, body: .init(), headers: nil, queries: queries)
    }
    
    /// Make an async API request when body is `Nothing`, queries is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request, headers: Request.Headers) async throws -> Response<Request.Response> where Request.Body == Nothing, Request.Queries == Nothing {
        return try await make(request: request, body: .init(), headers: headers, queries: .init())
    }
    
    /// Make an async API request when body is `Nothing`, headers is `Nothing`, queries is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request) async throws -> Response<Request.Response> where Request.Body == Nothing, Request.Headers == Nothing, Request.Queries == Nothing {
        return try await make(request: request, body: .init(), headers: .init(), queries: .init())
    }
    
    /// Make an async API request when body is `Nothing`, headers is `Dictionary<String, String>`, queries is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request) async throws -> Response<Request.Response> where Request.Body == Nothing, Request.Headers == Dictionary<String, String>, Request.Queries == Nothing {
        return try await make(request: request, body: .init(), headers: .init(), queries: .init())
    }
    
    /// Make an async API request when body is `Nothing`, headers is `Optional<H>`, queries is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol, H>(request: Request) async throws -> Response<Request.Response> where Request.Body == Nothing, Request.Headers == Optional<H>, Request.Queries == Nothing {
        return try await make(request: request, body: .init(), headers: nil, queries: .init())
    }
    
    /// Make an async API request when body is `Nothing`, queries is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request, headers: Request.Headers) async throws -> Response<Request.Response> where Request.Body == Nothing, Request.Queries == Dictionary<String, String> {
        return try await make(request: request, body: .init(), headers: headers, queries: .init())
    }
    
    /// Make an async API request when body is `Nothing`, headers is `Nothing`, queries is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request) async throws -> Response<Request.Response> where Request.Body == Nothing, Request.Headers == Nothing, Request.Queries == Dictionary<String, String> {
        return try await make(request: request, body: .init(), headers: .init(), queries: .init())
    }
    
    /// Make an async API request when body is `Nothing`, headers is `Dictionary<String, String>`, queries is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol>(request: Request) async throws -> Response<Request.Response> where Request.Body == Nothing, Request.Headers == Dictionary<String, String>, Request.Queries == Dictionary<String, String> {
        return try await make(request: request, body: .init(), headers: .init(), queries: .init())
    }
    
    /// Make an async API request when body is `Nothing`, headers is `Optional<H>`, queries is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol, H>(request: Request) async throws -> Response<Request.Response> where Request.Body == Nothing, Request.Headers == Optional<H>, Request.Queries == Dictionary<String, String> {
        return try await make(request: request, body: .init(), headers: nil, queries: .init())
    }
    
    /// Make an async API request when body is `Nothing`, queries is `Optional<Q>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol, Q>(request: Request, headers: Request.Headers) async throws -> Response<Request.Response> where Request.Body == Nothing, Request.Queries == Optional<Q> {
        return try await make(request: request, body: .init(), headers: headers, queries: nil)
    }
    
    /// Make an async API request when body is `Nothing`, headers is `Nothing`, queries is `Optional<Q>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol, Q>(request: Request) async throws -> Response<Request.Response> where Request.Body == Nothing, Request.Headers == Nothing, Request.Queries == Optional<Q> {
        return try await make(request: request, body: .init(), headers: .init(), queries: nil)
    }
    
    /// Make an async API request when body is `Nothing`, headers is `Dictionary<String, String>`, queries is `Optional<Q>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol, Q>(request: Request) async throws -> Response<Request.Response> where Request.Body == Nothing, Request.Headers == Dictionary<String, String>, Request.Queries == Optional<Q> {
        return try await make(request: request, body: .init(), headers: .init(), queries: nil)
    }
    
    /// Make an async API request when body is `Nothing`, headers is `Optional<H>`, queries is `Optional<Q>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.
    func make<Request: RequestProtocol, H, Q>(request: Request) async throws -> Response<Request.Response> where Request.Body == Nothing, Request.Headers == Optional<H>, Request.Queries == Optional<Q> {
        return try await make(request: request, body: .init(), headers: nil, queries: nil)
    }
    
}
