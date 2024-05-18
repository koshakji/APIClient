import Foundation


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


public protocol RequestProtocol: GroupProtocol {
    associatedtype Body: Encodable
    associatedtype Headers: StringKeyValueConvertible
    associatedtype Queries: StringKeyValueConvertible
    associatedtype Response: Decodable
    associatedtype ErrorResponse: Decodable
    var method: HTTPMethod { get }
    
    func prepare(request: inout URLRequest, with data: Headers)
}


public extension RequestProtocol {
    func prepare(request: inout URLRequest, with headers: Headers) {
        for (key, value) in headers.keyValues() {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = self.method.text.uppercased()
    }
}


public extension RequestProtocol {
    func createURL(with queries: Queries) -> URL? {
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.path = self.path
        components.port = self.port
        if !queries.keyValues().isEmpty {
            components.queryItems = queries.keyValues().map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        return components.url
    }
}


public struct AdvancedRequest<Body, Headers, Queries, Response, ErrorResponse>: RequestProtocol
where Body: Encodable, Headers: StringKeyValueConvertible, Queries: StringKeyValueConvertible, Response: Decodable, ErrorResponse: Decodable {
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
        method: HTTPMethod = .get
    ) {
        self.scheme = scheme
        self.host = host
        self.port = port
        self.path = path
        self.method = method
    }
}

public typealias Request<Body, Response, ErrorResponse> = AdvancedRequest<Body, [String: String], [String: String], Response, Data> where Body: Encodable, Response: Decodable, ErrorResponse: Decodable
public typealias AuthenticatedRequest<Body, Response, ErrorResponse> = AdvancedRequest<Body, BearerHeaders<[String: String]>, [String: String], Response, ErrorResponse> where Body: Encodable, Response: Decodable, ErrorResponse: Decodable
