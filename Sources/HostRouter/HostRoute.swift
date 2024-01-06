import Vapor

public struct HostRoute {
    /// The port we are routed under.
    ///
    /// Internal until Vapor properly supports multiple ports.
    internal var port: Int?
    
    /// The domain path, in reversed order.
    public var domainPath: [HostComponent]
    
    /// The route to follow after the host has been routed.
    public var route: Route
}
