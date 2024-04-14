import Foundation
import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var context = AppDelegate().persistentContainer.viewContext
    
    func createChatData(chatRoomID: UUID?, chatData: ChatDataModel) {
        let newMessage = MessageData(context: context)
        newMessage.content = newMessage.content
        newMessage.messageType = newMessage.messageType
        newMessage.created = newMessage.created
        
        if let chatRoomID {
            // 기존 채팅방에 추가
            let roomRequest = ChatRoom.fetchRequest()
            roomRequest.predicate = .init(
                format: "%K == %@",
                #keyPath(ChatRoom.roomID), chatRoomID as CVarArg
            )
            guard
                let results = try? context.fetch(roomRequest),
                let targetRoom = results.first(where: { room in room.roomID == chatRoomID })
            else {
                // 새 방 만들기
                return
            }
            newMessage.chattingRoom = targetRoom
            targetRoom.addToMessages(newMessage)
        } else {
            // 새 채팅방 만들고 추가
            let chatRoom = ChatRoom(context: context)
            chatRoom.roomID = UUID()
            chatRoom.created = Date()
            chatRoom.chatTitle = newMessage.content
            newMessage.chattingRoom = chatRoom
        }
        
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
            return chatDataList.compactMap { $0.toDomain() }
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func readChatRoomData() -> [ChattingRoomDataModel] {
        let request: NSFetchRequest<ChatRoom> = ChatRoom.fetchRequest()
        do {
            let chatRoomList = try context.fetch(request)
            return chatRoomList.compactMap { $0.toDomin() }
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
