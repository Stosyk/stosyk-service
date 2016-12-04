import Vapor


let drop = Droplet()
let v1Public = V1PublicCollection()
let v1Admin = V1AdminCollection()
let v1Manage = V1ManageCollection()

drop.collection(v1Public)
drop.collection(v1Admin)
drop.collection(v1Manage)

drop.get("/") { request in
    return "Hello Stosyk!"
}

drop.run()
