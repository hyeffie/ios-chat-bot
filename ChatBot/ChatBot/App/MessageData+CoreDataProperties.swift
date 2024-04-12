import Foundation
import CoreData


extension MessageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageData> {
        return NSFetchRequest<MessageData>(entityName: "MessageData")
    }

    @NSManaged public var chatRoomId: UUID?
    @NSManaged public var content: String?
    @NSManaged public var created: Date?
    @NSManaged public var messageType: String?
    @NSManaged public var chattingRoom: ChatRoom?

}

extension MessageData : Identifiable {

}
