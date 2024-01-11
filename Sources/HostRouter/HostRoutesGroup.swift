struct HostRoutesGroup: Sendable, TopLevelHostRoutesBuilder {
    /// Router to cascade to.
    let root: HostRoutesBuilder
    
    /// Port override.
    let port: Int?
    
    /// Domain path prefix.
    let domainPath: [HostComponent]

    /// Creates a new routing group.
    init(root: HostRoutesBuilder, port: Int?, domainPath: [HostComponent]) {
        self.root = root
        self.port = port
        self.domainPath = domainPath
    }
    
    /// Prepend the root to the added route, and pass it up the chain.
    func add(_ route: HostRoute) {
        var route = route
        if let port {
            route.port = port
        }
        if !domainPath.isEmpty {
            route.domainPath = domainPath + route.domainPath
        }
        root.add(route)
    }
}

extension TopLevelHostRoutesBuilder {
    public func grouped(host: some StringProtocol) -> some HostRoutesBuilder {
        HostRoutesGroup(root: self, port: nil, domainPath: host.reversedDomainComponents)
    }
}

extension HostRoutesBuilder {
    public func grouped(subDomain: some StringProtocol) -> some HostRoutesBuilder {
        HostRoutesGroup(root: self, port: nil, domainPath: subDomain.reversedDomainComponents)
    }
    
    public func grouped(reverseDomain: HostComponent...) -> some HostRoutesBuilder {
        HostRoutesGroup(root: self, port: nil, domainPath: reverseDomain)
    }
    
    public func grouped(reverseDomain: [HostComponent]) -> some HostRoutesBuilder {
        HostRoutesGroup(root: self, port: nil, domainPath: reverseDomain)
    }
    
    public func grouped(subDomain: some StringProtocol, configure: (HostRoutesBuilder) throws -> ()) rethrows {
        try configure(HostRoutesGroup(root: self, port: nil, domainPath: subDomain.reversedDomainComponents))
    }
    
    public func grouped(reverseDomain: HostComponent..., configure: (HostRoutesBuilder) throws -> ()) rethrows {
        try configure(HostRoutesGroup(root: self, port: nil, domainPath: reverseDomain))
    }
    
    public func grouped(reverseDomain: [HostComponent], configure: (HostRoutesBuilder) throws -> ()) rethrows {
        try configure(HostRoutesGroup(root: self, port: nil, domainPath: reverseDomain))
    }
}
