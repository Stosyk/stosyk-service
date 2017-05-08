import Foundation
import XCTest
import HTTP
@testable import AppLogic
@testable import Vapor


class RouteTests: XCTestCase, DropletTests {
    /// This is a requirement for XCTest on Linux
    /// to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testV1Collections", testV1Collections),
        ("testCORSMiddlewareConnection", testCORSMiddlewareConnection)
    ]
    
    var drop: Droplet!
    
    override func setUp() {
         super.setUp()
        
        drop = type(of: self).createDroplet()
    }
    
    func testV1Collections() {
        XCTAssertNotNil(V1AdminCollection())
        XCTAssertNotNil(V1ManageCollection())
        XCTAssertNotNil(V1PublicCollection())
    }
    
    func testCORSMiddlewareConnection() throws {
        try? AppLogic.setup(drop)
        
        var found = false
        for item in drop.middleware where item is CORSMiddleware { found = true }
        
        XCTAssertTrue(found)
        
    }
}
