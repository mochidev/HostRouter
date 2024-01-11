import Vapor

struct HostMiddlewareGroup: Sendable, TopLevelHostRoutesBuilder {
    /// Router to cascade to.
    let root: HostRoutesBuilder
    
    /// Additional middleware.
    let middleware: [Middleware]

    /// Creates a new routing group.
    init(root: HostRoutesBuilder, middleware: [Middleware]) {
        self.root = root
        self.middleware = middleware
    }
    
    /// Prepend the root to the added route, and pass it up the chain.
    func add(_ route: HostRoute) {
        route.route.responder = self.middleware.makeResponder(chainingTo: route.route.responder)
        root.add(route)
    }
}

extension TopLevelHostRoutesBuilder {
    public func grouped(_ middleware: Middleware...) -> some TopLevelHostRoutesBuilder {
        HostMiddlewareGroup(root: self, middleware: middleware)
    }
    
    public func grouped(_ middleware: [Middleware]) -> some TopLevelHostRoutesBuilder {
        HostMiddlewareGroup(root: self, middleware: middleware)
    }
    
    public func group(_ middleware: Middleware..., configure: (TopLevelHostRoutesBuilder) throws -> ()) rethrows {
        try configure(HostMiddlewareGroup(root: self, middleware: middleware))
    }
    
    public func group(_ middleware: [Middleware], configure: (TopLevelHostRoutesBuilder) throws -> ()) rethrows {
        try configure(HostMiddlewareGroup(root: self, middleware: middleware))
    }
}

extension HostRoutesBuilder {
    public func grouped(_ middleware: Middleware...) -> some HostRoutesBuilder {
        HostMiddlewareGroup(root: self, middleware: middleware)
    }
    
    public func grouped(_ middleware: [Middleware]) -> some HostRoutesBuilder {
        HostMiddlewareGroup(root: self, middleware: middleware)
    }
    
    public func group(_ middleware: Middleware..., configure: (HostRoutesBuilder) throws -> ()) rethrows {
        try configure(HostMiddlewareGroup(root: self, middleware: middleware))
    }
    
    public func group(_ middleware: [Middleware], configure: (HostRoutesBuilder) throws -> ()) rethrows {
        try configure(HostMiddlewareGroup(root: self, middleware: middleware))
    }
}
