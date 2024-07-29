import Combine
import Foundation

final class MainViewModel {
    private let networkService: NetworkService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var chatCompletion: ChatCompletion? = nil
    @Published var errorMessage: String? = nil
    
    init(
        networkService: NetworkService
    ) {
        self.networkService = networkService
    }

    func sendMessage(
        content: String
    ) {
        let message = OpenAI.Chat.RequestBodyDTO.Message(role: .user, content: content)
        let bodyObject = OpenAI.Chat.RequestBodyDTO(messages: [message])
        let bodyData = try? JSONEncoder().encode(bodyObject)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        networkService.requestMessage(body: bodyData)
            .decode(type: OpenAI.Chat.ResponseDTO.self, decoder: decoder)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleError(error)
                }
            } receiveValue: { responseDTO in
                let object = responseDTO.toDomain()
                self.chatCompletion = object
            }
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
    }
}
