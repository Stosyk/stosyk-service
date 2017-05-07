import Foundation
import XCTest
import HTTP
import URI

@testable import AppLogic
@testable import Vapor


class UserControllerTests: XCTestCase, DropletDatabaseTests {
    /// This is a requirement for XCTest on Linux to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testPostUserResponse", testPostUserResponse),
        ("testGetUsersResponse", testGetUsersResponse),
        ("testGetUserIdResponse", testGetUserIdResponse),
        ("testPatchUserIdResponse", testPatchUserIdResponse),
        ("testDeleteUserIdResponse", testDeleteUserIdResponse),
        ]
    
    var drop: Droplet!
    
    override func setUp() {
        super.setUp()
        
        drop = type(of: self).createDroplet()
        drop.collection(V1AdminCollection())
    }
    
    func testPostUserResponse() throws {
        // arrange
        let post = try JSON(node: ["name": "name", "email": "a@mail.net"])
        
        // act
        let response = try dropResponse(method: .post, uri: "/admin/v1/users", body: post.makeBody())
        let node = try Node(response: response)
        let items = node?["users"]?.nodeArray
        
        // assert
        XCTAssertEqual(response.status, .created)
        XCTAssertTrue(items?.count == 1)
        
        let item = items?.first
        XCTAssertTrue(item?["name"] == "name")
        XCTAssertTrue(item?["email"] == "a@mail.net")
        XCTAssertNotNil(item?["id"])
    }
    
    func testGetUsersResponse() throws {
        // arrange
        try drop.database?.driver.raw("INSERT INTO `users`(`id`,`name`,`email`) VALUES (1,'name','a@mail.net');")
        try drop.database?.driver.raw("INSERT INTO `users`(`id`,`name`,`email`) VALUES (2,'name2','b@mail.net');")
        
        // act
        let response = try dropResponse(method: .get, uri: "/admin/v1/users")
        let node = try Node(response: response)
        let items = node?["users"]?.nodeArray
        
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

    func testGetUserIdResponse() throws {
        // arrange
        try drop.database?.driver.raw("INSERT INTO `users`(`id`,`name`,`email`) VALUES (123,'name','a@mail.net');")
        
        // act
        let response = try dropResponse(method: .get, uri: "/admin/v1/users/123")
        let node = try Node(response: response)
        let items = node?["users"]?.nodeArray

        // assert
        XCTAssertEqual(response.status, .ok)
        XCTAssertTrue(items?.count == 1)
        
        let item = items?.first
        XCTAssertTrue(item?["id"] == 123)
        XCTAssertTrue(item?["name"] == "name")
        XCTAssertTrue(item?["email"] == "a@mail.net")
    }
    
    func testPatchUserIdResponse() throws {
        // arrange
        let post = try JSON(node: ["name": "newName", "email": "bcd@mail.net"])
        try drop.database?.driver.raw("INSERT INTO `users`(`id`,`name`,`email`) VALUES (123,'name','a@mail.net');")
        
        // act
        let response = try dropResponse(method: .patch, uri: "/admin/v1/users/123", body: post.makeBody())
        let node = try Node(response: response)
        let items = node?["users"]?.nodeArray
        
        // assert
        XCTAssertEqual(response.status, .ok)
        XCTAssertTrue(items?.count == 1)
        
        let item = items?.first
        XCTAssertTrue(item?["id"] == 123)
        XCTAssertTrue(item?["name"] == "newName")
        XCTAssertTrue(item?["email"] == "bcd@mail.net")
    }
    
    func testDeleteUserIdResponse() throws {
        // arrange
        try drop.database?.driver.raw("INSERT INTO `users`(`id`,`name`,`email`) VALUES (123,'name','a@mail.net');")
        
        // act
        let response = try dropResponse(method: .delete, uri: "/admin/v1/users/123")
        
        // assert
        XCTAssertEqual(response.status, .noContent)
        XCTAssertNotNil(response.body.bytes)
        if let bytes = response.body.bytes {
            XCTAssertTrue(bytes.isEmpty)
        }
    }
}
