import Foundation

enum MessageType: String {
    case question
    case answer
}

struct ChatDataModel: Identifiable {
    let id: UUID
    let roomID: UUID
    let content: String
    let messageType: MessageType
    
    init(roomID: UUID, content: String, messageType: MessageType) {
        self.id = UUID()
        self.roomID = roomID
        self.content = content
        self.messageType = messageType
    }
}
