//
//  CallbackClient.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

public protocol CallbackClient: BaseClient {
    typealias Callback<Request: RequestProtocol> = (Result<Response<Request.Response>, Error>) -> Void
    
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, headers: Request.Headers, completion: @escaping Callback<Request>)
}

public extension CallbackClient {
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, headers: Request.Headers, completion: @escaping Callback<Request>) {
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

public extension CallbackClient {
    func make<Request: RequestProtocol>(request: Request, headers: Request.Headers, completion: @escaping Callback<Request>) where Request.Body == Nothing  {
        self.make(request: request, body: .init(), headers: headers, completion: completion)
    }
    
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, completion: @escaping Callback<Request>) where Request.Headers == Nothing  {
        self.make(request: request, body: body, headers: .init(), completion: completion)
    }
    
    
    func make<Request: RequestProtocol>(request: Request, completion: @escaping Callback<Request>) where Request.Body == Nothing, Request.Headers == Nothing  {
        self.make(request: request, body: .init(), headers: .init(), completion: completion)
    }
    
    func make<Request: RequestProtocol>(request: Request, body: Request.Body, completion: @escaping Callback<Request>) where Request.Headers == [String: String] {
        self.make(request: request, body: body, headers: [:], completion: completion)
    }
    
    func make<Request: RequestProtocol>(request: Request, completion: @escaping Callback<Request>) where Request.Body == Nothing, Request.Headers == [String: String]  {
        self.make(request: request, body: .init(), headers: [:], completion: completion)
    }
}
