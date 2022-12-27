//
//  BaseClient.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

import Foundation

public protocol BaseClient {
    associatedtype Encoder: EncoderProtocol where Encoder.Output == Data
    associatedtype Decoder: DecoderProtocol where Decoder.Input == Data
    var encoder: Encoder { get }
    var decoder: Decoder { get }
    var session: URLSession { get }
    
    func createURLRequest<Request: RequestProtocol>(endpoint: Request, body: Request.Body, headers: Request.Headers) throws -> URLRequest
    
    func customize(request: inout URLRequest)
}


public extension BaseClient {
    func customize(request: inout URLRequest) {}
    
    func createURLRequest<Request: RequestProtocol>(endpoint: Request, body: Request.Body, headers: Request.Headers) throws -> URLRequest {
        guard let url = endpoint.createURL() else { throw URLError(.unsupportedURL) }
        var request = URLRequest(url: url)
        endpoint.prepare(request: &request, with: headers)
        self.customize(request: &request)
        if Request.Body.self != Nothing.self {
            request.httpBody = try encoder.encode(body)
        }
        return request
    }
}

