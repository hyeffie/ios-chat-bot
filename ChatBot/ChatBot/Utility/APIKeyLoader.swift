import Foundation

struct APIKeyLoader {
    static private let targetBundle = Bundle.main
    
    static func getAPIKey(by key: String) -> String {
        let plist = targetBundle.infoDictionary
        guard let apiKey =  plist?[key] as? String else {
            fatalError()
        }
        return apiKey
    }
}
