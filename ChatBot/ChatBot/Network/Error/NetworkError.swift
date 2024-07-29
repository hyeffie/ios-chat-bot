import Foundation

enum NetworkError: Error {
    case fileToGenerateRequest
    case httpResponse(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case dataError
    case generic(Error)
}
