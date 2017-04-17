import Foundation
import XCTest
import HTTP
import URI

@testable import AppLogic
@testable import Vapor


class V1ManageCollectionTests: XCTestCase {
    /// This is a requirement for XCTest on Linux to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testPostProjectResponseStructure", testPostProjectResponseStructure),
        ("testGetProjectsResponseStructure", testGetProjectsResponseStructure),
        ("testGetProjectIdResponseStructure", testGetProjectIdResponseStructure),
        ("testPutProjectIdResponseStructure", testPutProjectIdResponseStructure),
        ("testDeleteProjectIdResponseStructure", testDeleteProjectIdResponseStructure),
        ("testPostTagResponseStructure", testPostTagResponseStructure),
        ("testGetTagsResponseStructure", testGetTagsResponseStructure),
        ("testGetTagIdResponseStructure", testGetTagIdResponseStructure),
        ("testPutTagIdResponseStructure", testPutTagIdResponseStructure),
        ("testDeleteTagIdResponseStructure", testDeleteTagIdResponseStructure)
        ]
    
    func testPostProjectResponseStructure() throws {
        let response = try dropResponse(method: .post, uri: "/manage/v1/projects")
        let node = try Node(response: response)
        
        XCTAssertEqual(response.status, .created)
        let items = node?["projects"]?.nodeArray
        XCTAssertTrue(items?.count == 1)
    }
    
    func testGetProjectsResponseStructure() throws {
        let response = try dropResponse(method: .get, uri: "/manage/v1/projects")
        let node = try Node(response: response)
        
        XCTAssertEqual(response.status, .ok)
        
        let meta = node?["_meta"]
        XCTAssertNodeContains(meta, ["limit", "offset", "total"])
        XCTAssertNodeContains(node, ["_meta", "projects"])
    }
    
    func testGetProjectIdResponseStructure() throws {
        let response = try dropResponse(method: .get, uri: "/manage/v1/projects/100")
        let node = try Node(response: response)
        
        XCTAssertEqual(response.status, .ok)
        
        let item = node?["projects"]?[0]
        XCTAssertTrue(item?["id"] == 100)
    }
    
    func testPutProjectIdResponseStructure() throws {
        let response = try dropResponse(method: .put, uri: "/manage/v1/projects/100")
        let node = try Node(response: response)
        
        XCTAssertEqual(response.status, .ok)
        
        let item = node?["projects"]?[0]
        XCTAssertTrue(item?["id"] == 100)
    }
    
    func testDeleteProjectIdResponseStructure() throws {
        let response = try dropResponse(method: .delete, uri: "/manage/v1/projects/100")
        
        XCTAssertEqual(response.status, .noContent)
        if let bytes = response.body.bytes {
            XCTAssertTrue(bytes.isEmpty)
        }
    }
    
    func testPostTagResponseStructure() throws {
        let response = try dropResponse(method: .post, uri: "/manage/v1/projects/100/tags")
        let node = try Node(response: response)
        
        XCTAssertEqual(response.status, .created)
        let items = node?["tags"]?.nodeArray
        XCTAssertTrue(items?.count == 1)
    }

    func testGetTagsResponseStructure() throws {
        let response = try dropResponse(method: .get, uri: "/manage/v1/projects/100/tags")
        let node = try Node(response: response)
        
        XCTAssertEqual(response.status, .ok)
        
        let meta = node?["_meta"]
        XCTAssertNodeContains(meta, ["limit", "offset", "total"])
        XCTAssertNodeContains(node, ["_meta", "tags"])
    }
    
    func testGetTagIdResponseStructure() throws {
        let response = try dropResponse(method: .get, uri: "/manage/v1/projects/100/tags/100")
        let node = try Node(response: response)
        
        XCTAssertEqual(response.status, .ok)
        
        let item = node?["tags"]?[0]
        XCTAssertTrue(item?["id"] == 100)
    }
    
    func testPutTagIdResponseStructure() throws {
        let response = try dropResponse(method: .put, uri: "/manage/v1/projects/100/tags/100")
        let node = try Node(response: response)
        
        XCTAssertEqual(response.status, .ok)
        
        let item = node?["tags"]?[0]
        XCTAssertTrue(item?["id"] == 100)
    }
    
    func testDeleteTagIdResponseStructure() throws {
        let response = try dropResponse(method: .delete, uri: "/manage/v1/projects/100/tags/100")
        
        XCTAssertEqual(response.status, .noContent)
        if let bytes = response.body.bytes {
            XCTAssertTrue(bytes.isEmpty)
        }
    }
    
}
