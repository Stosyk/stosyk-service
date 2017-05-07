import Vapor
import Fluent
import Foundation

final class Team: Model {
    enum Key {
        static let table = "teams"
        static let id = "id"
        static let name = "name"
        static let description = "description"
    }
    
    var exists: Bool = false
    var id: Node?
    
    var name: String
    var description: String?
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
    
    // NodeInitializable
    
    init(node: Node, in context: Context) throws {
        name = try node.extract(Key.name)
        description = try node.extract(Key.description)
    }
}

// MARK: -

extension Team: NodeRepresentable {
    func makeNode(context: Context) throws -> Node {
        var node: [String: NodeConvertible] = [Key.name: name]
        node[Key.id] = id?.int
        node[Key.description] = description
        return try Node(node: node)
    }
}

extension Team: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(Key.table) { teams in
            teams.id()
            teams.string(Key.name)
            teams.string(Key.description, optional: true)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(Key.table)
    }
}
