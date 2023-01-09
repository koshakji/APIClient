//
//  CombineClient.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

import Foundation
import Combine

@available(macOS 10.15.0, *)
@available(iOS 13.0, *)
public protocol CombineClient: BaseClient {
    func publisher<Request: RequestProtocol>(
        request: Request,
        body: Request.Body,
        headers: Request.Headers,
        queries: Request.Queries
    ) -> AnyPublisher<Response<Request.Response>, Error>
}


@available(macOS 10.15.0, *)
@available(iOS 13.0, *)
public extension CombineClient {
    func publisher<Request: RequestProtocol>(
        request: Request,
        body: Request.Body,
        headers: Request.Headers,
        queries: Request.Queries
    ) -> AnyPublisher<Response<Request.Response>, Error> {
        do {
            let request = try self.createURLRequest(endpoint: request, body: body, headers: headers, queries: queries)
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
    ///  Make a Combine-based API request when headers is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - queries: The request URL queries, must match the queries type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request, body: Request.Body, queries: Request.Queries) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Headers == Nothing {
        return publisher(request: request, body: body, headers: .init(), queries: queries)
    }
    
    ///  Make a Combine-based API request when headers is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - queries: The request URL queries, must match the queries type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request, body: Request.Body, queries: Request.Queries) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Headers == Dictionary<String, String> {
        return publisher(request: request, body: body, headers: .init(), queries: queries)
    }
    
