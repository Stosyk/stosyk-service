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
         Routes group for `/admin/v1/projects`
         */
        v1.group("projects") { projects in
            func projectStub(id: Node) -> Node {
                // TODO: Remove after implementation
                return .object(["id": id, "name": "StubProject"])
            }
            
            /**
             Create new project
             
             `POST: /projects`
             
             - Parameter <body>:    JSON with values.
             
             - Returns 201: Created project
             */
            projects.post { request in
                return try Response(status: .created, json: JSON(node: projectStub(id: 2)))
            }
            
            /**
             Get all projects.
             
             `GET: /projects?since=timestamp`
             
             - Parameter since: Unix timestamp, allows filtering by update time. (Optional)
             
             - Returns 200: List of projects
             */
            projects.get { request in
                var meta: Node = ["total": 2, "limit": 10, "offset": 0]
                
                if let since = request.query?["since"] {
                    meta["since"] = since
                }
                
                return try JSON(node: [
                    "projects": [
                        projectStub(id: 1),
                        projectStub(id: 2)
                    ],
                    "_meta": meta
                    ])
            }
            
            /**
             Get project with `id`
             
             `GET: /projects/<id>`
             
             - Parameter id:    Int identifier of a project.
             
             - Returns 200: Project
             */
            projects.get(Int.self) { request, projectId in
                return try JSON(node: projectStub(id: 2))
            }
            
            /**
             Update project with `id`
             
             `PUT: /projects/<id>`
             
             - Parameter id:        Int identifier of a project.
             - Parameter <body>:    JSON with changed values.
             
             - Returns 200: Updated project
             */
            projects.put(Int.self) { request, projectId in
                return try JSON(node: projectStub(id: 2))
            }
            
            /**
             Delete project with `id`
             
             `DELETE: /projects/<id>`
             
             - Parameter id:    Int identifier of a project.
             
             - Returns 204: Empty response
             */
            projects.delete(Int.self) { request, projectId in
                return Response(status: .noContent)
            }
        }
    }
}
