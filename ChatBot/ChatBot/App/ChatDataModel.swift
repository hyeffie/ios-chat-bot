import Foundation

enum MessageType: String {
    case question
    case answer
}

struct ChatDataModel: Identifiable {
    let id: UUID
    let content: String
    let messageType: MessageType
    
    init(id: UUID, content: String, messageType: MessageType) {
        self.id = id
        self.content = content
        self.messageType = messageType
    }
}
