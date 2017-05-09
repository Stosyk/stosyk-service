import Foundation
import PackageDescription


let addTestDependencies = ProcessInfo.processInfo.environment["SWIFTPM_TEST_TARGET"] == "YES"

let package = Package(
    name: "Stosyk",
    targets: [
        Target(name: "AppLogic"),
        Target(name: "App", dependencies: ["AppLogic"])
    ],
    dependencies: {
        var items: [Package.Dependency] = [
            .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 5),
            .Package(url: "https://github.com/vapor/postgresql-provider", majorVersion: 1, minor: 0)
        ]
        if addTestDependencies {
            items += [
                .Package(url: "https://github.com/vapor/sqlite-provider", majorVersion: 1, minor: 1)
            ]
        }
        return items
    }(),
    exclude: [
        "Config",
        "Localization",
        "Public",
        "Resources",
    ]
)

