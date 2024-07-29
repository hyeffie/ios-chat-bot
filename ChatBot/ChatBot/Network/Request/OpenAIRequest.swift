import Foundation

struct OpenAIRequest: HTTPRequestable {
    let baseURL: String
    let path: String
    let headerFields: [String: String]
    let queries: [String: Any]
    let method: HTTPRequestMethod
    let body: Data?
    
    init(
        method: HTTPRequestMethod = .post,
        body: Data?
    ) {
        self.baseURL = Constant.baseURL
        self.path = Constant.chatPath
        self.headerFields = Self.makeHeaderFields()
        self.queries = [:]
        self.method = method
        self.body = body
    }
}

extension OpenAIRequest {
    enum Constant {
        static let apiKey: String = "OPENAI_API_KEY"
        static let baseURL: String = "api.openai.com"
        static let chatPath: String = "/v1/chat/completions"
    }
    
    private static let apiKey: String = {
        return APIKeyLoader.getAPIKey(by: Constant.apiKey)
    }()
    
    private static func makeHeaderFields() -> [String: String] {
        let fields: HTTPRequestHeader.Fields = [
            HTTPRequestHeader.Authorization(.bearer(token: apiKey)),
            HTTPRequestHeader.ContentType(.application(.json)),
        ]
        let result = fields.toFields()
        return result
    }
}
