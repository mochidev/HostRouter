/// Groups collections of routes together for adding to a router.
public protocol HostRouteCollection {
    /// Registers routes to the incoming router.
    ///
    /// - parameters:
    ///     - routes: `HostRoutesBuilder` to register any new routes to.
    func boot(routes: some HostRoutesBuilder) throws
}

extension HostRoutesBuilder {
    /// Registers all of the routes in the group to this router.
    ///
    /// - parameters:
    ///     - collection: `HostRouteCollection` to register.
    public func register(collection: some HostRouteCollection) throws {
        try collection.boot(routes: self)
    }
}
