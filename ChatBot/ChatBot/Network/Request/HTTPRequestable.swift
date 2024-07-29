import Foundation

protocol HTTPRequestable {
    var baseURL: String { get }
    var path: String { get }
    var headerFields: [String: String] { get }
    var queries: [String: Any] { get }
    var method: HTTPRequestMethod { get }
    var body: Data? { get }
    
    func toURLRequest() -> URLRequest?
}

extension HTTPRequestable {
    private func toURL() -> URL? {
        var components = URLComponents()
        components.scheme = URLScheme.https.rawValue
        components.host = self.baseURL 
        components.path = self.path
        components.queryItems = self.queries.map { URLQueryItem(name: $0, value: $1 as? String) }
        return components.url
    }
    
    func toURLRequest() -> URLRequest? {
        guard let url = toURL() else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.allHTTPHeaderFields = self.headerFields
        urlRequest.httpBody = self.body
        return urlRequest
    }
}

