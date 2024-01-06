import Vapor

extension Application {
    private struct HostRouterKey: StorageKey {
        typealias Value = HostRouter
    }
    
    private struct HostRoutesKey: StorageKey {
        typealias Value = HostRoutes
    }
    
    /// The application's host router.
    public var hostRouter: HostRouter { installHostRouter() }
    
    /// Install the host router to enable host-routing.
    ///
    /// This method is usually called automatically once a host route is added, though it can be called manually before any routes are added if you wish to configure the middleware to be before or after other middleware you may need to install.
    @discardableResult
    public func installHostRouter(at position: Middlewares.Position = .end) -> HostRouter {
        if let router = self.storage[HostRouterKey.self] {
            return router
        }
        
        let router = HostRouter()
        self.storage[HostRouterKey.self] = router
        self.middleware.use(router, at: position)
        return router
    }
    
    var hostRoutes: HostRoutes {
        get {
            if let existing = self.storage[HostRoutesKey.self] {
                return existing
            } else {
                let new = HostRoutes()
                self.storage[HostRoutesKey.self] = new
                return new
            }
        }
        set {
            self.storage[HostRoutesKey.self] = newValue
        }
    }
}

extension Application: TopLevelHostRoutesBuilder {
    public func add(_ route: HostRoute) {
        self.installHostRouter()
        self.hostRoutes.add(route)
    }
    
    // TODO: Vapor needs support for multiple ports before this can be enabled.
    internal func grouped(port: Int) -> some TopLevelHostRoutesBuilder {
        HostRoutesGroup(root: self, port: port, domainPath: [])
    }
}
