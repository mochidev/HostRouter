import Vapor

public enum HostComponent: Sendable, Hashable, Comparable {
    case constant(String)
    case parameter(String)
    case anything
    case catchall
}

extension HostComponent: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        if value.hasPrefix(":") {
            self = .parameter(.init(value.dropFirst()))
        } else if value == "*" {
            self = .anything
        } else if value == "**" {
            self = .catchall
        } else {
            self = .constant(value)
        }
    }
}

extension HostComponent: CustomStringConvertible {
    public var description: String {
        switch self {
        case .anything:
            return "*"
        case .catchall:
            return "**"
        case .parameter(let name):
            return ":" + name
        case .constant(let constant):
            return constant
        }
    }
}

extension StringProtocol {
    /// Converts a host (either a domain or an IP address) into a reversed collection of ``HostComponent``s.
    public var reversedDomainComponents: [HostComponent] {
        guard !self.isIPAddress else { return [.constant(String(self))] }
        return self.split(separator: ".").reversed().map { .init(stringLiteral: $0.lowercased()) }
    }
    
    /// Retrieve the port and domain from the receiving Host string.
    var hostComponents: (port: String?, reverseDomain: [String]) {
        let baseComponents = self.split(separator: ":")
        let (host, port) = baseComponents.count == 2 ? (String(baseComponents[0]), String(baseComponents[1])) : (String(self), nil)
        
        return (port, host.split(separator: ".").reversed().map(String.init))
    }
    
    /// Check if the string is an IP address.
    private var isIPAddress: Bool {
        // TODO: This was unused in Vapor, and NIO may have a better helper for this.
        
        /// We need some scratch space to let inet_pton write into.
        var ipv4Addr = in_addr()
        var ipv6Addr = in6_addr()
        
        return self.withCString { ptr in
            return inet_pton(AF_INET, ptr, &ipv4Addr) == 1 || inet_pton(AF_INET6, ptr, &ipv6Addr) == 1
        }
    }
}
