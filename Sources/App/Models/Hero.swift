//
//  Hero.swift
//  App
//
//  Created by Kevin Damore on 5/10/19.
//

import Vapor
import FluentPostgreSQL

struct Hero: PostgreSQLModel {
    
    var id: Int?
    let userId: Int
    let type: Int
    var name: String
    var exp: Int
    var unlockedActionIds: String
    
    static func newHero(from hero: CreateHero) -> Hero {
        return Hero(id: nil, userId: hero.userId, type: hero.type, name: hero.name, exp: 0, unlockedActionIds: "[]")
    }
}

extension Hero: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: conn) { (builder) in
            try addProperties(to: builder)
            builder.reference(from: \.userId, to: \User.id, onDelete: ._cascade)
        }
    }
}

extension Hero: Content {}
extension Hero: Parameter {}

struct GetHeroes: Content {
    let ids: [Int]
}

struct CreateHero: Content {
    let userId: Int
    let name: String
    let type: Int
}
