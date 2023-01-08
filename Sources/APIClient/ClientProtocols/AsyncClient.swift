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
    func make<Request: RequestProtocol>(request: Request, headers: Request.Headers) async -> Result<Response<Request.Response>, Error> where Request.Body == Nothing {
        return await make(request: request, body: .init(), headers: headers)
    }

    func make<Request: RequestProtocol>(request: Request, body: Request.Body) async -> Result<Response<Request.Response>, Error> where Request.Headers == Nothing {
        return await self.make(request: request, body: body, headers: .init())
    }

    func make<Request: RequestProtocol>(request: Request) async -> Result<Response<Request.Response>, Error> where Request.Body == Nothing, Request.Headers == Nothing {
        return await self.make(request: request, body: .init(), headers: .init())
    }
    
    func make<Request: RequestProtocol>(request: Request, body: Request.Body) async -> Result<Response<Request.Response>, Error> where Request.Headers == [String: String] {
        return await self.make(request: request, body: body, headers: [:])
    }
    
    func make<Request: RequestProtocol>(request: Request) async -> Result<Response<Request.Response>, Error> where Request.Body == Nothing, Request.Headers == [String: String] {
        return await self.make(request: request, body: .init(), headers: [:])
    }
}
