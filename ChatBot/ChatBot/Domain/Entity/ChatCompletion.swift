struct ChatCompletion {
    struct Choice {
        struct Message {
            enum Role: String {
                case system
                case assistant
                case user
            }
            
            let role: Role
            let content: String?
        }
        
        let index: Int
        let message: Message
    }
    let created: Int
    let choices: [Choice]
}
