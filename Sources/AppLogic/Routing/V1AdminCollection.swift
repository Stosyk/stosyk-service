import Vapor
import HTTP
import Routing

/**
 Routes for `/admin` service
 */
class V1AdminCollection: RouteCollection {
    typealias Wrapped = HTTP.Responder
    func build<B: RouteBuilder>(_ builder: B) where B.Value == Wrapped {
        let v1 = builder.grouped("admin/v1")
        
        /**
         Routes group for `/admin/v1/teams`
         */
        v1.group("teams") { teams in
            func teamStub(id: Node) -> Node {
                // TODO: Remove after implementation
                return .object([
                    "id": id,
                    "name": "StubTeam"
                    ])
            }
            
            /**
             Create new team
             
             `POST: /teams`
             
             - Parameter <body>:    JSON with values.
             
             - Returns 201: Created team
             */
            teams.post { request in
                return try Response(status: .created, json: JSON(node: [
                    "teams": [
                        teamStub(id: 2)
                    ]]))
            }
            
            /**
             Get all teams
             
             `GET: /teams`
             
             - Returns 200: List of teams
             */
            teams.get { request in
                return try JSON(node: [
                    "teams": [
                        teamStub(id: 1),
                        teamStub(id: 2)
                    ],
                    "_meta": ["total": 2, "limit": 10, "offset": 0]
                    ])
            }
            
            /**
             Get team with `id`
             
             `GET: /teams/<id>`
             
             - Parameter id:    Int identifier of a team.
             
             - Returns 200: List with single team
             */
            teams.get(Int.self) { request, teamId in
                return try JSON(node: [
                    "teams": [
                        teamStub(id: Node(teamId))
                    ]])
            }
            
            /**
             Update team with `id`
             
             `PUT: /teams/<id>`
             
             - Parameter id:        Int identifier of a team.
             - Parameter <body>:    JSON with changed values.
             
             - Returns 200: List with updated team
             */
            teams.put(Int.self) { request, teamId in
                return try JSON(node: [
                    "teams": [
                        teamStub(id: Node(teamId))
                    ]])
            }
            
            /**
             Delete team with `id`
             
             `DELETE: /teams/<id>`
             
             - Parameter id:    Int identifier of a team.
             
             - Returns 204: Empty response
             */
            teams.delete(Int.self) { request, teamId in
                return Response(status: .noContent)
            }
        }
    }
}
