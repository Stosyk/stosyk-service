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
             
             `/projects?since=timestamp`
             
             - Parameter since: Unix timestamp, allows filtering by update time. (Optional)

             - Returns: List of projects
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
             
             `/projects/<id>`
             
             - Parameter id:    Int identifier of a project.
             
             - Returns: Project
             */
            projects.get(Int.self) { request, projectId in
                return try JSON(node: projectStub(id: 2))
            }
            
            /**
             Get translations for project with `id`
             
             `/projects/<id>/<locale>?since=timestamp`
             
             - Parameter id:        Int identifier of a project.
             - Parameter locale:    Locale identifier (e.g. 'en', 'de', etc.) for translations.
             - Parameter since:     Unix timestamp, allows filtering by update time. (Optional)
             
             - Returns: List of translations as a key-value structure
             */
            projects.get(Int.self, String.self) { request, projectId, locale in
                var meta: Node = ["total": 2]
                
                if let since = request.query?["since"] {
                    meta["since"] = since
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
