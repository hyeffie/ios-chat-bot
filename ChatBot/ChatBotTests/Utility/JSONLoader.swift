import Foundation

final class JSONLoader {
    private static let `extension`: String = "json"
    
    private let targetBundle: Bundle
    
    init(bundle: Bundle) {
        self.targetBundle = bundle
    }
    
    func loadJSON(fileName: String) throws -> Data {
        guard
            let url = self.targetBundle.url(
                forResource: fileName,
                withExtension: Self.extension
            )
        else {
            throw BundleResourceError.notFound(nil)
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            throw BundleResourceError.notFound(error)
        }
    }
}

enum BundleResourceError: Error {
    case notFound(Error?)
}
