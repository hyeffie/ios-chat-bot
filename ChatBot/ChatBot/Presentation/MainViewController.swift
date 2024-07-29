import Combine
import UIKit

final class MainViewController: UIViewController {
    private let viewModel: MainViewModel
    private let coreDataManager: CoreDataManager
    private var cancellables = Set<AnyCancellable>()
    private let tempRoomID = UUID()
    
    init(viewModel: MainViewModel, coreDataManager: CoreDataManager) {
        self.viewModel = viewModel
        self.coreDataManager = coreDataManager
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
//        coreDataManager.deleteAllData()
        let chatRoomList = coreDataManager.readChatRoomData()
        for chatRoom in chatRoomList {
            print("ChattingRoom ID: \(chatRoom.id), Created: \(chatRoom.created), Title: \(chatRoom.chatTitle)")
                let chatting = coreDataManager.readChatMessage(for: chatRoom.id)
                for chat in chatting {
                    print("Message ID: \(chat.id), MessageType: \(chat.messageType), Content: \(chat.content)")
                }
        }
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
        let question = "흠"
        viewModel.sendMessage(content: question)
        let chatData = ChatDataModel(roomID: UUID(), content: question, messageType: .question)
        coreDataManager.createChatData(chatRoomID: self.tempRoomID, chatData: chatData)
    }
    
    private func handleChatCompletion(_ chatCompletion: ChatCompletion?) {
        guard
            let message = chatCompletion?.choices.first?.message,
            let content = message.content
        else { return }
        print("\(message.role): \(content)")
        let chatData = ChatDataModel(roomID: UUID(), content: content, messageType: .answer)
        coreDataManager.createChatData(chatRoomID: self.tempRoomID, chatData: chatData)
        print("\(chatData)")
    }
    
    private func handleError(message: String?) {
        if let message {
            print("Error!", message)
        }
    }
}
