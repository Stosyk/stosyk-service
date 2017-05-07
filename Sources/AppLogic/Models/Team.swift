import Vapor
import Fluent
import Foundation

final class Team: Model {
    enum Keys {
        static let table = "teams"
        static let id = "id"
        static let name = "name"
        static let description = "description"
    }
    
    var exists: Bool = false
    var id: Node?
    
    var name: String
    var description: String?
    
    init(node: Node, in context: Context) throws {
        name = try node.extract(Keys.name)
        description = try node.extract(Keys.description)
    }
}

// MARK: -

extension Team: NodeRepresentable {
    func makeNode(context: Context) throws -> Node {
        var node: [String: NodeConvertible] = [Keys.name: name]
        node[Keys.id] = id?.int
        node[Keys.description] = description
        return try Node(node: node)
    }
}

extension Team: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(Keys.table) { teams in
            teams.id()
            teams.string(Keys.name)
            teams.string(Keys.description, optional: true)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(Keys.table)
    }
}
