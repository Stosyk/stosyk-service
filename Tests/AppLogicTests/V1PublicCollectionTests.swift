import Foundation
import XCTest
import HTTP
import URI

@testable import AppLogic
@testable import Vapor


class V1PublicCollectionTests: XCTestCase {
    /// This is a requirement for XCTest on Linux to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testGetProjectsResponseStructure", testGetProjectsResponseStructure),
        ("testGetProjectsSinceResponseStructure", testGetProjectsSinceResponseStructure),
        ("testGetProjectIdResponseStructure", testGetProjectIdResponseStructure),
        ("testGetTranslationsResponseStructure", testGetTranslationsResponseStructure),
        ("testGetTranslationsSinceResponseStructure", testGetTranslationsSinceResponseStructure)
        ]
    
    func testGetProjectsResponseStructure() throws {
        let response = try dropResponse(method: .get, uri: "/v1/projects")
        let node = try Node(response: response)
        
        XCTAssertEqual(response.status, .ok)
        
        let meta = node?["_meta"]
        XCTAssertNodeContains(meta, ["limit", "offset", "total"])
        XCTAssertNodeContains(node, ["_meta", "projects"])
    }
    
    func testGetProjectsSinceResponseStructure() throws {
        let response = try dropResponse(method: .get, uri: "/v1/projects?since=123321")
        let node = try Node(response: response)
        
        XCTAssertEqual(response.status, .ok)
        
        let meta = node?["_meta"]
        XCTAssertNodeContains(meta, ["limit", "offset", "total", "since"])
        XCTAssertNodeContains(node, ["_meta", "projects"])
        XCTAssertTrue(meta?["since"] == 123321)
    }
    
    func testGetProjectIdResponseStructure() throws {
        let response = try dropResponse(method: .get, uri: "/v1/projects/100")
        let node = try Node(response: response)
        
        XCTAssertEqual(response.status, .ok)
        
        let project = node?["projects"]?[0]
        XCTAssertTrue(project?["id"] == 100)
    }
    
    func testGetTranslationsResponseStructure() throws {
        let response = try dropResponse(method: .get, uri: "/v1/projects/1/translations/en")
        let node = try Node(response: response)
        
        XCTAssertEqual(response.status, .ok)
        
        let meta = node?["_meta"]
        XCTAssertNodeContains(meta, ["total"])
        XCTAssertNodeContains(node, ["_meta", "translations"])
    }
    
    func testGetTranslationsSinceResponseStructure() throws {
        let response = try dropResponse(method: .get, uri: "/v1/projects/1/translations/en?since=123321")
        let node = try Node(response: response)
        
        XCTAssertEqual(response.status, .ok)
        
        let meta = node?["_meta"]
        XCTAssertNodeContains(meta, ["total", "since"])
        XCTAssertNodeContains(node, ["_meta", "translations"])
        XCTAssertTrue(meta?["since"] == 123321)
    }
}
