@_exported import Vapor
import VaporPostgreSQL

public func setup(_ drop: Droplet) throws {
    try setupMiddleware(drop)
    try setupProviders(drop)
    try setupModels(drop)
    try setupRoutes(drop)
    try setupResources(drop)
}

private func setupMiddleware(_ drop: Droplet) throws {
    drop.middleware.insert(CORSMiddleware(), at: 0)
}

private func setupProviders(_ drop: Droplet) throws {
    try drop.addProvider(VaporPostgreSQL.Provider.self)
}

private func setupModels(_ drop: Droplet) throws {
    /*
     drop.preparations += [
     Post.self
     ]
    */
}

private func setupRoutes(_ drop: Droplet) throws {
    drop.collection(V1PublicCollection())
    drop.collection(V1ManageCollection())
    drop.collection(V1AdminCollection())
}

private func setupResources(_ drop: Droplet) throws {
    /*
     drop.resource("posts", PostController())
     */
}
