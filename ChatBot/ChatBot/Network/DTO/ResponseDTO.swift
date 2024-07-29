/// OpenAI Chat API로부터 수신한 응답 데이터 전송 객체.
enum OpenAI {
    /// 채팅과 관련된 엔터티를 위한 네임스페이스.
    enum Chat { }
}

extension OpenAI.Chat {
    /// OpenAI Chat API의 응답을 나타내는 데이터 전송 객체.
    struct ResponseDTO: Decodable {
        /// 응답의 고유 식별자.
        ///
        /// 식별자를 사용해 응답을 추적할 수 있습니다.
        let id: String
        
        /// 객체의 유형을 나타내는 문자열.
        ///
        /// 일반적으로 "text_completion"과 같은 형식입니다.
        let object: String
        
        /// 응답이 생성된 시간.
        ///
        /// Unix epoch 시간 형식을 따릅니다.
        let created: Int
        
        /// 응답을 생성하는 데 사용된 모델의 이름.
        ///
        /// 해당 모델에 따라 응답의 특성이 다를 수 있습니다.
        let model: String
        
        /// 응답과 관련된 시스템 정보를 나타내는 지문.
        ///
        /// 이 정보는 응답의 특정 버전을 식별하는 데 사용됩니다.
        let systemFingerprint: String
        
        /// 완성에 대한 여러 선택지들의 배열.
        ///
        /// 각 선택지는 완성의 다양한 가능성을 나타냅니다.
        let choices: [Choice]
        
        /// 완성에 사용된 토큰
        let usage: Usage
    }
}

extension OpenAI.Chat.ResponseDTO {
    /// 완성 작업의 선택지를 나타내는 데이터 모델
    struct Choice: Decodable {
        /// 완성을 종료하는 원인에 대한 설명
        ///
        /// 완성이 성공적으로 완료되거나 중단된 이유를 파악하는 데 도움이 됩니다.
        let finishReason: String
        
        /// 선택지의 인덱스입니다.
        ///
        /// 여러 선택지 중에서 해당 선택지를 식별하는 데 사용됩니다.
        let index: Int
        
        /// 완성 작업의 결과로 생성된 메시지
        ///
        /// 이 메시지는 완성된 텍스트나 다른 형식의 결과를 포함할 수 있습니다.
        let message: Message
        
        /// 완성과 관련된 로그 확률 정보
        ///
        /// 이는 완성 작업의 확률적 특성을 이해하는 데 도움이 됩니다.
        let logProbs: LogProbs?
    }
    
    /// 완성 작업에 대한 사용 통계를 나타내는 데이터 모델
    struct Usage: Decodable {
        /// 완성 작업에 사용된 토큰의 수
        ///
        /// 이는 완성 작업의 복잡성과 양을 평가하는 데 사용됩니다.
        let completionTokens: Int
        
        /// 완성 작업에 사용된 프롬프트 토큰의 수
        ///
        /// 이는 완성 작업이 프롬프트에 얼마나 의존하는지를 파악하는 데 도움이 됩니다.
        let promptTokens: Int
        
        /// 완성 작업에 사용된 총 토큰의 수
        ///
        /// 이는 완성 작업의 전체 규모를 나타내며 작업의 복잡성을 평가하는 데 중요한 지표입니다.
        let totalTokens: Int
    }
}

extension OpenAI.Chat.ResponseDTO.Choice {
    /// 완성 작업의 결과로 생성된 메시지를 나타내는 데이터 모델
    struct Message: Decodable {
        /// 메시지의 역할을 나타내는 문자열
        ///
        /// 예를 들어 "system"이나 "user"와 같은 값일 수 있습니다.
        let role: String
        
        /// 메시지의 내용
        ///
        /// 완성 작업의 결과물로 생성된 텍스트 또는 다른 형태의 데이터일 수 있습니다.
        let content: String?
        
        /// 메시지와 관련된 선택적 도구 호출
        ///
        /// 메시지 생성에 사용된 도구와 기능을 보충하는 데 사용됩니다.
        let toolCalls: [ToolCall]?
    }
    
    /// 완성과 관련된 로그 확률 정보를 나타내는 데이터 모델
    struct LogProbs: Decodable {
        /// 각 토큰에 대한 로그 확률 정보의 배열
        ///
        /// 이 정보는 완성 작업의 특정 토큰에 대한 확률적 특성을 파악하는 데 도움이 됩니다.
        let content: [Content]?
        
        /// 각 토큰에 대한 로그 확률 정보를 나타내는 데이터 모델
        struct Content: Decodable {
            /// 토큰의 문자열 값
            let token: String
            
            /// 토큰의 로그 확률 값
            let logprob: Double
            
            /// 토큰의 바이트 표현 값
            let bytes: [Int]?
            
            /// 토큰에 대한 상위 로그 확률 정보의 배열
            ///
            /// 이 정보는 특정 토큰과 관련된 다양한 선택 가능성을 제공합니다.
            let topLogProbs: [TopLogprob]
            
            /// 각 토큰에 대한 상위 로그 확률 정보를 나타내는 데이터 모델
            struct TopLogprob: Decodable {
                /// 토큰의 문자열 값
                let token: String
                
                /// 토큰의 로그 확률 값
                let logProb: Double
                
                /// 토큰의 바이트 표현 값
                let bytes: [Int]?
            }
        }
    }
}

extension OpenAI.Chat.ResponseDTO.Choice.Message {
    /// 완성 작업에 사용된 도구 호출을 나타내는 데이터 모델
    struct ToolCall: Decodable {
        /// 도구 호출의 식별자
        let id: String
        
        /// 도구 호출의 유형을 나타내는 문자열
        let type: String
        
        /// 도구 호출의 기능을 나타내는 데이터 모델
        let function: Function
    }
}

extension OpenAI.Chat.ResponseDTO.Choice.Message.ToolCall {
    /// 도구 호출의 기능을 나타내는 데이터 모델
    struct Function: Decodable {
        /// 함수의 이름을 나타내는 문자열
        let name: String
        
        /// 함수에 전달된 인수를 설명하는 문자열
        let arguments: String
    }
}

extension OpenAI.Chat.ResponseDTO {
    func toDomain() -> ChatCompletion {
        let choices: [ChatCompletion.Choice] = self.choices.compactMap { choice in
            guard
                let role = ChatCompletion.Choice.Message.Role(rawValue: choice.message.role)
            else {
                return nil
            }
            let message = ChatCompletion.Choice.Message(
                role: role,
                content: choice.message.content
            )
            return .init(index: choice.index, message: message)
        }
        
        return .init(
            created: self.created,
            choices: choices
        )
    }
}
