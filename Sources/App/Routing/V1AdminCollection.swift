import Vapor
import HTTP
import Routing


class V1AdminCollection: RouteCollection {
    typealias Wrapped = HTTP.Responder
    func build<B: RouteBuilder>(_ builder: B) where B.Value == Wrapped {
        let v1 = builder.grouped("admin/v1")
        
        v1.get { request in
            return "Not implemented"
        }
    }
}
