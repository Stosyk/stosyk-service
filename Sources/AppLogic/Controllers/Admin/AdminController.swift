import Vapor
import HTTP


final class AdminController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try containerFor(items: Admin.all()).converted(to: JSON.self)
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        var item = try Admin(node: json)
        try item.save()
        let container = try containerFor(items: [item])
        return try Response(status: .created, json: JSON(node: container))
    }
    
    func show(request: Request, item: Admin) throws -> ResponseRepresentable {
        let container = try containerFor(items: [item])
        return try JSON(node: container)
    }
    
    func delete(request: Request, item: Admin) throws -> ResponseRepresentable {
        try item.delete()
        return Response(status: .noContent, body: .data([]))
    }
    
    func update(request: Request, item: Admin) throws -> ResponseRepresentable {
        guard let data = request.json?.node else { throw Abort.badRequest }
        var item = item
        if let name = data[Admin.Keys.name]?.string, !name.isEmpty {
            item.name = name
        }
        if let email = data[Admin.Keys.email]?.string, !email.isEmpty {
            item.email = email
        }

        try item.save()
        let container = try containerFor(items: [item])
        return try JSON(node: container)
    }
    
    private func containerFor(items: [Admin], meta: [String: Int]? = nil) throws -> Node {
        var result = [Admin.Keys.table: try items.makeNode()]
        if meta != nil {
            result["_meta"] = try meta?.makeNode()
        }
        return .object(result)
    }
    
    func makeResource() -> Resource<Admin> {
        return Resource(
            index: index,
            store: create,
            show: show,
            modify: update,
            destroy: delete
        )
    }
}
