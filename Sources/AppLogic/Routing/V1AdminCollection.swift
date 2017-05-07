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
        
        v1.resource(Team.Key.table, TeamController())
        v1.resource(User.Key.table, UserController())
    }
}
