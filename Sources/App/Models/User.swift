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
    var color1: String
    var color2: String
    var currency: Int
    var mmr: Int
    var fcmId: String
    
    var heroes: Children<User, Hero> {
        return children(\.userId)
    }
    
    var publicUser: PublicUser {
        return PublicUser(id: id, name: name, color1: color1, color2: color2, currency: currency, mmr: mmr, fcmId: fcmId)
    }
    
//    func battleUser(heroInits: [HeroInit]) -> BattleUser {
//        return BattleUser(id: id, name: name, heroInits: heroInits)
//    }
}

extension User: Migration {}
extension User: Content {}

struct PublicUser: Content {

    let id: Int?
    let name: String
    let color1: String
    let color2: String
    let currency: Int
    let mmr: Int
    let fcmId: String
}

struct CreateUser: Content {
    let name: String
    let color1: String
    let color2: String
    let fcmId: String
}
