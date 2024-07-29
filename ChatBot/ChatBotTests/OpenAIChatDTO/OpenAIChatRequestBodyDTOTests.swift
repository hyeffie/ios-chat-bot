import XCTest
@testable import ChatBot

final class OpenAIChatRequestBodyDTOTests: XCTestCase {
    
    private var jsonEncoder: JSONEncoder? = nil
    
    override func setUpWithError() throws {
        let encoder = JSONEncoder()
        self.jsonEncoder = encoder
    }

    override func tearDownWithError() throws {
        self.jsonEncoder = nil
    }
    
    func test_주어진_데이터가_DTO에_정의된_속성들의_JSON으로_encoding될_때_데이터가_비어있지_않아야한다() throws {
        // given
        let messages = [OpenAI.Chat.RequestBodyDTO.Message(role: "yuni", content: "Hello")]
        let expectedDTO = OpenAI.Chat.RequestBodyDTO(messages: messages)
        
        // when
        let encodedData = try? jsonEncoder?.encode(expectedDTO)
        
        // then
        XCTAssertNotNil(encodedData)
    }
    
    func test_주어진_데이터와_encoding된_RequestBodyDTO의_데이터가_일치_한다() throws {
        // given
        let messages = [OpenAI.Chat.RequestBodyDTO.Message(role: "yuni", content: "Hello")]
        let expectedDTO = OpenAI.Chat.RequestBodyDTO(messages: messages)
        
        // when
        let encodedData = try jsonEncoder?.encode(expectedDTO)
        let encodedString = String(data: encodedData!, encoding: .utf8)!
        
        // then
        XCTAssertNotNil(encodedData)
        XCTAssertTrue(encodedString.contains("\"model\":\"gpt-3.5-turbo-1106\""))
        XCTAssertTrue(encodedString.contains("\"stream\":false"))
        XCTAssertTrue(encodedString.contains("\"role\":\"yuni\""))
        XCTAssertTrue(encodedString.contains("\"content\":\"Hello\""))
    }
}
