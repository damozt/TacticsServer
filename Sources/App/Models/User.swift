//
//  User.swift
//  App
//
//  Created by Kevin Damore on 5/7/19.
//

import Vapor
import FluentPostgreSQL

struct User: PostgreSQLModel, Migration, Content {
    
    var id: Int?
    let firebaseId: String
    let name: String
    let mmr: Int
}

struct PublicUser: Content {
    
    let id: Int?
    let name: String
    let mmr: Int
    
    init(user: User) {
        id = user.id
        name = user.name
        mmr = user.mmr
    }
}

struct CreateUser: Content {
    let name: String
}
