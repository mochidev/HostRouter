import Vapor

public protocol HostRoutesBuilder: Sendable, RoutesBuilder {
    func add(_ route: HostRoute)
}

public protocol TopLevelHostRoutesBuilder: Sendable, HostRoutesBuilder {}

extension HostRoutesBuilder {
    public func add(_ route: Route) {
        add(HostRoute(port: nil, domainPath: [], route: route))
    }
}
