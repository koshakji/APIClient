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
    func publisher<Request: RequestProtocol>(request: Request, headers: Request.Headers, queries: Request.Queries) -> AnyPublisher<Response<Request.Response>, Error> where Request.Body == Nothing {
        return self.publisher(request: request, body: .init(), headers: headers, queries: queries)
    }
    
    func publisher<Request: RequestProtocol>(request: Request, body: Request.Body, queries: Request.Queries) -> AnyPublisher<Response<Request.Response>, Error> where Request.Headers == Nothing {
        return self.publisher(request: request, body: body, headers: .init(), queries: queries)
    }
    
    func publisher<Request: RequestProtocol>(request: Request, queries: Request.Queries) -> AnyPublisher<Response<Request.Response>, Error> where Request.Body == Nothing, Request.Headers == Nothing {
        return self.publisher(request: request, body: .init(), queries: queries)
    }
    
    func publisher<Request: RequestProtocol>(request: Request, body: Request.Body, queries: Request.Queries) -> AnyPublisher<Response<Request.Response>, Error> where Request.Headers == [String: String] {
        return self.publisher(request: request, body: body, headers: [:], queries: queries)
    }
    
    func publisher<Request: RequestProtocol>(request: Request, queries: Request.Queries) -> AnyPublisher<Response<Request.Response>, Error> where Request.Body == Nothing, Request.Headers == [String: String] {
        return self.publisher(request: request, body: .init(), queries: queries)
    }
}
