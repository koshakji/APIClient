import Foundation


public enum HTTPMethod: String {
    case get, post, patch, put, delete
}


public protocol RequestProtocol: GroupProtocol {
    associatedtype Body: Encodable
    associatedtype Headers: StringDictionaryConvertible
    associatedtype Queries: StringDictionaryConvertible
    associatedtype Response: Decodable
    var method: HTTPMethod { get }
    var queries: Queries? { get }
    
    func prepare(request: inout URLRequest, with data: Headers)
}


public extension RequestProtocol {
    func prepare(request: inout URLRequest, with headers: Headers) {
        for (key, value) in headers.dictionary() {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = self.method.rawValue.uppercased()
    }
}


public extension RequestProtocol {
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

public typealias Request<Body, Response> = AdvancedRequest<Body, [String: String], [String: String], Response> where Body: Encodable, Response: Decodable
public typealias AuthenticatedRequest<Body, Response> = AdvancedRequest<Body, AuthenticatedHeaders<[String: String]>, [String: String], Response> where Body: Encodable, Response: Decodable
