protocol PersistentStore {
    func save<Request>(request: Request)
    func fetch<Request, Entity>(request: Request) -> [Entity]
    func update<Request>(request: Request)
    func delete<Request>(request: Request)
}

import CoreData

struct SaveRequest<T: NSManagedObject> {
    let object: T
}

struct FetchRequst {
    let predicate: NSPredicate?
}

struct UpdateRequest {
    
}

struct DeleteRequest {
    
}
