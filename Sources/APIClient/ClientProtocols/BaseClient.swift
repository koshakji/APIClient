//
//  BaseClient.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

import Foundation


/// The protocol defining the base of an API client.
public protocol BaseClient {
    
    /// Encoder type.
    associatedtype Encoder: EncoderProtocol where Encoder.Output == Data
    
    /// Decoder type.
    associatedtype Decoder: DecoderProtocol where Decoder.Input == Data
    
    
    /// Encoder used for encoding HTTP request body into `Data`.
    var encoder: Encoder { get }
    
    /// Decoder used for decoding HTTP responses into objects.
    var decoder: Decoder { get }
    
    /// URLSession used to make all requests.
    var session: URLSession { get }
    
    
    /// Creates a `URLRequest` from an endpoint, body and headers
    /// - Parameters:
    ///   - endpoint: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    /// - Returns: The `URLRequest` used to make the actual request.
    func createURLRequest<Request: RequestProtocol>(endpoint: Request, body: Request.Body, headers: Request.Headers) throws -> URLRequest
    
    
    /// Request customization point.
    /// - Parameter request: final object that will be used to make the request.
    /// Adding standard headers could be handled here.
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

