import Vapor
import HTTP


final class UserController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try containerFor(items: User.all()).converted(to: JSON.self)
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        var user = try User(node: json)
        try user.save()
        let container = try containerFor(items: [user])
        return try Response(status: .created, json: JSON(node: container))
    }
    
    func show(request: Request, user: User) throws -> ResponseRepresentable {
        let container = try containerFor(items: [user])
        return try JSON(node: container)
    }
    
    func delete(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return Response(status: .noContent, body: .data([]))
    }
    
    func update(request: Request, user: User) throws -> ResponseRepresentable {
        guard let data = request.json?.node else { throw Abort.badRequest }
        var user = user
        if let name = data[User.Keys.name]?.string, !name.isEmpty {
            user.name = name
        }
        if let email = data[User.Keys.email]?.string, !email.isEmpty {
            user.email = email
        }

        try user.save()
        let container = try containerFor(items: [user])
        return try JSON(node: container)
    }
    
    private func containerFor(items: [User], meta: [String: Int]? = nil) throws -> Node {
        var result = [User.Keys.table: try items.makeNode()]
        if meta != nil {
            result["_meta"] = try meta?.makeNode()
        }
        return .object(result)
    }
    
    func makeResource() -> Resource<User> {
        return Resource(
            index: index,
            store: create,
            show: show,
            modify: update,
            destroy: delete
        )
    }
}
