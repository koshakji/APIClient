import Foundation


/// HTTP Method
public enum HTTPMethod {
    case get, post, patch, put, delete, other(String)
    
    var text: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        case .other(let method):
            return method
        }
    }
}


/// Protocol defining an HTTP request
public protocol RequestProtocol: GroupProtocol {
    
    /// HTTP body type (`Encodable`).
    associatedtype Body: Encodable
    
    /// HTTP headers type (``StringDictionaryConvertible``).
    associatedtype Headers: StringDictionaryConvertible
    
    /// URL queries type (``StringDictionaryConvertible``).
    associatedtype Queries: StringDictionaryConvertible
    
    /// HTTP response body type (`Decodable`).
    associatedtype Response: Decodable
    
    
    /// HTTP method of the request.
    var method: HTTPMethod { get }
    
    /// URL queries of the request.
    var queries: Queries? { get }
    
    
    /// Setup a URLRequest as preferred.
    /// - Parameters:
    ///   - request: URLRequest that's being setup.
    ///   - data: HTTP headers data.
    func prepare(request: inout URLRequest, with data: Headers)
}


public extension RequestProtocol {
    func prepare(request: inout URLRequest, with headers: Headers) {
        for (key, value) in headers.dictionary() {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = self.method.text.uppercased()
    }
}


public extension RequestProtocol {
    
    /// Create a `URL` object from the request components.
    /// - Returns: An optional `URL` object.
    func createURL() -> URL? {
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.path = self.path
        components.port = self.port
        if let queries = queries, !queries.dictionary().isEmpty {
            components.queryItems = queries.dictionary().map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        return components.url
    }
}


/// Fully customizable request type
public struct AdvancedRequest<Body, Headers, Queries, Response>: RequestProtocol
where Body: Encodable, Headers: StringDictionaryConvertible, Queries: StringDictionaryConvertible, Response: Decodable {
    public let scheme: String
    public let host: String
    public let port: Int?
    public let path: String
    public let method: HTTPMethod
    public var queries: Queries?
    
    public init(
        scheme: String = "https",
        host: String,
        port: Int? = nil,
        path: String,
        method: HTTPMethod = .get,
        queries: Queries? = nil
    ) {
        self.scheme = scheme
        self.host = host
        self.port = port
        self.path = path
        self.method = method
        self.queries = queries
    }
}


public extension AdvancedRequest where Queries == [String: String] {
    init(
        scheme: String = "https",
        host: String,
        port: Int? = nil,
        path: String,
        method: HTTPMethod = .get
    ) {
        self.init(scheme: scheme, host: host, port: port, path: path, method: method, queries: [:])
    }
}


public extension AdvancedRequest where Queries == Nothing {
    init(
        scheme: String = "https",
        host: String,
        port: Int? = nil,
        path: String,
        method: HTTPMethod = .get
    ) {
        self.init(scheme: scheme, host: host, port: port, path: path, method: method, queries: .init())
    }
}

/// Basic request type with a generic body and response
public typealias Request<Body, Response> = AdvancedRequest<Body, [String: String], [String: String], Response> where Body: Encodable, Response: Decodable

/// Basic bearer-authorized request type with a generic body and response
public typealias AuthenticatedRequest<Body, Response> = AdvancedRequest<Body, BearerHeaders<[String: String]>, [String: String], Response> where Body: Encodable, Response: Decodable
