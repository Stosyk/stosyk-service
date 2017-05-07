import Foundation
import XCTest
import HTTP
import URI
import VaporSQLite
import Fluent

@testable import Vapor
@testable import AppLogic


extension Droplet {
    static func testable() -> Droplet {
        let drop = Droplet(arguments: ["vapor", "prepare"])
        
        drop.collection(V1PublicCollection())
        drop.collection(V1ManageCollection())
        drop.collection(V1AdminCollection())
        
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
                      headers: [HeaderKey: String] = ["Content-Type":"application/json"],
                      body: Body = .data([])) throws -> Response {
        let drop = Droplet.testable()
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

protocol DropletTests {
    var drop: Droplet! { get }
}

extension DropletTests {
    static func createDroplet() -> Droplet {
        return Droplet(arguments: ["vapor", "prepare"])
    }
    
    func dropResponse(method: HTTP.Method,
                      uri: String,
                      headers: [HeaderKey: String] = [:],
                      body: Body = .data([])) throws -> Response {
        let drop = Droplet.testable()
        let request = try Request(method: method, uri: uri, headers: headers, body: body)
        
        return try drop.respond(to: request)
    }
}

protocol DropletDatabaseTests: DropletTests {
    var drop: Droplet! { get }
}

extension DropletDatabaseTests {
    static func createDroplet() -> Droplet {
        let drop = Droplet(arguments: ["vapor", "prepare"])
        let dbPath = drop.workDir + ".build/tests.sqlite"

        do {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: dbPath) {
                try fileManager.removeItem(atPath: dbPath)
            }
            
            let config = try Config(node: ["sqlite": ["path": dbPath.makeNode()]])
            let provider = try VaporSQLite.Provider(config: config)
            drop.addProvider(provider)
            
            let preparations: [Preparation.Type] = [Team.self,
                                                    User.self,
                                                    Admin.self]
            drop.preparations += preparations
            
            try drop.runCommands()
        } catch {
            print("🗃 \(error)")
        }
        
        return drop
    }
}




