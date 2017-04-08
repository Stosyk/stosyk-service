import Foundation
import XCTest
import HTTP
import URI

@testable import Vapor
@testable import AppLogic


extension Droplet {
    static func testable() throws -> Droplet {
        let drop = Droplet(arguments: ["vapor", "prepare"])
        try AppLogic.setup(drop)
        try drop.runCommands()
        return drop
    }
    
    // Must be served to activate
    static func live() throws -> Droplet {
        let drop = Droplet(arguments: ["vapor", "serve"])
        try AppLogic.setup(drop)
        return drop
    }
}

extension XCTestCase {
    public func XCTAssertNodeContains(_ node: Node?, _ items: [String], file: StaticString = #file, line: UInt = #line) {
        for item in items {
            XCTAssertNotNil(node?[item], file: file, line: line)
        }
    }
    
    func dropResponse(method: HTTP.Method,
                      uri: String,
                      headers: [HeaderKey: String] = [:],
                      body: Body = .data([])) throws -> Response {
        let drop = try Droplet.testable()
        let request = try Request(method: method, uri: uri, headers: headers, body: body)
        
        return try drop.respond(to: request)
    }
}

extension Node {
    init?(response: Response) throws {
        guard let bytes = response.body.bytes else { return nil }
        self = try JSON(bytes: bytes).node
    }
}
