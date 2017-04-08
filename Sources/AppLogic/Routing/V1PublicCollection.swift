import Vapor
import HTTP
import Routing

/**
 Routes for `/api` service
 */
final class V1PublicCollection: RouteCollection {
    typealias Wrapped = HTTP.Responder
    func build<B: RouteBuilder>(_ builder: B) where B.Value == Wrapped {
        let v1 = builder.grouped("v1")
        
        /**
         Routes group for `/api/v1/projects`
         */
        v1.group("projects") { projects in
            func projectStub(id: Node) -> Node {
                // TODO: Remove after implementation
                return .object([
                        "id": id,
                        "name": "StubProject"
                    ])
            }
            
            /**
             Get all projects.
             
             `GET: /projects?since=timestamp`
             
             - Parameter since: Unix timestamp, allows filtering by update time. (Optional)

             - Returns 200: List of projects
             */
            projects.get { request in
                var meta: Node = ["total": 2, "limit": 10, "offset": 0]
                
                if let since = request.query?["since"]?.int {
                    meta["since"] = Node(since)
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
                return try JSON(node: [
                    "projects": [
                        projectStub(id: Node(projectId))
                    ]])
            }
            
            /**
             Get translations in `locale` for project with `id`
             
             `GET: /projects/<id>/translations/<locale>?since=timestamp`
             
             - Parameter id:        Int identifier of a project.
             - Parameter locale:    Locale identifier (e.g. 'en', 'de', etc.) for translations.
             - Parameter since:     Unix timestamp, allows filtering by update time. (Optional)
             
             - Returns 200: List of translations as a key-value structure
             */
            projects.get(Int.self, "translations", String.self) { request, projectId, locale in
                var meta: Node = ["total": 2]
                
                if let since = request.query?["since"]?.int {
                    meta["since"] = Node(since)
                }
                
                return try JSON(node: [
                    "translations": [
                        "main.title": "Main",
                        "main.sub": ""
                    ],
                    "_meta": meta
                    ])
            }
        }
    }
}
