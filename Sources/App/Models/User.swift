//
//  User.swift
//  App
//
//  Created by Kevin Damore on 5/7/19.
//

import Vapor
import FluentPostgreSQL

struct User: PostgreSQLModel {
    
    var id: Int?
    let firebaseId: String
    let name: String
    var mmr: Int
    
    var heroes: Children<User, Hero> {
        return children(\.userId)
    }
    
    var publicUser: PublicUser {
        return PublicUser(id: id, name: name, mmr: mmr)
    }
    
    func battleUser(`init`: String) -> BattleUser {
        return BattleUser(id: id, name: name, init: `init`)
    }
}

extension User: Migration {}
extension User: Content {}

struct PublicUser: Content {

    let id: Int?
    let name: String
    let mmr: Int
}

struct CreateUser: Content {
    let name: String
}
