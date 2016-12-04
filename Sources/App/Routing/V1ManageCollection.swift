import Vapor
import HTTP
import Routing


class V1ManageCollection: RouteCollection {
    typealias Wrapped = HTTP.Responder
    func build<B: RouteBuilder>(_ builder: B) where B.Value == Wrapped {
        let v1 = builder.grouped("manage/v1")
        
        v1.get { request in
            return "Not implemented"
        }
    }
}
