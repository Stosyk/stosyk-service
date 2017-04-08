import Foundation
import XCTest
import HTTP
@testable import AppLogic
@testable import Vapor


class RouteTests: XCTestCase {
    /// This is a requirement for XCTest on Linux
    /// to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testExample", testExample),
    ]

    func testExample() throws {
        XCTAssertNotNil(V1AdminCollection())
        XCTAssertNotNil(V1ManageCollection())
        XCTAssertNotNil(V1PublicCollection())
    }
}
