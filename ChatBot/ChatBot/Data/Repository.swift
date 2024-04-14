struct Repository {
    private let persistentStore: PersistentStore
    
    private let networkService: NetworkService
    
    init(
        persistentStore: PersistentStore,
        networkService: NetworkService
    ) {
        self.persistentStore = persistentStore
        self.networkService = networkService
    }
    
    
}
