import Foundation
import CoreData


extension ChatRoom {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatRoom> {
        return NSFetchRequest<ChatRoom>(entityName: "ChatRoom")
    }

    @NSManaged public var chatTitle: String?
    @NSManaged public var created: Date?
    @NSManaged public var roomID: UUID?
    @NSManaged public var messages: NSSet?

}

// MARK: Generated accessors for messages
extension ChatRoom {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageData)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageData)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}

extension ChatRoom : Identifiable {

}

extension ChatRoom {
    func toDomin() -> ChattingRoomDataModel? {
        guard let id = self.roomID,
              let created = self.created,
              let chatTitle = self.chatTitle
        else { return nil }
        return ChattingRoomDataModel(
            id: id,
            created: created,
            chatTitle: chatTitle
        )
    }
}
