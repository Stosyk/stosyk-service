import Vapor
import HTTP


final class TeamController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try containerFor(items: Team.all()).converted(to: JSON.self)
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var team = try request.team()
        try team.save()
        let container = try containerFor(items: [team])
        return try Response(status: .created, json: JSON(node: container))
    }
    
    func show(request: Request, team: Team) throws -> ResponseRepresentable {
        let container = try containerFor(items: [team])
        return try JSON(node: container)
    }
    
    func delete(request: Request, team: Team) throws -> ResponseRepresentable {
        try team.delete()
        return Response(status: .noContent, body: .data([]))
    }
    
    func update(request: Request, team: Team) throws -> ResponseRepresentable {
        guard let data = request.json?.node else { throw Abort.badRequest }
        var team = team
        if let name = data[Team.Key.name]?.string, !name.isEmpty {
            team.name = name
        }
        if let description = data[Team.Key.description]?.string, !description.isEmpty {
            team.description = description
        }

        try team.save()
        let container = try containerFor(items: [team])
        return try JSON(node: container)
    }
    
    private func containerFor(items: [Team], meta: [String: Int]? = nil) throws -> Node {
        var result = [Team.Key.table: try items.makeNode()]
        if meta != nil {
            result["_meta"] = try meta?.makeNode()
        }
        return .object(result)
    }
    
    func makeResource() -> Resource<Team> {
        return Resource(
            index: index,
            store: create,
            show: show,
            modify: update,
            destroy: delete
        )
    }
}

fileprivate extension Request {
    func team() throws -> Team {
        guard let json = json else { throw Abort.badRequest }
        return try Team(node: json)
    }
}
