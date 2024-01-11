# HostRouter

<p align="center">
    <a href="https://swiftpackageindex.com/mochidev/HostRouter">
        <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmochidev%2FHostRouter%2Fbadge%3Ftype%3Dswift-versions" />
    </a>
    <a href="https://swiftpackageindex.com/mochidev/HostRouter">
        <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmochidev%2FHostRouter%2Fbadge%3Ftype%3Dplatforms" />
    </a>
    <a href="https://github.com/mochidev/HostRouter/actions?query=workflow%3A%22Test+HostRouter%22">
        <img src="https://github.com/mochidev/HostRouter/workflows/Test%20HostRouter/badge.svg" alt="Test Status" />
    </a>
</p>

A [Vapor](https://vapor.codes) middleware for including the domain in routing.

## Quick Links

- [Documentation](https://swiftpackageindex.com/mochidev/HostRouter/documentation)
- [Updates on Mastodon](https://mastodon.social/tags/HostRouter)

## Installation

Add `HostRouter` as a dependency in your `Package.swift` file to start using it. Then, add `import HostRouter` to any file you wish to use the library in.

Please check the [releases](https://github.com/mochidev/HostRouter/releases) for recommended versions.

```swift
dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", from: "4.90.0"),
    .package(url: "https://github.com/mochidev/HostRouter.git", .upToNextMinor(from: "0.2.0")),
],
...
targets: [
    .executableTarget(
        name: "MyPackage",
        dependencies: [
            .product(name: "Vapor", package: "vapor")
            .product(name: "HostRouter", package: "HostRouter")
        ]
    )
]
```

## What is `HostRouter`?

`HostRouter` extends Vapor's routing capabilities by allowing you to include routes for the host domain along with the resource. This makes it easy to partition a domain running on a single server with dynamic routing for different users or services.

`Host Router` was heavily inspired by by a [post](https://github.com/vapor/vapor/issues/2745#issuecomment-1450795410) by @andreasley on the Vapor repo, along with Vapor's own [`DefaultResponder`](https://github.com/vapor/vapor/blob/main/Sources/Vapor/Responder/DefaultResponder.swift).

## Contributing

Contribution is welcome! Please take a look at the issues already available, or start a new discussion to propose a new feature. Although guarantees can't be made regarding feature requests, PRs that fit within the goals of the project and that have been discussed beforehand are more than welcome!

Please make sure that all submissions have clean commit histories, are well documented, and thoroughly tested. **Please rebase your PR** before submission rather than merge in `main`. Linear histories are required, so merge commits in PRs will not be accepted.

## Support

To support this project, consider following [@dimitribouniol](https://mastodon.social/@dimitribouniol) on Mastodon, listening to Spencer and Dimitri on [Code Completion](https://mastodon.social/@codecompletion), or downloading Dimitri's wife Linh's app, [Not Phở](https://notpho.app/).
