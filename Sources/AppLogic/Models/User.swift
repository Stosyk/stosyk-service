import Vapor
import Fluent

final class User: Model {
    enum Key {
        static let table = "users"
        static let id = "id"
        static let name = "name"
        static let email = "email"
    }
    
    var exists: Bool = false
    var id: Node?
    
    var name: String
    var email: String
    
    init(node: Node, in context: Context) throws {
        name = try node.extract(Key.name)
        email = try node.extract(Key.email)
    }
}

// MARK: -

extension User: NodeRepresentable {
    func makeNode(context: Context) throws -> Node {
        var node: [String: NodeConvertible] = [Key.name: name, Key.email: email]
        node[Key.id] = id?.int
        return try Node(node: node)
    }
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(Key.table) { users in
            users.id()
            users.string(Key.name)
            users.string(Key.email)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(Key.table)
    }
}
