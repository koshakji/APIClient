//
//  APIClient.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

import Foundation

public struct APIClient: BaseClient {
    public let encoder: JSONEncoder
    public let decoder: JSONDecoder
    public let session: URLSession
    
    public init(
        encoder: JSONEncoder = .init(),
        decoder: JSONDecoder = .init(),
        session: URLSession = .shared
    ) {
        self.encoder = encoder
        self.decoder = decoder
        self.session = session
    }
    
    public func customize(request: inout URLRequest) {
        request.addValue("application/json", forHTTPHeaderField: "content-type")
    }
}

extension APIClient: CompletionClient, AsyncClient, CombineClient {}
