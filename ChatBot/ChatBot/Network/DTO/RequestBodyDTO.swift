extension OpenAI.Chat {
    /// OpenAI Chat API로 보내는 요청의 바디에 대한 데이터 전송 객체
    struct RequestBodyDTO: Encodable  {
        /// 사용할 모델의 이름을 나타내는 문자열
        ///
        /// 기본값은 `gpt-3.5-turbo-1106`입니다.
        let model: String = "gpt-3.5-turbo-1106"
        
        /// 스트리밍 모드 여부를 나타내는 부울 값
        ///
        /// 기본값은 false입니다.
        let stream: Bool = false
        
        /// 전송할 메시지의 배열
        let messages: [Message]
    }
}

extension OpenAI.Chat.RequestBodyDTO {
    /// 요청 바디에 포함되는 각 메시지의 데이터 모델
    struct Message: Encodable {
        /// 메시지의 역할을 나타내는 열거형
        let role: Role
        
        /// 메시지의 내용을 나타내는 문자열
        let content: String
    }
}

extension OpenAI.Chat.RequestBodyDTO.Message {
    /// 인코딩 키를 정의하는 열거형
    enum Key: CodingKey {
        case role
        case content
    }
    
    /// 메시지의 역할을 나타내는 열거형
    enum Role: String {
        case system
        case assistant
        case user
    }
}

extension OpenAI.Chat.RequestBodyDTO.Message {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(self.role.rawValue, forKey: .role)
        try container.encode(self.content, forKey: .content)
    }
}
