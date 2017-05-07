import Foundation
import XCTest
import HTTP
import URI

@testable import AppLogic
@testable import Vapor


class TeamControllerTests: XCTestCase, DropletDatabaseTests {
    /// This is a requirement for XCTest on Linux to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testPostTeamResponse", testPostTeamResponse),
        ("testGetTeamsResponse", testGetTeamsResponse),
        ("testGetTeamIdResponse", testGetTeamIdResponse),
        ("testPatchTeamIdResponse", testPatchTeamIdResponse),
        ("testDeleteTeamIdResponse", testDeleteTeamIdResponse),
        ]
    
    var drop: Droplet!
    
    override func setUp() {
        super.setUp()
        
        drop = type(of: self).createDroplet()
        drop.collection(V1AdminCollection())
    }
    
    func testPostTeamResponse() throws {
        // arrange
        let post = try JSON(node: ["name": "name", "description": "desc"])
        
        // act
        let response = try dropResponse(method: .post, uri: "/admin/v1/teams", body: post.makeBody())
        let node = try Node(response: response)
        let teams = node?["teams"]?.nodeArray
        
        // assert
        XCTAssertEqual(response.status, .created)
        XCTAssertTrue(teams?.count == 1)
        
        let item = teams?.first
        XCTAssertTrue(item?["name"] == "name")
        XCTAssertTrue(item?["description"] == "desc")
        XCTAssertNotNil(item?["id"])
    }
    
    func testGetTeamsResponse() throws {
        // arrange
        try drop.database?.driver.raw("INSERT INTO `teams`(`id`,`name`,`description`) VALUES (1,'name','desc');")
        try drop.database?.driver.raw("INSERT INTO `teams`(`id`,`name`,`description`) VALUES (2,'name2','desc2');")
        
        // act
        let response = try dropResponse(method: .get, uri: "/admin/v1/teams")
        let node = try Node(response: response)
        let teams = node?["teams"]?.nodeArray
        
        // assert
        XCTAssertEqual(response.status, .ok)
        XCTAssertTrue(teams?.count == 2)
        
        let first = teams?[0]
        XCTAssertTrue(first?["id"] == 1)
        XCTAssertTrue(first?["name"] == "name")
        XCTAssertTrue(first?["description"] == "desc")
        
        let second = teams?[1]
        XCTAssertTrue(second?["id"] == 2)
        XCTAssertTrue(second?["name"] == "name2")
        XCTAssertTrue(second?["description"] == "desc2")
    }

    func testGetTeamIdResponse() throws {
        // arrange
        try drop.database?.driver.raw("INSERT INTO `teams`(`id`,`name`,`description`) VALUES (123,'name','desc');")
        
        // act
        let response = try dropResponse(method: .get, uri: "/admin/v1/teams/123")
        let node = try Node(response: response)
        let teams = node?["teams"]?.nodeArray

        // assert
        XCTAssertEqual(response.status, .ok)
        XCTAssertTrue(teams?.count == 1)
        
        let item = teams?.first
        XCTAssertTrue(item?["id"] == 123)
        XCTAssertTrue(item?["name"] == "name")
        XCTAssertTrue(item?["description"] == "desc")
    }
    
    func testPatchTeamIdResponse() throws {
        // arrange
        let post = try JSON(node: ["name": "newName", "description": "newDesc"])
        try drop.database?.driver.raw("INSERT INTO `teams`(`id`,`name`,`description`) VALUES (123,'oldName','oldDesc');")
        
        // act
        let response = try dropResponse(method: .patch, uri: "/admin/v1/teams/123", body: post.makeBody())
        let node = try Node(response: response)
        let teams = node?["teams"]?.nodeArray
        
        // assert
        XCTAssertEqual(response.status, .ok)
        
        let item = teams?.first
        XCTAssertTrue(item?["id"] == 123)
        XCTAssertTrue(item?["name"] == "newName")
        XCTAssertTrue(item?["description"] == "newDesc")
    }
    
    func testDeleteTeamIdResponse() throws {
        // arrange
        try drop.database?.driver.raw("INSERT INTO `teams`(`id`,`name`) VALUES (123,'name');")
        
        // act
        let response = try dropResponse(method: .delete, uri: "/admin/v1/teams/123")
        
        // assert
        XCTAssertEqual(response.status, .noContent)
        XCTAssertNotNil(response.body.bytes)
        if let bytes = response.body.bytes {
            XCTAssertTrue(bytes.isEmpty)
        }
    }
}
