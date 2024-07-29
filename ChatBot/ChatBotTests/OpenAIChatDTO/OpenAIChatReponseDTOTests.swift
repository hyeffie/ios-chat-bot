import XCTest
@testable import ChatBot

final class OpenAIChatReponseDTOTests: XCTestCase {
    private let sut: OpenAI.Chat.ResponseDTO.Type = OpenAI.Chat.ResponseDTO.self
    
    private var jsonDecoder: JSONDecoder? = nil
    
    override func setUpWithError() throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.jsonDecoder = decoder
    }
    
    override func tearDownWithError() throws {
        self.jsonDecoder = nil
    }
    
    func test_주어진_JSON데이터를_ResponseDTO로_decoding할_때_데이터가_비어있지_않아야한다() throws {
        // given
        let fileName = "chat-completion-response-sample"
        let targetBundle = Bundle(for: OpenAIChatReponseDTOTests.self)
        let data: Data = try JSONLoader(bundle: targetBundle).loadJSON(fileName: fileName)
        
        // when
        let result = try? self.jsonDecoder?.decode(sut, from: data)
        
        // then
        XCTAssertNotNil(result)
    }
    
    func test_주어진_JSON데이터와_decoding된_ResponseDTO의_데이터가_일치_한다() throws {
        // given
        let fileName = "chat-completion-response-sample"
        let targetBundle = Bundle(for: OpenAIChatReponseDTOTests.self)
        let data: Data = try JSONLoader(bundle: targetBundle).loadJSON(fileName: fileName)
        
        // when
        let result = try? self.jsonDecoder?.decode(sut, from: data)
        
        // then
        XCTAssertEqual(result?.id, "chatcmpl-97c30WvOhMwlHWlOYZNizmehlMTuC")
        XCTAssertEqual(result?.model, "gpt-3.5-turbo-1106")
        XCTAssertEqual(result?.choices.first?.message.role, "assistant")
        XCTAssertEqual(result?.usage.completionTokens, 278)
    }
}
