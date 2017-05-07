import Foundation
import XCTest
import HTTP
import URI

@testable import AppLogic
@testable import Vapor


class AdminControllerTests: XCTestCase, DropletDatabaseTests {
    /// This is a requirement for XCTest on Linux to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testPostAdminResponse", testPostAdminResponse),
        ("testGetAdminsResponse", testGetAdminsResponse),
        ("testGetAdminIdResponse", testGetAdminIdResponse),
        ("testPatchAdminIdResponse", testPatchAdminIdResponse),
        ("testDeleteAdminIdResponse", testDeleteAdminIdResponse),
        ]
    
    var drop: Droplet!
    
    override func setUp() {
        super.setUp()
        
        drop = type(of: self).createDroplet()
        drop.collection(V1AdminCollection())
    }
    
    func testPostAdminResponse() throws {
        // arrange
        let post = try JSON(node: ["name": "name", "email": "a@mail.net"])
        
        // act
        let response = try dropResponse(method: .post, uri: "/admin/v1/admins", body: post.makeBody())
        let node = try Node(response: response)
        let items = node?["admins"]?.nodeArray
        
        // assert
        XCTAssertEqual(response.status, .created)
        XCTAssertTrue(items?.count == 1)
        
        let item = items?.first
        XCTAssertTrue(item?["name"] == "name")
        XCTAssertTrue(item?["email"] == "a@mail.net")
        XCTAssertNotNil(item?["id"])
    }
    
    func testGetAdminsResponse() throws {
        // arrange
        try drop.database?.driver.raw("INSERT INTO `admins`(`id`,`name`,`email`) VALUES (1,'name','a@mail.net');")
        try drop.database?.driver.raw("INSERT INTO `admins`(`id`,`name`,`email`) VALUES (2,'name2','b@mail.net');")
        
        // act
        let response = try dropResponse(method: .get, uri: "/admin/v1/admins")
        let node = try Node(response: response)
        let items = node?["admins"]?.nodeArray
        
        // assert
        XCTAssertEqual(response.status, .ok)
        XCTAssertTrue(items?.count == 2)
        
        let first = items?[0]
        XCTAssertTrue(first?["id"] == 1)
        XCTAssertTrue(first?["name"] == "name")
        XCTAssertTrue(first?["email"] == "a@mail.net")
        
        let second = items?[1]
        XCTAssertTrue(second?["id"] == 2)
        XCTAssertTrue(second?["name"] == "name2")
        XCTAssertTrue(second?["email"] == "b@mail.net")
    }

    func testGetAdminIdResponse() throws {
        // arrange
        try drop.database?.driver.raw("INSERT INTO `admins`(`id`,`name`,`email`) VALUES (123,'name','a@mail.net');")
        
        // act
        let response = try dropResponse(method: .get, uri: "/admin/v1/admins/123")
        let node = try Node(response: response)
        let items = node?["admins"]?.nodeArray

        // assert
        XCTAssertEqual(response.status, .ok)
        XCTAssertTrue(items?.count == 1)
        
        let item = items?.first
        XCTAssertTrue(item?["id"] == 123)
        XCTAssertTrue(item?["name"] == "name")
        XCTAssertTrue(item?["email"] == "a@mail.net")
    }
    
    func testPatchAdminIdResponse() throws {
        // arrange
        let post = try JSON(node: ["name": "newName", "email": "bcd@mail.net"])
        try drop.database?.driver.raw("INSERT INTO `admins`(`id`,`name`,`email`) VALUES (123,'name','a@mail.net');")
        
        // act
        let response = try dropResponse(method: .patch, uri: "/admin/v1/admins/123", body: post.makeBody())
        let node = try Node(response: response)
        let items = node?["admins"]?.nodeArray
        
        // assert
        XCTAssertEqual(response.status, .ok)
        XCTAssertTrue(items?.count == 1)
        
        let item = items?.first
        XCTAssertTrue(item?["id"] == 123)
        XCTAssertTrue(item?["name"] == "newName")
        XCTAssertTrue(item?["email"] == "bcd@mail.net")
    }
    
    func testDeleteAdminIdResponse() throws {
        // arrange
        try drop.database?.driver.raw("INSERT INTO `admins`(`id`,`name`,`email`) VALUES (123,'name','a@mail.net');")
        
        // act
        let response = try dropResponse(method: .delete, uri: "/admin/v1/admins/123")
        
        // assert
        XCTAssertEqual(response.status, .noContent)
        XCTAssertNotNil(response.body.bytes)
        if let bytes = response.body.bytes {
            XCTAssertTrue(bytes.isEmpty)
        }
    }
}
