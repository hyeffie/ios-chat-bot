import Foundation
import CoreData


extension MessageData {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageData> {
        return NSFetchRequest<MessageData>(entityName: "MessageData")
    }
    
    @NSManaged public var content: String?
    @NSManaged public var created: Date?
    @NSManaged public var messageType: String?
    @NSManaged public var chattingRoom: ChatRoom?
    
}

extension MessageData : Identifiable {
    
}

extension MessageData {
    func toDomain() -> ChatDataModel? {
        guard
            let roomID = self.chattingRoom?.roomID,
            let content = self.content,
            let messageTypeRawValue = self.messageType,
            let type = MessageType(rawValue: messageTypeRawValue)
        else { return nil }
        return ChatDataModel(
            roomID: roomID,
            content: content,
            messageType: type
        )
    }
}
