import Foundation
import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var context = AppDelegate().persistentContainer.viewContext
    
    func createChatData(chatRoomData: ChattingRoomDataModel?, chatData: ChatDataModel) {
        let chatData = MessageData(context: context)
        chatData.chatRoomId = chatData.chatRoomId
        chatData.content = chatData.content
        chatData.messageType = chatData.messageType
        chatData.created = chatData.created
        
        let chatRoom = ChatRoom(context: context)
        chatRoom.id = chatRoomData?.id
        chatRoom.created = chatRoomData?.created
        chatRoom.chatTitle = chatRoomData?.chatTitle
        chatRoom.created = chatRoomData?.created
        
        do {
            try context.save()
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    func readChatMessage(for chatRoomId: UUID) -> [ChatDataModel] {
        let request: NSFetchRequest<MessageData> = MessageData.fetchRequest()
        request.predicate = NSPredicate(format: "chatRoomId == %@", chatRoomId as CVarArg)
        do {
            let chatDataList = try context.fetch(request)
            return chatDataList.map { chatData in
                return ChatDataModel(id: chatData.chatRoomId ?? UUID(),
                                     content: chatData.content ?? "",
                                     messageType: MessageType(rawValue: chatData.messageType ?? "") ?? .question)
            }
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func readChatRoomData() -> [ChattingRoomDataModel] {
        let request: NSFetchRequest<ChatRoom> = ChatRoom.fetchRequest()
        do {
            let chatRoomList = try context.fetch(request)
            return chatRoomList.compactMap { chatRoom in
                guard let id = chatRoom.id,
                      let created = chatRoom.created,
                      let chatTitle = chatRoom.chatTitle else { return nil }
                return ChattingRoomDataModel(id: id, created: created, chatTitle: chatTitle)
            }
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    func updateChatData(id: UUID, newChatTitle: String) {
        let request: NSFetchRequest<ChatRoom> = ChatRoom.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let chatTitle = try context.fetch(request)
            if let chatTitle = chatTitle.first {
                chatTitle.chatTitle = newChatTitle
                try context.save()
            }
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    func deleteChatData(id: UUID) {
        let request: NSFetchRequest<MessageData> = MessageData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        deleteData(request: request)
    }
    
    func deleteAllData() {
        let request: NSFetchRequest<ChatRoom> = ChatRoom.fetchRequest()
        deleteData(request: request)
    }
    
    private func deleteData<T: NSManagedObject>(request: NSFetchRequest<T>) {
        do {
            let dataList = try context.fetch(request)
            for data in dataList {
                context.delete(data)
            }
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
