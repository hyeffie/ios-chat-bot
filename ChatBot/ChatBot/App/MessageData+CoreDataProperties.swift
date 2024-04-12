//
//  MessageData+CoreDataProperties.swift
//  ChatBot
//
//  Created by 윤진영 on 4/11/24.
//
//

import Foundation
import CoreData


extension MessageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageData> {
        return NSFetchRequest<MessageData>(entityName: "MessageData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var content: String?
    @NSManaged public var messageType: String?
    @NSManaged public var message: ChatRoom?

}

extension MessageData : Identifiable {

}
