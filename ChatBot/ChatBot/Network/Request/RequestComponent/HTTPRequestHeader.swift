protocol StringValueProtocol {
    var value: String { get }
}

protocol FieldProtocol {
    var key: String { get set }
    var value: String { get set }
}

enum HTTPRequestHeader {
    struct Authorization: FieldProtocol {
        enum Authorization: StringValueProtocol {
            case bearer(token: String)
            
            var value: String {
                switch self {
                case .bearer(let token):
                    return "Bearer \(token)"
                }
            }
        }
        
        var key: String = "Authorization"
        var value: String
        
        init(_ authorization: Authorization) {
            self.value = authorization.value
        }
    }

    struct ContentType: FieldProtocol {
        enum ContentType: StringValueProtocol {
            case application(Application)
            
            var value: String {
                switch self {
                case .application(let application):
                    return "application/\(application.constant)"
                }
            }
            
            struct Application: Hashable {
                let constant: String
                
                init(constant: String) {
                    self.constant = constant
                }
                
                static let json: Self = .init(constant: "json")
            }
        }
        
        var key: String = "Content-Type"
        var value: String
        
        init(_ contentType: ContentType) {
            self.value = contentType.value
        }
    }
    
    typealias Fields = [any FieldProtocol]
}

extension HTTPRequestHeader.Fields {
    func toFields() -> [String: String] {
        return self.reduce(into: [:]) { partialResult, field in
            partialResult.updateValue(field.value, forKey: field.key)
        }
    }
}
