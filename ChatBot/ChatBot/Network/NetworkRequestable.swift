import Foundation

protocol NetworkRequestable {
    func dataTaskPublisher(
        for request: URLRequest
    ) -> URLSession.DataTaskPublisher
}