    ///  Make a Combine-based API request when headers is `Optional<H>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - queries: The request URL queries, must match the queries type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol, H>(request: Request, body: Request.Body, queries: Request.Queries) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Headers == Optional<H> {
        return publisher(request: request, body: body, headers: nil, queries: queries)
    }
    
    ///  Make a Combine-based API request when queries is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request, body: Request.Body, headers: Request.Headers) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Queries == Nothing {
        return publisher(request: request, body: body, headers: headers, queries: .init())
    }
    
    ///  Make a Combine-based API request when headers is `Nothing`, queries is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request, body: Request.Body) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Headers == Nothing, Request.Queries == Nothing {
        return publisher(request: request, body: body, headers: .init(), queries: .init())
    }
    
    ///  Make a Combine-based API request when headers is `Dictionary<String, String>`, queries is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request, body: Request.Body) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Headers == Dictionary<String, String>, Request.Queries == Nothing {
        return publisher(request: request, body: body, headers: .init(), queries: .init())
    }
    
    ///  Make a Combine-based API request when headers is `Optional<H>`, queries is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol, H>(request: Request, body: Request.Body) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Headers == Optional<H>, Request.Queries == Nothing {
        return publisher(request: request, body: body, headers: nil, queries: .init())
    }
    
    ///  Make a Combine-based API request when queries is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request, body: Request.Body, headers: Request.Headers) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Queries == Dictionary<String, String> {
        return publisher(request: request, body: body, headers: headers, queries: .init())
    }
    
    ///  Make a Combine-based API request when headers is `Nothing`, queries is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request, body: Request.Body) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Headers == Nothing, Request.Queries == Dictionary<String, String> {
        return publisher(request: request, body: body, headers: .init(), queries: .init())
    }
    
    ///  Make a Combine-based API request when headers is `Dictionary<String, String>`, queries is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request, body: Request.Body) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Headers == Dictionary<String, String>, Request.Queries == Dictionary<String, String> {
        return publisher(request: request, body: body, headers: .init(), queries: .init())
    }
    
    ///  Make a Combine-based API request when headers is `Optional<H>`, queries is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol, H>(request: Request, body: Request.Body) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Headers == Optional<H>, Request.Queries == Dictionary<String, String> {
        return publisher(request: request, body: body, headers: nil, queries: .init())
    }
    
    ///  Make a Combine-based API request when queries is `Optional<Q>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol, Q>(request: Request, body: Request.Body, headers: Request.Headers) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Queries == Optional<Q> {
        return publisher(request: request, body: body, headers: headers, queries: nil)
    }
    
    ///  Make a Combine-based API request when headers is `Nothing`, queries is `Optional<Q>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol, Q>(request: Request, body: Request.Body) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Headers == Nothing, Request.Queries == Optional<Q> {
        return publisher(request: request, body: body, headers: .init(), queries: nil)
    }
    
    ///  Make a Combine-based API request when headers is `Dictionary<String, String>`, queries is `Optional<Q>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol, Q>(request: Request, body: Request.Body) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Headers == Dictionary<String, String>, Request.Queries == Optional<Q> {
        return publisher(request: request, body: body, headers: .init(), queries: nil)
    }
    
    ///  Make a Combine-based API request when headers is `Optional<H>`, queries is `Optional<Q>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol, H, Q>(request: Request, body: Request.Body) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Headers == Optional<H>, Request.Queries == Optional<Q> {
        return publisher(request: request, body: body, headers: nil, queries: nil)
    }
    
    ///  Make a Combine-based API request when body is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    ///   - queries: The request URL queries, must match the queries type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request, headers: Request.Headers, queries: Request.Queries) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Body == Nothing {
        return publisher(request: request, body: .init(), headers: headers, queries: queries)
    }
    
    ///  Make a Combine-based API request when body is `Nothing`, headers is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - queries: The request URL queries, must match the queries type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request, queries: Request.Queries) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Body == Nothing, Request.Headers == Nothing {
        return publisher(request: request, body: .init(), headers: .init(), queries: queries)
    }
    
    ///  Make a Combine-based API request when body is `Nothing`, headers is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - queries: The request URL queries, must match the queries type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request, queries: Request.Queries) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Body == Nothing, Request.Headers == Dictionary<String, String> {
        return publisher(request: request, body: .init(), headers: .init(), queries: queries)
    }
    
    ///  Make a Combine-based API request when body is `Nothing`, headers is `Optional<H>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - queries: The request URL queries, must match the queries type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol, H>(request: Request, queries: Request.Queries) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Body == Nothing, Request.Headers == Optional<H> {
        return publisher(request: request, body: .init(), headers: nil, queries: queries)
    }
    
    ///  Make a Combine-based API request when body is `Nothing`, queries is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request, headers: Request.Headers) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Body == Nothing, Request.Queries == Nothing {
        return publisher(request: request, body: .init(), headers: headers, queries: .init())
    }
    
    ///  Make a Combine-based API request when body is `Nothing`, headers is `Nothing`, queries is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Body == Nothing, Request.Headers == Nothing, Request.Queries == Nothing {
        return publisher(request: request, body: .init(), headers: .init(), queries: .init())
    }
    
    ///  Make a Combine-based API request when body is `Nothing`, headers is `Dictionary<String, String>`, queries is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Body == Nothing, Request.Headers == Dictionary<String, String>, Request.Queries == Nothing {
        return publisher(request: request, body: .init(), headers: .init(), queries: .init())
    }
    
    ///  Make a Combine-based API request when body is `Nothing`, headers is `Optional<H>`, queries is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol, H>(request: Request) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Body == Nothing, Request.Headers == Optional<H>, Request.Queries == Nothing {
        return publisher(request: request, body: .init(), headers: nil, queries: .init())
    }
    
    ///  Make a Combine-based API request when body is `Nothing`, queries is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request, headers: Request.Headers) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Body == Nothing, Request.Queries == Dictionary<String, String> {
        return publisher(request: request, body: .init(), headers: headers, queries: .init())
    }
    
    ///  Make a Combine-based API request when body is `Nothing`, headers is `Nothing`, queries is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Body == Nothing, Request.Headers == Nothing, Request.Queries == Dictionary<String, String> {
        return publisher(request: request, body: .init(), headers: .init(), queries: .init())
    }
    
    ///  Make a Combine-based API request when body is `Nothing`, headers is `Dictionary<String, String>`, queries is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol>(request: Request) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Body == Nothing, Request.Headers == Dictionary<String, String>, Request.Queries == Dictionary<String, String> {
        return publisher(request: request, body: .init(), headers: .init(), queries: .init())
    }
    
    ///  Make a Combine-based API request when body is `Nothing`, headers is `Optional<H>`, queries is `Dictionary<String, String>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol, H>(request: Request) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Body == Nothing, Request.Headers == Optional<H>, Request.Queries == Dictionary<String, String> {
        return publisher(request: request, body: .init(), headers: nil, queries: .init())
    }
    
    ///  Make a Combine-based API request when body is `Nothing`, queries is `Optional<Q>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol, Q>(request: Request, headers: Request.Headers) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Body == Nothing, Request.Queries == Optional<Q> {
        return publisher(request: request, body: .init(), headers: headers, queries: nil)
    }
    
    ///  Make a Combine-based API request when body is `Nothing`, headers is `Nothing`, queries is `Optional<Q>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol, Q>(request: Request) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Body == Nothing, Request.Headers == Nothing, Request.Queries == Optional<Q> {
        return publisher(request: request, body: .init(), headers: .init(), queries: nil)
    }
    
    ///  Make a Combine-based API request when body is `Nothing`, headers is `Dictionary<String, String>`, queries is `Optional<Q>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol, Q>(request: Request) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Body == Nothing, Request.Headers == Dictionary<String, String>, Request.Queries == Optional<Q> {
        return publisher(request: request, body: .init(), headers: .init(), queries: nil)
    }
    
    ///  Make a Combine-based API request when body is `Nothing`, headers is `Optional<H>`, queries is `Optional<Q>`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    /// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.
    func publisher<Request: RequestProtocol, H, Q>(request: Request) -> AnyPublisher<Response<Request.Response>, Error> where  Request.Body == Nothing, Request.Headers == Optional<H>, Request.Queries == Optional<Q> {
        return publisher(request: request, body: .init(), headers: nil, queries: nil)
    }
    
}
