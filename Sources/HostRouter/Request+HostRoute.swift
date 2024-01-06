import Vapor 

extension Request {
    private struct HostRouteKey: StorageKey {
        typealias Value = HostRoute
    }
    
    private struct HostParametersKey: StorageKey {
        typealias Value = Parameters
    }
    
    public var hostRoute: HostRoute {
        get {
            guard let route = self.storage[HostRouteKey.self] else {
                // TODO: Consider making HostRoute.route optional
                return HostRoute(
                    port: nil,
                    domainPath: [.catchall],
                    route: self.route ?? Route(
                        method: method,
                        path: [.catchall],
                        responder: application.responder,
                        requestType: Never.self,
                        responseType: Never.self
                    )
                )
            }
            return route
        }
        set {
            self.storage[HostRouteKey.self] = newValue
        }
    }
    
    /// The parameters matched within the Host of the request.
    ///
    /// For default routes, `"port"` will always match the public port number, and ``Parameters.getCatchall()`` will return the domain path in reversed order (ie. top-level domain first)
    public var hostParameters: Parameters {
        get {
            if let parameters = self.storage[HostParametersKey.self] {
                return parameters
            }
            
            let host = self.headers[.host].first ?? ""
            let (port, domainPath) = host.hostComponents
            
            /// Set reasonable defaults if we are making hostParameters on the fly.
            var parameters = Parameters()
            parameters.setCatchall(matched: domainPath)
            if let port {
                parameters.set("port", to: port)
            } else if self.application.http.server.shared.configuration.tlsConfiguration != nil {
                parameters.set("port", to: "443")
            } else {
                parameters.set("port", to: "80")
            }
            self.storage[HostParametersKey.self] = parameters
            return parameters
        }
        set {
            self.storage[HostParametersKey.self] = newValue
        }
    }
}
