import Vapor

public protocol HostRoutesBuilder: RoutesBuilder {
    func add(_ route: HostRoute)
}

public protocol TopLevelHostRoutesBuilder: HostRoutesBuilder {}

extension HostRoutesBuilder {
    public func add(_ route: Route) {
        add(HostRoute(port: nil, domainPath: [], route: route))
    }
}
