import Vapor

typealias HostPrefix = [PathComponent]

struct HostRoutes {
    var routes: [HostRoute] = []
    var routerMap: [HostPrefix : TrieRouter<HostRoute>] = [:]
    private var hostRouter = TrieRouter(HostPrefix.self, options: [])
    private var catchallHostRouter = TrieRouter(HostPrefix.self, options: [])
    
    mutating func add(_ hostRoute: HostRoute) {
        routes.append(hostRoute)
        
        let registeredPrefix = hostRoute.prefix
        if routerMap[registeredPrefix] == nil {
            routerMap[registeredPrefix] = TrieRouter()
            hostRouter.register(registeredPrefix, at: registeredPrefix)
            if registeredPrefix.contains(.catchall) {
                catchallHostRouter.register(registeredPrefix, at: registeredPrefix)
            }
        }
        
        let resourceRoute = hostRoute.route
        
        /// Remove any empty path components
        let path = resourceRoute.path.filter { component in
            switch component {
            case .constant(let string):
                return !string.isEmpty
            default:
                return true
            }
        }
        
        /// If the route isn't explicitly a HEAD route, and it's made up solely of .constant components, register a HEAD route with the same path.
        if resourceRoute.method == .GET, resourceRoute.path.allSatisfy(\.isConstant) {
            let headRoute = Route(
                method: .HEAD,
                path: resourceRoute.path,
                responder: HeadResponder(),
                requestType: resourceRoute.requestType,
                responseType: resourceRoute.responseType)
            
            var hostHeadRoute = hostRoute
            hostHeadRoute.route = headRoute

            routerMap[registeredPrefix]?.register(hostHeadRoute, at: [.constant(HTTPMethod.HEAD.string)] + path)
        }
        
        routerMap[registeredPrefix]?.register(hostRoute, at: [.constant(resourceRoute.method.string)] + path)
    }
    
    func resourceRouter(for host: String, defaultPort: String, router: TrieRouter<HostPrefix>) -> (TrieRouter<HostRoute>, Parameters)? {
        let (port, domainPath) = host.hostComponents
        
        var hostParameters = Parameters()
        hostParameters.set("port", to: port ?? defaultPort)
        
        guard
            let hostPrefix = router.route(path: [port ?? defaultPort] + domainPath, parameters: &hostParameters),
            let resourceRouter = routerMap[hostPrefix]
        else { return nil }
        
        return (resourceRouter, hostParameters)
    }
    
    func route(for request: Request, router: TrieRouter<HostPrefix>? = nil) -> HostRoute? {
        let defaultPort = request.application.http.server.shared.configuration.tlsConfiguration != nil ? "443" : "80"
        
        guard
            let host = request.headers[.host].first,
            let (resourceRouter, hostParameters) = resourceRouter(for: host, defaultPort: defaultPort, router: router ?? hostRouter)
        else { return nil }
        
        let resourceComponents = request.url.path
            .split(separator: "/")
            .map(String.init)
        
        /// If it's a HEAD request and a HEAD route exists, return that route...
        if request.method == .HEAD, let hostRoute = resourceRouter.route(
            path: [HTTPMethod.HEAD.string] + resourceComponents,
            parameters: &request.parameters
        ) {
            request.route = hostRoute.route
            request.hostRoute = hostRoute
            request.hostParameters = hostParameters
            return hostRoute
        }

        /// ...otherwise forward HEAD requests to GET route
        let method = (request.method == .HEAD) ? .GET : request.method
        
        if let hostRoute = resourceRouter.route(
            path: [method.string] + resourceComponents,
            parameters: &request.parameters
        ) {
            request.route = hostRoute.route
            request.hostRoute = hostRoute
            request.hostParameters = hostParameters
            return hostRoute
        }
        
        if router == nil {
            // Not a perfect solution, but should identify routes on a catchall host. A second version might use a boundary with a single path combining domain and resource paths, but that can be explored if this is not enough
            return route(for: request, router: catchallHostRouter)
        }
        
        return nil
    }
}

private extension HostRoute {
    var prefix: [PathComponent] {
        [port.map { .constant(String($0)) } ?? .anything] + domainPath.compactMap { component in
            switch component {
            case .constant(let string) where string.isEmpty: nil
            case .constant(let string): .constant(string.lowercased())
            case .parameter(let string): .parameter(string)
            case .anything: .anything
            case .catchall: .catchall
            }
        }
    }
}

private extension PathComponent {
    var isConstant: Bool {
        if case .constant = self { return true }
        return false
    }
}

private struct HeadResponder: Responder {
    func respond(to request: Request) -> EventLoopFuture<Response> {
        request.eventLoop.makeSucceededFuture(.init(status: .ok))
    }
}
