import Vapor
import HTTP
import Routing

/**
 Routes for `/manage` service
 */
class V1ManageCollection: RouteCollection {
    typealias Wrapped = HTTP.Responder
    func build<B: RouteBuilder>(_ builder: B) where B.Value == Wrapped {
        let v1 = builder.grouped("manage/v1")
        
        /**
         Routes group for `/manage/v1/projects`
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
             Create new project
             
             `POST: /projects`
             
             - Parameter <body>:    JSON with values.
             
             - Returns 201: Created project
             */
            projects.post { request in
                return try Response(status: .created, json: JSON(node: [
                    "projects": [
                        projectStub(id: 2)
                    ]]))
            }
            
            /**
             Get all projects
             
             `GET: /projects`
             
             - Returns 200: List of projects
             */
            projects.get { request in
                return try JSON(node: [
                    "projects": [
                        projectStub(id: 1),
                        projectStub(id: 2)
                    ],
                    "_meta": ["total": 2, "limit": 10, "offset": 0]
                    ])
            }
            
            /**
             Get project with `id`
             
             `GET: /projects/<id>`
             
             - Parameter id:    Int identifier of a project.
             
             - Returns 200: List with single project
             */
            projects.get(Int.self) { request, projectId in
                return try JSON(node: [
                    "projects": [
                        projectStub(id: Node(projectId))
                    ]])
            }
            
            /**
             Update project with `id`
             
             `PUT: /projects/<id>`
             
             - Parameter id:        Int identifier of a project.
             - Parameter <body>:    JSON with changed values.
             
             - Returns 200: List with updated project
             */
            projects.put(Int.self) { request, projectId in
                return try JSON(node: [
                    "projects": [
                        projectStub(id: Node(projectId))
                    ]])
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
        
        /**
         Routes group for `/manage/v1/tags`
         */
        v1.group("tags") { tags in
            func tagStub(id: Node) -> Node {
                // TODO: Remove after implementation
                return .object([
                    "id": id,
                    "name": "StubTag",
                    "level": 0
                    ])
            }
            
            /**
             Create new tag
             
             `POST: /tags`
             
             - Parameter <body>:    JSON with values.
             
             - Returns 201: Created tag
             */
            tags.post { request in
                return try Response(status: .created, json: JSON(node: [
                    "tags": [
                        tagStub(id: 2)
                    ]]))
            }
            
            /**
             Get all tags
             
             `GET: /tags`
             
             - Returns 200: List of tags
             */
            tags.get { request in
                return try JSON(node: [
                    "tags": [
                        tagStub(id: 1),
                        tagStub(id: 2)
                    ],
                    "_meta": ["total": 2, "limit": 10, "offset": 0]
                    ])
            }
            
            /**
             Get tag with `id`
             
             `GET: /tags/<id>`
             
             - Parameter id:    Int identifier of a tag.
             
             - Returns 200: List with single tag
             */
            tags.get(Int.self) { request, tagId in
                return try JSON(node: [
                    "tags": [
                        tagStub(id: Node(tagId))
                    ]])
            }
            
            /**
             Update tag with `id`
             
             `PUT: /tags/<id>`
             
             - Parameter id:        Int identifier of a tag.
             - Parameter <body>:    JSON with changed values.
             
             - Returns 200: List with updated tag
             */
            tags.put(Int.self) { request, tagId in
                return try JSON(node: [
                    "tags": [
                        tagStub(id: Node(tagId))
                    ]])
            }
            
            /**
             Delete tag with `id`
             
             `DELETE: /tags/<id>`
             
             - Parameter id:    Int identifier of a tag.
             
             - Returns 204: Empty response
             */
            tags.delete(Int.self) { request, tagId in
                return Response(status: .noContent)
            }
        }
    }
}
