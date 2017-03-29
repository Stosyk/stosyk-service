@_exported import Vapor

public func setup(_ drop: Droplet) throws {
    try setupProviders(drop)
    try setupModels(drop)
    try setupRoutes(drop)
    try setupResources(drop)
}

private func setupProviders(_ drop: Droplet) throws {

}

private func setupModels(_ drop: Droplet) throws {
    /*
     drop.preparations += [
     Post.self
     ]
    */
}

private func setupRoutes(_ drop: Droplet) throws {
    drop.get("/") { request in
        return "Hello Stosyk!"
    }
    
    drop.collection(V1PublicCollection())
    drop.collection(V1AdminCollection())
    drop.collection(V1ManageCollection())
}

private func setupResources(_ drop: Droplet) throws {
    /*
     drop.resource("posts", PostController())
     */
}
