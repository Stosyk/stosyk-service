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
            
            /**
             Create translations for project with `id`
             
             `POST: /projects/<id>/translations`
             
             - Parameter id:        Int identifier of a project.
             - Parameter <body>:    JSON dictionary with new translations.
             
             - Returns 201: List of new translations as a key-value structure
             */
            projects.post(Int.self, "translations") { request, projectId in
                let json = try JSON(node: [
                    "translations": [
                        "main.title": "Main",
                    ],
                    "_meta": ["total": 1]
                    ])
                return try Response(status: .created, json: json)
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
            
            /**
             Update translations in `locale` for project with `id`
             
             `PUT: /projects/<id>/translations/<locale>`
             
             - Parameter id:        Int identifier of a project.
             - Parameter locale:    Locale identifier (e.g. 'en', 'de', etc.) for translations.
             - Parameter <body>:    JSON dictionary with new translations.
             
             - Returns 200: List of new translations as a key-value structure
             */
            projects.put(Int.self, "translations", String.self) { request, projectId, locale in
                return try JSON(node: [
                    "translations": [
                        "main.title": "Main",
                    ],
                    "_meta": ["total": 1]
                    ])
            }
            
            /**
             Delete translations from project with `id`
             
             `DELETE: /projects/<id>/translations`
             
             - Parameter id:        Int identifier of a project.
             - Parameter <body>:    JSON array with keys which has to be removed.
             
             - Returns 204: Empty response
             */
            projects.delete(Int.self, "translations") { request, projectId in
                return Response(status: .noContent)
            }
        }
    }
}
