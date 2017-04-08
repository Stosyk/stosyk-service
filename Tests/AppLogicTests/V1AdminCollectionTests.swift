import Foundation
import XCTest
import HTTP
import URI

@testable import AppLogic
@testable import Vapor


class V1AdminCollectionTests: XCTestCase {
    /// This is a requirement for XCTest on Linux to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testPostTeamResponseStructure", testPostTeamResponseStructure),
        ("testGetTeamsResponseStructure", testGetTeamsResponseStructure),
        ("testGetTeamIdResponseStructure", testGetTeamIdResponseStructure),
        ("testPutTeamIdResponseStructure", testPutTeamIdResponseStructure),
        ("testDeleteTeamIdResponseStructure", testDeleteTeamIdResponseStructure),
        ]
    
    func testPostTeamResponseStructure() throws {
        let response = try dropResponse(method: .post, uri: "/admin/v1/teams")
        let node = try Node(response: response)
        
        XCTAssertEqual(response.status, .created)
        let items = node?["teams"]?.nodeArray
        XCTAssertTrue(items?.count == 1)
    }
    
    func testGetTeamsResponseStructure() throws {
        let response = try dropResponse(method: .get, uri: "/admin/v1/teams")
        let node = try Node(response: response)
        
        XCTAssertEqual(response.status, .ok)
        
        let meta = node?["_meta"]
        XCTAssertNodeContains(meta, ["limit", "offset", "total"])
        XCTAssertNodeContains(node, ["_meta", "teams"])
    }
    
    func testGetTeamIdResponseStructure() throws {
        let response = try dropResponse(method: .get, uri: "/admin/v1/teams/100")
        let node = try Node(response: response)
        
        XCTAssertEqual(response.status, .ok)
        
        let item = node?["teams"]?[0]
        XCTAssertTrue(item?["id"] == 100)
    }
    
    func testPutTeamIdResponseStructure() throws {
        let response = try dropResponse(method: .put, uri: "/admin/v1/teams/100")
        let node = try Node(response: response)
        
        XCTAssertEqual(response.status, .ok)
        
        let item = node?["teams"]?[0]
        XCTAssertTrue(item?["id"] == 100)
    }
    
    func testDeleteTeamIdResponseStructure() throws {
        let response = try dropResponse(method: .delete, uri: "/admin/v1/teams/100")
        
        XCTAssertEqual(response.status, .noContent)
        if let bytes = response.body.bytes {
            XCTAssertTrue(bytes.isEmpty)
        }
    }
}
