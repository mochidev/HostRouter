import Vapor

/// A middleware that will group routes it owns under the specified host or subdomain.
///
/// Heavily inspired by https://github.com/vapor/vapor/issues/2745#issuecomment-1450795410 and Vapor's internal DefaultResponder.
public struct HostRouter: AsyncMiddleware {
    public func respond(to request: Vapor.Request, chainingTo next: Vapor.AsyncResponder) async throws -> Vapor.Response {
        
        let hostRoutes = request.application.hostRoutes
        
        if let cachedRoute = hostRoutes.route(for: request) {
            return try await cachedRoute.route.responder.respond(to: request).get()
        }
        
        return try await next.respond(to: request)
    }
}
