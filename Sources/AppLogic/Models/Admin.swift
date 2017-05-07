import Vapor
import Fluent

final class Admin: Model {
    enum Keys {
        static let table = "admins"
        static let id = "id"
        static let name = "name"
        static let email = "email"
    }
    
    var exists: Bool = false
    var id: Node?
    
    var name: String
    var email: String
    
    init(node: Node, in context: Context) throws {
        name = try node.extract(Keys.name)
        email = try node.extract(Keys.email)
    }
}

// MARK: -

extension Admin: NodeRepresentable {
    func makeNode(context: Context) throws -> Node {
        var node: [String: NodeConvertible] = [Keys.name: name, Keys.email: email]
        node[Keys.id] = id?.int
        return try Node(node: node)
    }
}

extension Admin: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(Keys.table) { users in
            users.id()
            users.string(Keys.name)
            users.string(Keys.email)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(Keys.table)
    }
}
