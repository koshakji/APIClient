//
//  CompletionClient.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

public protocol CompletionClient: BaseClient {
    typealias Completion<Request: RequestProtocol> = (Result<Response<Request.Response>, APIClientError<Request.ErrorResponse>>) -> Void
    
    func make<Request: RequestProtocol>(
        request: Request,
        body: Request.Body,
        headers: Request.Headers,
        queries: Request.Queries,
        completion: @escaping Completion<Request>)
}

public extension CompletionClient {
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, headers: Request.Headers, queries: Request.Queries, completion: @escaping Completion<Request>) {
        do {
            let request = try self.createURLRequest(endpoint: request, body: body, headers: headers, queries: queries)
            session.dataTask(with: request) { [decoder] data, response, error in
                if let error = error {
                    completion(.failure(buildError(underlyingError: error)))
                    return
                }
                
                if let data = data, let response = response {
                    do {
                        let result = try decoder.decode(Request.Response.self, from: data)
                        completion(.success(.init(data: result, meta: .init(from: response))))
                    } catch {
                        completion(.failure(buildError(data: data, response: response, underlyingError: error)))
                    }
                }
            }.resume()
        } catch {
            completion(.failure(buildError(underlyingError: error)))
        }
    }
}

public extension CompletionClient {
    
    /// Make an completion-handled API request when headers is Nothing.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - queries: The request URL queries, must match the queries type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, queries: Request.Queries, completion: @escaping Completion<Request>) where  Request.Headers == Nothing {
        return make(request: request, body: body, headers: .init(), queries: queries, completion: completion)
    }
    
    /// Make an completion-handled API request when headers is Dictionary<String, String>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - queries: The request URL queries, must match the queries type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, queries: Request.Queries, completion: @escaping Completion<Request>) where  Request.Headers == Dictionary<String, String> {
        return make(request: request, body: body, headers: .init(), queries: queries, completion: completion)
    }
    
    /// Make an completion-handled API request when headers is Optional<H>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - queries: The request URL queries, must match the queries type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol, H>(request: Request, body: Request.Body, queries: Request.Queries, completion: @escaping Completion<Request>) where  Request.Headers == Optional<H> {
        return make(request: request, body: body, headers: nil, queries: queries, completion: completion)
    }
    
    /// Make an completion-handled API request when queries is Nothing.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, headers: Request.Headers, completion: @escaping Completion<Request>) where  Request.Queries == Nothing {
        return make(request: request, body: body, headers: headers, queries: .init(), completion: completion)
    }
    
    /// Make an completion-handled API request when headers is Nothing, queries is Nothing.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, completion: @escaping Completion<Request>) where  Request.Headers == Nothing, Request.Queries == Nothing {
        return make(request: request, body: body, headers: .init(), queries: .init(), completion: completion)
    }
    
    /// Make an completion-handled API request when headers is Dictionary<String, String>, queries is Nothing.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, completion: @escaping Completion<Request>) where  Request.Headers == Dictionary<String, String>, Request.Queries == Nothing {
        return make(request: request, body: body, headers: .init(), queries: .init(), completion: completion)
    }
    
    /// Make an completion-handled API request when headers is Optional<H>, queries is Nothing.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol, H>(request: Request, body: Request.Body, completion: @escaping Completion<Request>) where  Request.Headers == Optional<H>, Request.Queries == Nothing {
        return make(request: request, body: body, headers: nil, queries: .init(), completion: completion)
    }
    
    /// Make an completion-handled API request when queries is Dictionary<String, String>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, headers: Request.Headers, completion: @escaping Completion<Request>) where  Request.Queries == Dictionary<String, String> {
        return make(request: request, body: body, headers: headers, queries: .init(), completion: completion)
    }
    
    /// Make an completion-handled API request when headers is Nothing, queries is Dictionary<String, String>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, completion: @escaping Completion<Request>) where  Request.Headers == Nothing, Request.Queries == Dictionary<String, String> {
        return make(request: request, body: body, headers: .init(), queries: .init(), completion: completion)
    }
    
    /// Make an completion-handled API request when headers is Dictionary<String, String>, queries is Dictionary<String, String>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, completion: @escaping Completion<Request>) where  Request.Headers == Dictionary<String, String>, Request.Queries == Dictionary<String, String> {
        return make(request: request, body: body, headers: .init(), queries: .init(), completion: completion)
    }
    
    /// Make an completion-handled API request when headers is Optional<H>, queries is Dictionary<String, String>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol, H>(request: Request, body: Request.Body, completion: @escaping Completion<Request>) where  Request.Headers == Optional<H>, Request.Queries == Dictionary<String, String> {
        return make(request: request, body: body, headers: nil, queries: .init(), completion: completion)
    }
    
    /// Make an completion-handled API request when queries is Optional<Q>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol, Q>(request: Request, body: Request.Body, headers: Request.Headers, completion: @escaping Completion<Request>) where  Request.Queries == Optional<Q> {
        return make(request: request, body: body, headers: headers, queries: nil, completion: completion)
    }
    
    /// Make an completion-handled API request when headers is Nothing, queries is Optional<Q>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol, Q>(request: Request, body: Request.Body, completion: @escaping Completion<Request>) where  Request.Headers == Nothing, Request.Queries == Optional<Q> {
        return make(request: request, body: body, headers: .init(), queries: nil, completion: completion)
    }
    
    /// Make an completion-handled API request when headers is Dictionary<String, String>, queries is Optional<Q>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol, Q>(request: Request, body: Request.Body, completion: @escaping Completion<Request>) where  Request.Headers == Dictionary<String, String>, Request.Queries == Optional<Q> {
        return make(request: request, body: body, headers: .init(), queries: nil, completion: completion)
    }
    
    /// Make an completion-handled API request when headers is Optional<H>, queries is Optional<Q>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - body: The request body, must match the body type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol, H, Q>(request: Request, body: Request.Body, completion: @escaping Completion<Request>) where  Request.Headers == Optional<H>, Request.Queries == Optional<Q> {
        return make(request: request, body: body, headers: nil, queries: nil, completion: completion)
    }
    
    /// Make an completion-handled API request when body is `Nothing`.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    ///   - queries: The request URL queries, must match the queries type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol>(request: Request, headers: Request.Headers, queries: Request.Queries, completion: @escaping Completion<Request>) where  Request.Body == Nothing {
        return make(request: request, body: .init(), headers: headers, queries: queries, completion: completion)
    }
    
    /// Make an completion-handled API request when body is `Nothing`, headers is Nothing.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - queries: The request URL queries, must match the queries type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol>(request: Request, queries: Request.Queries, completion: @escaping Completion<Request>) where  Request.Body == Nothing, Request.Headers == Nothing {
        return make(request: request, body: .init(), headers: .init(), queries: queries, completion: completion)
    }
    
    /// Make an completion-handled API request when body is `Nothing`, headers is Dictionary<String, String>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - queries: The request URL queries, must match the queries type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol>(request: Request, queries: Request.Queries, completion: @escaping Completion<Request>) where  Request.Body == Nothing, Request.Headers == Dictionary<String, String> {
        return make(request: request, body: .init(), headers: .init(), queries: queries, completion: completion)
    }
    
    /// Make an completion-handled API request when body is `Nothing`, headers is Optional<H>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - queries: The request URL queries, must match the queries type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol, H>(request: Request, queries: Request.Queries, completion: @escaping Completion<Request>) where  Request.Body == Nothing, Request.Headers == Optional<H> {
        return make(request: request, body: .init(), headers: nil, queries: queries, completion: completion)
    }
    
    /// Make an completion-handled API request when body is `Nothing`, queries is Nothing.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol>(request: Request, headers: Request.Headers, completion: @escaping Completion<Request>) where  Request.Body == Nothing, Request.Queries == Nothing {
        return make(request: request, body: .init(), headers: headers, queries: .init(), completion: completion)
    }
    
    /// Make an completion-handled API request when body is `Nothing`, headers is Nothing, queries is Nothing.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol>(request: Request, completion: @escaping Completion<Request>) where  Request.Body == Nothing, Request.Headers == Nothing, Request.Queries == Nothing {
        return make(request: request, body: .init(), headers: .init(), queries: .init(), completion: completion)
    }
    
    /// Make an completion-handled API request when body is `Nothing`, headers is Dictionary<String, String>, queries is Nothing.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol>(request: Request, completion: @escaping Completion<Request>) where  Request.Body == Nothing, Request.Headers == Dictionary<String, String>, Request.Queries == Nothing {
        return make(request: request, body: .init(), headers: .init(), queries: .init(), completion: completion)
    }
    
    /// Make an completion-handled API request when body is `Nothing`, headers is Optional<H>, queries is Nothing.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol, H>(request: Request, completion: @escaping Completion<Request>) where  Request.Body == Nothing, Request.Headers == Optional<H>, Request.Queries == Nothing {
        return make(request: request, body: .init(), headers: nil, queries: .init(), completion: completion)
    }
    
    /// Make an completion-handled API request when body is `Nothing`, queries is Dictionary<String, String>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol>(request: Request, headers: Request.Headers, completion: @escaping Completion<Request>) where  Request.Body == Nothing, Request.Queries == Dictionary<String, String> {
        return make(request: request, body: .init(), headers: headers, queries: .init(), completion: completion)
    }
    
    /// Make an completion-handled API request when body is `Nothing`, headers is Nothing, queries is Dictionary<String, String>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol>(request: Request, completion: @escaping Completion<Request>) where  Request.Body == Nothing, Request.Headers == Nothing, Request.Queries == Dictionary<String, String> {
        return make(request: request, body: .init(), headers: .init(), queries: .init(), completion: completion)
    }
    
    /// Make an completion-handled API request when body is `Nothing`, headers is Dictionary<String, String>, queries is Dictionary<String, String>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol>(request: Request, completion: @escaping Completion<Request>) where  Request.Body == Nothing, Request.Headers == Dictionary<String, String>, Request.Queries == Dictionary<String, String> {
        return make(request: request, body: .init(), headers: .init(), queries: .init(), completion: completion)
    }
    
    /// Make an completion-handled API request when body is `Nothing`, headers is Optional<H>, queries is Dictionary<String, String>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol, H>(request: Request, completion: @escaping Completion<Request>) where  Request.Body == Nothing, Request.Headers == Optional<H>, Request.Queries == Dictionary<String, String> {
        return make(request: request, body: .init(), headers: nil, queries: .init(), completion: completion)
    }
    
    /// Make an completion-handled API request when body is `Nothing`, queries is Optional<Q>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - headers: The request HTTP headers, must match the headers type of the request.
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol, Q>(request: Request, headers: Request.Headers, completion: @escaping Completion<Request>) where  Request.Body == Nothing, Request.Queries == Optional<Q> {
        return make(request: request, body: .init(), headers: headers, queries: nil, completion: completion)
    }
    
    /// Make an completion-handled API request when body is `Nothing`, headers is Nothing, queries is Optional<Q>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol, Q>(request: Request, completion: @escaping Completion<Request>) where  Request.Body == Nothing, Request.Headers == Nothing, Request.Queries == Optional<Q> {
        return make(request: request, body: .init(), headers: .init(), queries: nil, completion: completion)
    }
    
    /// Make an completion-handled API request when body is `Nothing`, headers is Dictionary<String, String>, queries is Optional<Q>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol, Q>(request: Request, completion: @escaping Completion<Request>) where  Request.Body == Nothing, Request.Headers == Dictionary<String, String>, Request.Queries == Optional<Q> {
        return make(request: request, body: .init(), headers: .init(), queries: nil, completion: completion)
    }
    
    /// Make an completion-handled API request when body is `Nothing`, headers is Optional<H>, queries is Optional<Q>.
    /// - Parameters:
    ///   - request: The request definition (includes URL, URL parameters and method).
    ///   - completion: The request completion handler..
    func make<Request: RequestProtocol, H, Q>(request: Request, completion: @escaping Completion<Request>) where  Request.Body == Nothing, Request.Headers == Optional<H>, Request.Queries == Optional<Q> {
        return make(request: request, body: .init(), headers: nil, queries: nil, completion: completion)
    }
}
