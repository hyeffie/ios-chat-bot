import Foundation
import Combine

final class NetworkService {
    private let requester: NetworkRequestable
    
    init(
        requester: NetworkRequestable
    ) {
        self.requester = requester
    }
    
    func requestMessage(
        body: Data?
    ) -> AnyPublisher<Data, NetworkError> {
        guard
            let request = makeRequest(body: body)
        else {
            return Fail(error: NetworkError.fileToGenerateRequest)
                .eraseToAnyPublisher()
        }
        
        return requester.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.notConnected
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.httpResponse(statusCode: httpResponse.statusCode, data: data)
                }
                return data
            }
            .mapError { [weak self] error -> NetworkError in
                guard let self else { return .generic(error) }
                return self.convertToNetworkError(from: error)
            }
            .eraseToAnyPublisher()
    }
    
    private func makeRequest(body: Data?) -> URLRequest? {
        let request = OpenAIRequest(body: body)
        return request.toURLRequest()
    }
    
    private func convertToNetworkError(from error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        } else if let urlError = error as? URLError {
            return .generic(urlError)
        } else {
            return .generic(error)
        }
    }
}
