@_exported import Vapor
import VaporPostgreSQL

public func setup(_ drop: Droplet) throws {
    try setupMiddleware(drop)
    try setupProviders(drop)
    try setupModels(drop)
    try setupRoutes(drop)
}

private func setupMiddleware(_ drop: Droplet) throws {
    drop.middleware.insert(CORSMiddleware(), at: 0) // TODO: setup for certain swagger domain
}

private func setupProviders(_ drop: Droplet) throws {
    try drop.addProvider(VaporPostgreSQL.Provider.self)
}

private func setupModels(_ drop: Droplet) throws {
    drop.preparations += [
        Team.self
    ]
}

private func setupRoutes(_ drop: Droplet) throws {
    drop.collection(V1PublicCollection())
    drop.collection(V1ManageCollection())
    drop.collection(V1AdminCollection())
}
