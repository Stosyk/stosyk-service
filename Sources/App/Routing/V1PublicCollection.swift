import Vapor
import HTTP
import Routing


class V1PublicCollection: RouteCollection {
    typealias Wrapped = HTTP.Responder
    func build<B: RouteBuilder>(_ builder: B) where B.Value == Wrapped {
        let v1 = builder.grouped("v1")
        let users = v1.grouped("users")
        
        users.get { request in
            return "Requested all users."
        }
    }
}
