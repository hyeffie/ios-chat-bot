import Foundation

struct ChattingRoomDataModel: Identifiable {
    let id: UUID
    let created: Date
    let chatTitle: String
    
    init(id: UUID, created: Date, chatTitle: String) {
        self.id = id
        self.created = created
        self.chatTitle = chatTitle
    }
}
