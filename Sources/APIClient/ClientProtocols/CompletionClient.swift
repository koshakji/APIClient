//
//  CompletionClient.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

/// The protocol defining the basic completion-based API client
public protocol CompletionClient: BaseClient {
    /// Completion handler closure type
    ///
    /// Takes a successful response (including HTTP headers, status and decoded response) or a failure with an error
    typealias Completion<Request: RequestProtocol> = (Result<Response<Request.Response>, Error>) -> Void
    
    
    /// Make a completion-based API request.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    ///   - completion: The request completion handler.
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, headers: Request.Headers, completion: @escaping Completion<Request>)
}

public extension CompletionClient {
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, headers: Request.Headers, completion: @escaping Completion<Request>) {
        do {
            let request = try self.createURLRequest(endpoint: request, body: body, headers: headers)
            session.dataTask(with: request) { [decoder] data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data, let response = response {
                    do {
                        let result = try decoder.decode(Request.Response.self, from: data)
                        completion(.success(.init(data: result, meta: .init(from: response))))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
}

public extension CompletionClient {
    
    /// Make a completion-based API request when there's no request body (Body == ``Nothing``).
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    ///   - completion: The request completion handler.
    func make<Request: RequestProtocol>(request: Request, headers: Request.Headers, completion: @escaping Completion<Request>) where Request.Body == Nothing  {
        self.make(request: request, body: .init(), headers: headers, completion: completion)
    }
    
    /// Make a completion-based API request when there's no request headers (Headers == ``Nothing``).
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - completion: The request completion handler.
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, completion: @escaping Completion<Request>) where Request.Headers == Nothing  {
        self.make(request: request, body: body, headers: .init(), completion: completion)
    }
    
    /// Make a completion-based API request  when there's no request body or headers (Body == ``Nothing`` and Headers == ``Nothing``).
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - completion: The request completion handler.
    func make<Request: RequestProtocol>(request: Request, completion: @escaping Completion<Request>) where Request.Body == Nothing, Request.Headers == Nothing  {
        self.make(request: request, body: .init(), headers: .init(), completion: completion)
    }
    
    /// Make a completion-based API request with no HTTP headers.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - completion: The request completion handler.
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, completion: @escaping Completion<Request>) where Request.Headers == [String: String] {
        self.make(request: request, body: body, headers: [:], completion: completion)
    }
    
    /// Make a completion-based API request with no HTTP headers when there's no request body (Body == ``Nothing``).
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - completion: The request completion handler.
    func make<Request: RequestProtocol>(request: Request, completion: @escaping Completion<Request>) where Request.Body == Nothing, Request.Headers == [String: String]  {
        self.make(request: request, body: .init(), headers: [:], completion: completion)
    }
}
