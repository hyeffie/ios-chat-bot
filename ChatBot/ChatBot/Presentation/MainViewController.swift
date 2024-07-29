import Combine
import UIKit

final class MainViewController: UIViewController {
    private let viewModel: MainViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        sendMessageAsUser()
    }
    
    private func bindViewModel() {
        viewModel.$chatCompletion
            .sink { [weak self] chatCompletion in
                self?.handleChatCompletion(chatCompletion)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .sink { [weak self] message in
                self?.handleError(message: message)
            }
            .store(in: &cancellables)
    }
    
    private func sendMessageAsUser() {
        let question = "내일 추울까?"
        viewModel.sendMessage(content: question)
    }
    
    private func handleChatCompletion(_ chatCompletion: ChatCompletion?) {
        guard
            let message = chatCompletion?.choices.first?.message,
            let content = message.content
        else { return }
        print("\(message.role): \(content)")
    }
    
    private func handleError(message: String?) {
        if let message {
            print("Error!", message)
        }
    }
}

